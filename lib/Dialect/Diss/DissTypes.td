include "mlir/IR/AttrTypeBase.td"
include "lib/Dialect/Diss/DissDialect.td"
class Diss_Type<string name, string typeMnemonic> : TypeDef<DissDialect, name> {
    let mnemonic = typeMnemonic;
}


def Pointer : Diss_Type<"Pointer", "ptr"> {
  let summary = "A typed pointer type representing device memory addresses";

  let description = [{
    The `Pointer` type represents a memory address in device (GPU) memory space,
    with explicit type semantics for memory access operations. Key characteristics:

    * Always carries a pointee type (`dtype`) indicating what type it points to
    * Used for GPU memory operations (allocations, loads, stores)
    * May have different address space qualifiers (not shown in this basic definition)
    * Supports pointer arithmetic when used with appropriate operations

    The assembly format requires explicit type specification in angle brackets:
    `!diss.ptr<f32>`  // Pointer to 32-bit float
    `!diss.ptr<i32>`  // Pointer to 32-bit integer
  }];

  let parameters = (ins "Type":$dtype);
  let assemblyFormat = "`<` $dtype `>`";
}