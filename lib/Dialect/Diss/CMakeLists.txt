set(LLVM_TARGET_DEFINITIONS DissOps.td)

mlir_tablegen(DissOps.h.inc -gen-op-decls)
mlir_tablegen(DissOps.cpp.inc -gen-op-defs)

mlir_tablegen(DissTypes.h.inc -gen-typedef-decls -dialect=diss)
mlir_tablegen(DissTypes.cpp.inc -gen-typedef-defs -dialect=diss)

mlir_tablegen(DissDialect.h.inc -gen-dialect-decls -dialect=diss)
mlir_tablegen(DissDialect.cpp.inc -gen-dialect-defs -dialect=diss)


add_mlir_doc(DissDialect DissDialect DissDialect/ -gen-dialect-doc)

add_public_tablegen_target(MLIRDialectCanonicalizationIncGen)
# add_dependencies(mlir-headers MLIRDissOpsIncGen)

add_mlir_dialect_library(MLIRDiss
    DissDialect.cpp
    DissOps.cpp


    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/lib/Dialect/Diss

    LINK_LIBS PUBLIC
    MLIRIR
    MLIRSupport
)
