#include "lib/Dialect/Diss/Dialect/DissOps.h"
#include "lib/Dialect/Diss/Dialect/DissTypes.h"
#include "lib/Dialect/Diss/Dialect/DissDialect.h"
#include "lib/Dialect/Diss/Transforms/Passes.h"
#include "mlir/include/mlir/Dialect/Arith/IR/Arith.h"

#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Matchers.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include <memory>



#define GEN_PASS_DEF_REORDERELEMENTWISE
#include "lib/Dialect/Diss/Transforms/DissPasses.h.inc"

namespace mlir{
namespace diss{


struct ReorderElementwiseExpandPattern : public OpTraitRewritePattern<OpTrait::Elementwise>{
    ReorderElementwiseExpandPattern(MLIRContext *context) : OpTraitRewritePattern(context){}

    LogicalResult matchAndRewrite(Operation *op, PatternRewriter &rewriter) const override {

        auto loc = op->getLoc();
        auto operands = op->getOperands();
        
        
        llvm::SmallVector<Value, 4> newOperands;
        bool seenExpand = false;
        for (auto operand : operands) {
            auto defOp = operand.getDefiningOp();

            DenseElementsAttr constAttr;
            if (!defOp) {
                return failure();
            }
            if (auto expOp = llvm::dyn_cast<Expand>(defOp)){
                seenExpand = true;
                newOperands.push_back(expOp.getInput());
            }
            else if ((matchPattern(defOp, m_Constant(&constAttr)) && (constAttr.isSplat()))){
                auto value = constAttr.getSplatValue<Attribute>();
                newOperands.push_back(arith::ConstantOp::materialize(rewriter, value, constAttr.getElementType(), loc));
            }
        }
        if (!seenExpand) {
            return failure();
        }
        llvm::SmallVector<Type, 4> newResTy;
        auto resultTypes = op->getResultTypes();
        for (auto ty : resultTypes) {
            auto elemTy = llvm::dyn_cast<RankedTensorType>(ty).getElementType();
            newResTy.push_back(elemTy);
            
        }
        OperationState newElementwise(op->getLoc(), op->getName());
        newElementwise.addOperands(newOperands);
        newElementwise.addTypes(newResTy);
        newElementwise.addAttributes(op->getAttrs());

        auto newOp = rewriter.create(newElementwise);

        auto newRes = rewriter.create<Expand>(loc, resultTypes[0], newOp->getResult(0));

        rewriter.replaceOp(op, newRes);
        return success();

    }
};


// elementwise(broadcast(a)) -> broadcast(elementwise(a))
struct ReorderElementwiseBroadcastPattern : public OpTraitRewritePattern<OpTrait::Elementwise>{
    
    ReorderElementwiseBroadcastPattern(MLIRContext *context) :  OpTraitRewritePattern(context) {}

    LogicalResult matchAndRewrite(Operation *op, PatternRewriter &rewriter) const override {
        
        auto operands = op->getOperands();
        bool seenBroadcast = false;
        ArrayRef<int64_t> shape;

        auto getInputShape = [&](Broadcast operation){
            return operation.getInput().getType().getShape();
        };

        for (auto operand : operands) {
            auto definingOp = operand.getDefiningOp();
            if (!definingOp) {
                return failure();
            }
            
            if (auto broadcastOp = llvm::dyn_cast<Broadcast>(definingOp)){

                if (!seenBroadcast){
                    seenBroadcast = true;
                    shape = getInputShape(broadcastOp);

                }else if (shape != getInputShape(broadcastOp)){

                    return failure();
                }
            }
            

        }


        if (!seenBroadcast){
            return failure();
        };

        auto loc = op->getLoc();
        
        Broadcast broadcastOp;
        for (auto operand : operands) {
            broadcastOp = operand.getDefiningOp<Broadcast>();
            if (broadcastOp){
                break;
            }
        }

        // input dim
        auto inputTy = broadcastOp.getInput().getType();
        auto inputShape = inputTy.getShape();
        auto inputEncoding = inputTy.getEncoding();

        // obtaining broadcast inputs
        llvm::SmallVector<Value, 4> newOperands;
        for (auto operand : operands) {
            auto defOp = operand.getDefiningOp();
            if (auto broadcastInputOp = llvm::dyn_cast<Broadcast>(defOp)){
                newOperands.push_back(broadcastInputOp.getInput());
            }
        }

        /*
        newOperands :=  tensor<128x1xf32> y tensor<128x1xf32>
        */

        // changing tensor size to pre-broadcast 
        llvm::SmallVector<Type, 4> newResultTypes;
        auto resultTypes = op->getResultTypes(); // group of tensors
        for (auto resultTy : resultTypes) {
            auto elemTy = llvm::dyn_cast<RankedTensorType>(resultTy).getElementType(); //element type of tensor
            newResultTypes.push_back(
                RankedTensorType::get(inputShape, elemTy, inputEncoding)
            );
        }
        
         /*
        newResultTypes :=  tensor<128x1xf32>
        */

        OperationState newElementwise(op->getLoc(), op->getName());
        newElementwise.addOperands(newOperands);
        newElementwise.addTypes(newResultTypes);
        newElementwise.addAttributes(op->getAttrs());

        auto newOp = rewriter.create(newElementwise); // with pre-broadcast shape and broadcast inputs
        
        
        auto newRes = rewriter.create<Broadcast>(loc, resultTypes[0], newOp->getResult(0));
        rewriter.replaceOp(op, newRes);


        // for (auto operand : operands) {
        //     auto defOp = operand.getDefiningOp();
        //     if (auto broadcastInputOp = llvm::dyn_cast<Broadcast>(defOp)){
                
        //         rewriter.eraseOp(defOp);

                
        //     }
        // }

        return success();
    }
};


class ReorderElementWisePass : public ::impl::ReorderElementWiseBase<ReorderElementWisePass>{
    public:

    void runOnOperation() override {
        MLIRContext *context = &getContext();
        RewritePatternSet patterns(context);
        auto *module = getOperation();

        patterns.add<ReorderElementwiseBroadcastPattern>(context);
        patterns.add<ReorderElementwiseExpandPattern>(context);


        if (applyPatternsGreedily(module, std::move(patterns)).failed())
      signalPassFailure();
    }
};


std::unique_ptr<mlir::Pass> createReorderElementWise() {
    return std::make_unique<ReorderElementWisePass>();
}



} // namespace diss
} // namespace mlir