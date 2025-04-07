// #ifndef DISS_ATTR_DEFS
// #define DISS_ATTR_DEFS

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"


def Diss_IdAxis : I32EnumAttr<"IdAxis", "",
[I32EnumAttrCase<"X", 0, "x">,
I32EnumAttrCase<"Y", 1, "y">,
I32EnumAttrCase<"Z", 2, "z">,]
> {
    let cppNamespace = "::mlir::diss";
}



// #endif