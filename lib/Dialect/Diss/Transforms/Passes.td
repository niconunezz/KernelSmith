include "mlir/Pass/PassBase.td"

def ReorderElementWise : Pass<"reorder-elementwise"> {
    let summary = "reorder elementwise ops if there is a broadcast or expand op before";
    let description = "";

    let dependentDialects = [
        "mlir::diss::DissDialect",
    ];
}