// #ifndef DISS_OPS_DEFS
// #define DISS_OPS_DEFS

include "DissDialect.td"
include "DissTypes.td"
include "DissAttrDefs.td"

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Diss_GetId : Op<Diss_Dialect, "get_id"> {
    let arguments = (ins Diss_IdAxis:$coordenate);
    let results = (outs I32:$pid);

    let assemblyFormat = "attr-dict $coordenate `:` type($pid)";
}

// #endif