set(LLVM_TARGET_DEFINITIONS DissTypes.td)
mlir_tablegen(DissTypes.h.inc -gen-typedef-decls -dialect=diss)
mlir_tablegen(DissTypes.cpp.inc -gen-typedef-defs -dialect=diss)

mlir_tablegen(DissDialect.h.inc -gen-dialect-decls -dialect=diss)
mlir_tablegen(DissDialect.cpp.inc -gen-dialect-defs -dialect=diss)

add_mlir_doc(DissDialect DissDialect DissDialect/ -gen-dialect-doc)

add_public_tablegen_target(MLIRDialectCanonicalizationIncGen)
add_mlir_dialect_library(MLIRDiss
    DissDialect.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/lib/Dialect/Diss

    LINK_LIBS PUBLIC
    MLIRIR
    MLIRSupport
)
