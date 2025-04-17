set(LLVM_TARGET_DEFINITIONS DissGPUDialect.td)
mlir_tablegen(DissGPUDialect.h.inc -gen-dialect-decls)
mlir_tablegen(DissGPUDialect.cpp.inc -gen-dialect-defs)
add_public_tablegen_target(DissGPUTableGen)

add_mlir_dialect_library(MLIRDissGPU
    DissGPUDialect.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/lib/Dialect/DissGPU

    LINK_LIBS PUBLIC
    MLIRIR
    MLIRSupport
)

