// #ifndef DISS_OPS_DEFS
// #define DISS_OPS_DEFS

include "DissDialect.td"
include "DissTypes.td"
include "DissAttrDefs.td"

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Diss_GetId : Op<Diss_Dialect, "get_id", [Pure]> {
    let arguments = (ins Diss_IdAxis:$coordenate);
    let results = (outs I32:$pid);

    let assemblyFormat = "attr-dict $coordenate `:` type($pid)";
}

def Diss_Range : Op<Diss_Dialect, "range", [Pure]> {
    let arguments = (ins I32Attr:$begin, I32Attr:$end);
    let results = (outs Diss_IntTensor:$res);
    let assemblyFormat = "attr-dict `:` type($res)";
}

def Diss_PtrToInt : Op<Diss_Dialect, "ptr_to_int", [Elementwise]> {
    let arguments = (ins Diss_AllPtr:$src);
    let results = (outs Diss_AllInt:$out);
    let assemblyFormat = "$src attr-dict `:` type($src) `->` type($out)";
}

def Diss_IntToPtr : Op<Diss_Dialect, "int_to_ptr", [Elementwise, Pure]> {
    let arguments = (ins Diss_AllInt:$src);
    let results = (outs Diss_AllPtr:$out);
    let assemblyFormat = "$src attr-dict `:` type($src) `->` type($out)";
}

def Diss_Expand : Op<Diss_Dialect, "expand", [Pure, SameOperandsAndResultElementType]> {
    let arguments = (ins Diss_Scalar:$input);
    let results = (outs Diss_Tensor:$res);
    let assemblyFormat = "$input attr-dict `:` type($input) `->` type($res)";
}

def Diss_Broadcast : Op<Diss_Dialect, "broadcast", [Pure, SameOperandsAndResultElementType]> {
    let arguments = (ins Diss_Tensor:$input);
    let results = (outs Diss_Tensor:$res);
    let assemblyFormat = "$input attr-dict `:` type($input) `->` type($res)";
}



def Diss_Load : Op<Diss_Dialect, "load"> {
    let arguments = (ins Diss_Tensor:$input);
    let results = (outs Diss_Tensor:$output);
    let assemblyFormat = "$input attr-dict `:` type($input) `->` type($output)";
}

def Diss_Store : Op<Diss_Dialect, "save"> {
    let arguments = (ins Diss_Tensor:$pointers, Diss_Tensor:$value);

    let assemblyFormat = "$pointers `,` $value attr-dict `:` type($pointers) `,` type($value)";
}

class Diss_BinPtrOps<string mnemonic> : Op<Diss_Dialect, mnemonic, [Elementwise]> {
    let arguments = (ins Diss_Type:$lhs, Diss_Type:$rhs);
    let results = (outs Diss_PtrObj:$output);

    let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($lhs) `,` type($rhs) `->` type($output)";
}
def Diss_SumPointer : Diss_BinPtrOps<"sum_ptr"> {}