#include "lib/Dialect/Diss/DissDialect.h"
#include "lib/Dialect/Diss/DissTypes.h"
#include "mlir/include/mlir/IR/Builders.h"
#include "llvm/include/llvm/ADT/TypeSwitch.h"

#include "lib/Dialect/Diss/DissDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "lib/Dialect/Diss/DissTypes.cpp.inc"

namespace mlir{
namespace diss{
    
    void DissDialect::initialize() {
        addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Diss/DissTypes.cpp.inc"
        >();
        
    }
    
    
} // namespace diss
}// namespace mlir