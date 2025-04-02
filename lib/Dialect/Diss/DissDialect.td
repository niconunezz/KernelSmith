include "mlir/Pass/PassBase.td"
include "mlir/IR/DialectBase.td"

def DissDialect : Dialect {
  let name = "diss";
  let summary = "A dialect for GPU machine learning ops";

  let description = [{
    The `DissDialect` provides a set of operations and types for representing and
    optimizing GPU-accelerated machine learning workloads. It is designed to:

    * Express high-performance ML computations with GPU-specific optimizations.
    * Enable efficient lowering to target-specific GPU backends (e.g., CUDA, ROCm).
    * Support tensor computations with specialized memory layouts for GPU memory hierarchy.
    * Integrate with MLIR's compiler infrastructure for transformations and analysis.

    The dialect focuses on operations commonly found in deep learning models,
    including:
    - GPU-accelerated tensor operations (matmul, convolutions, reductions)
    - Memory management operations (device allocations, copies)
    - Synchronization primitives for GPU execution
    - Custom operations for ML model serving optimizations

    Key features include:
    * Native support for mixed-precision computations
    * Integration with MLIR's bufferization and GPU lowering pipelines
    * Annotations for kernel fusion and tiling strategies
  }];

    let useDefaultTypePrinterParser = 1;
    let cppNamespace = "::mlir::diss";
}