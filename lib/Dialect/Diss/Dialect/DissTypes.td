include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinTypeInterfaces.td"

class Diss_Type<string name, string typeMnemonic> : TypeDef<Diss_Dialect, name> {
    let mnemonic = typeMnemonic;
}

def Diss_Pointer : Diss_Type<"Diss_Pointer", "ptr"> {
  let summary = "A typed pointer type representing device memory addresses";

  let description = [{
    The `Pointer` type represents a memory address in device (GPU) memory space,
    with explicit type semantics for memory access operations. Key characteristics:

    The assembly format requires explicit type specification in angle brackets:
    `!diss.ptr<f32>`  // Pointer to 32-bit float
    `!diss.ptr<i32>`  // Pointer to 32-bit integer
  }];

  let parameters = (ins "Type":$dtype);
  let assemblyFormat = "`<` $dtype `>`";
}

def Diss_PtrTensor : RankedTensorOf<[Diss_Pointer]>;

def Diss_PtrObj : AnyTypeOf<[Diss_Pointer, Diss_PtrTensor]>;

def Diss_Int : AnyTypeOf<[I32, I64], "int">;
def Diss_IntTensor : RankedTensorOf<[Diss_Int]>;


def Diss_Float : AnyTypeOf<[F16, F32], "float">;
def Diss_FloatTensor: RankedTensorOf<[Diss_Float]>;

def Diss_Tensor : AnyTypeOf<[Diss_IntTensor, Diss_FloatTensor, Diss_PtrTensor]>;

def Diss_Scalar : AnyTypeOf<[Diss_Int, Diss_Float, Diss_Pointer]>;
def Diss_Type : AnyTypeOf<[Diss_Int, Diss_Pointer, Diss_Float, Diss_IntTensor, Diss_FloatTensor, Diss_PtrTensor]>;

// def Diss