#include "lib/Dialect/Diss/Dialect/DissDialect.h"
#include "mlir/include/mlir/InitAllDialects.h"
#include "mlir/include/mlir/InitAllPasses.h"
#include "mlir/include/mlir/Pass/PassManager.h"
#include "mlir/include/mlir/Pass/PassRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv){
    mlir::DialectRegistry registry;
    registry.insert<mlir::diss::DissDialect>();
    mlir::registerAllDialects(registry);
    mlir::registerAllPasses();
    return mlir::asMainReturnCode(
        mlir::MlirOptMain(argc, argv, "Pass driver", registry));
}