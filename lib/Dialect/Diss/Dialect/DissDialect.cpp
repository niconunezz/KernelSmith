#include "lib/Dialect/Diss/Dialect/DissDialect.h"
#include "lib/Dialect/Diss/Dialect/DissOps.h"
#include "lib/Dialect/Diss/Dialect/DissTypes.h"

#include "mlir/include/mlir/IR/Builders.h"
#include "llvm/include/llvm/ADT/TypeSwitch.h"

#include "lib/Dialect/Diss/Dialect/DissOpsEnums.cpp.inc"

#include "lib/Dialect/Diss/Dialect/DissDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "lib/Dialect/Diss/Dialect/DissTypes.cpp.inc"

#define GET_OP_CLASSES
#include "lib/Dialect/Diss/Dialect/DissOps.cpp.inc"


namespace mlir{
namespace diss{
    
    void DissDialect::initialize() {
        addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Diss/Dialect/DissTypes.cpp.inc"
        >();
        
        addOperations<
#define GET_OP_LIST
#include "lib/Dialect/Diss/Dialect/DissOps.cpp.inc"
        >();
    }
    
    
} // namespace diss
} // namespace mlir