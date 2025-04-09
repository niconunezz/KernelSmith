// RUN: diss-opt %s -reorder-elementwise > %t
// RUN: FileCheck %s < %t
module {
    // CHECK-LABEL: func.func @test_reorder_elementwise
    func.func @test_reorder_elementwise(%arg0: !diss.ptr<i32>) -> tensor<1024x1024xi32> {
        
        %0 = diss.expand %arg0: !diss.ptr<i32> -> tensor<1024x1x!diss.ptr<i32>>
        // CHECK: diss.ptr_to_int
        // CHECK-NEXT: diss.broadcast
        %1 = diss.broadcast %0: tensor<1024x1x!diss.ptr<i32>> -> tensor<1024x1024x!diss.ptr<i32>> 
        %2 = diss.ptr_to_int %1 : tensor<1024x1024x!diss.ptr<i32>> -> tensor<1024x1024xi32>

        return %2: tensor<1024x1024xi32>
    } 
}