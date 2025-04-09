add_mlir_library(Passes
Passes.cpp

${PROJECT_SOURCE_DIR}/lib/Conversion/
ADDITIONAL_HEADER_DIRS

DEPENDS
DissPassesPassIncGen

LINK_COMPONENTS
Core

LINK_LIBS PUBLIC
MLIRDiss
MLIRPass
MLIRTransforms
)

set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(DissPasses.h.inc -gen-pass-decls -name Passes)

add_public_tablegen_target(DissPassesPassIncGen)
add_mlir_doc(Passes Passes Passes/ -gen-pass-doc)
