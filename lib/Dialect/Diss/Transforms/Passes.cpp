#include "lib/Dialect/Diss/Dialect/DissOps.h"
#include "lib/Dialect/Diss/Dialect/DissTypes.h"
#include "lib/Dialect/Diss/Dialect/DissDialect.h"
#include "lib/Dialect/Diss/Transforms/Passes.h"

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


// elementwise(broadcast(a)) -> broadcast(elementwise(a))
struct ReorderElementwiseBroadcastPattern : public OpTraitRewritePattern<OpTrait::Elementwise>{
    
    ReorderElementwiseBroadcastPattern(MLIRContext *context) :  OpTraitRewritePattern(context) {}

    LogicalResult matchAndRewrite(Operation *op, PatternRewriter &rewriter) const override {
        
        auto operands = op->getOperands();
        bool seenBroadcast = false;
        ArrayRef<int64_t> srcShape;
        for (auto operand : operands) {
            auto definingOp = operand.getDefiningOp();
            if (!definingOp) {
                return failure();
            }
            auto getSrcShape = [](Broadcast b) {
                return b.getInput().getType().getShape();
            };

            if (auto broadcastOp = llvm::dyn_cast<Broadcast>(definingOp)){
                seenBroadcast = true;
                srcShape = getSrcShape(broadcastOp);
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

        // changing tensor size to pre-broadcast 
        llvm::SmallVector<Type, 4> newResultTypes;
        auto resultTypes = op->getResultTypes(); // group of tensors
        for (auto resultTy : resultTypes) {
            auto elemTy = llvm::dyn_cast<RankedTensorType>(resultTy).getElementType(); //element type of tensor
            newResultTypes.push_back(
                RankedTensorType::get(inputShape, elemTy, inputEncoding)
            );
        }
        
        OperationState newElementwise(op->getLoc(), op->getName());
        newElementwise.addOperands(newOperands);
        newElementwise.addTypes(newResultTypes);
        newElementwise.addAttributes(op->getAttrs());

        auto newOp = rewriter.create(newElementwise); // with pre-broadcast shape and broadcast inputs
        
        auto newRes = rewriter.create<Broadcast>(loc, resultTypes[0], newOp->getResult(0));
        rewriter.replaceOp(op, newRes);

        for (auto operand : operands) {
            auto defOp = operand.getDefiningOp();
            if (auto broadcastInputOp = llvm::dyn_cast<Broadcast>(defOp)){
                rewriter.eraseOp(defOp);
            }
        }


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

        if (applyPatternsGreedily(module, std::move(patterns)).failed())
      signalPassFailure();
    }
};


std::unique_ptr<mlir::Pass> createReorderElementWise() {
    return std::make_unique<ReorderElementWisePass>();
}

} // namespace diss
} // namespace mlir