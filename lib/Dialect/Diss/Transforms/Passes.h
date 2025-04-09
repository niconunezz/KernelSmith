#ifndef DISS_TRANSFORMS_PASSES
#define DISS_TRANSFORMS_PASSES

#include "mlir/Pass/Pass.h"


namespace mlir{
namespace diss{

    // std::unique_ptr<Pass> createReorderElementWise();
    
    
    #define GEN_PASS_DECL_REORDERELEMENTWISE
    #include "lib/Dialect/Diss/Transforms/DissPasses.h.inc"
    
    #define GEN_PASS_REGISTRATION
    #include "lib/Dialect/Diss/Transforms/DissPasses.h.inc"
}
}

#endif
