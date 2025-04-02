#ifndef LIB_DIALECT_DISS_DISSOPS_H_
#define LIB_DIALECT_DISS_DISSOPS_H_

#include "lib/Dialect/Diss/DissDialect.h"
// #include "lib/Dialect/Diss/DissTypes.h"
#include "mlir/Interfaces/InferTypeOpInterface.h" // from @llvm-project
#include "mlir/include/mlir/IR/BuiltinOps.h"      // from @llvm-project
#include "mlir/include/mlir/IR/BuiltinTypes.h"    // from @llvm-project
#include "mlir/include/mlir/IR/Dialect.h" 

#define GET_OP_CLASSES
#include "lib/Dialect/Diss/DissOps.h.inc"


#endif