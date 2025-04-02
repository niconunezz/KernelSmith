
include "DissDialect.td"
include "DissTypes.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Diss_GetId : Op<Diss_Dialect, "get_id"> {
    let summary = "op for getting block identificator";

    let arguments = (ins I32:$coordenate);
    let results = (outs I32:$pid);

    let assemblyFormat = "attr-dict $coordenate `:` type($pid)";
}