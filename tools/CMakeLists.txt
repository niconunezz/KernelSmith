get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

set (LIBS
    ${dialect_libs}
    ${conversion_libs}
    MLIRDiss
    MLIROptLib
    MLIRPass
    ortools::ortools
)

add_llvm_executable(diss-opt diss-opt.cpp)

llvm_update_compile_flags(diss-opt)
target_link_libraries(diss-opt PRIVATE ${LIBS})

mlir_check_all_link_libraries(diss-opt)