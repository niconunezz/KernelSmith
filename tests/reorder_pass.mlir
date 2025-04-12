// RUN: diss-opt %s -reorder-elementwise > %t
// RUN: FileCheck %s < %t
module {
    // CHECK-LABEL: func.func @test_reorder_elementwise
    func.func @test_reorder_elementwise(%arg0: !diss.ptr<i32>) -> tensor<1024x1024xi32> {
        
        %0 = diss.expand %arg0: !diss.ptr<i32> -> tensor<1024x1x!diss.ptr<i32>>
        // CHECK: diss.ptr_to_int
        // CHECK-NEXT: diss.expand
        // CHECK-NEXT: diss.broadcast
        %1 = diss.broadcast %0: tensor<1024x1x!diss.ptr<i32>> -> tensor<1024x1024x!diss.ptr<i32>> 
        %2 = diss.ptr_to_int %1 : tensor<1024x1024x!diss.ptr<i32>> -> tensor<1024x1024xi32>

        return %2: tensor<1024x1024xi32>
    }


    func.func @test_broadcast_binary_op_pattern(%arg0: tensor<128x1xf32>, %arg1: tensor<128x1xf32>, %arg2: tensor<1x128xf32>) -> (tensor<128x128xf32>, tensor<128x128xf32>) {
        // CHECK: %[[mul:.*]] = arith.mulf %{{.*}}, %{{.*}} : tensor<128x1xf32>
        // CHECK-NEXT: %{{.*}} = diss.broadcast %[[mul]] : tensor<128x1xf32> -> tensor<128x128xf32>
        %broadcast0 = diss.broadcast %arg0 : tensor<128x1xf32> -> tensor<128x128xf32>
        %broadcast1 = diss.broadcast %arg1 : tensor<128x1xf32> -> tensor<128x128xf32>
        %mul = arith.mulf %broadcast0, %broadcast1 : tensor<128x128xf32>

        // CHECK: %[[mul:.*]] = arith.mulf %{{.*}}, %{{.*}} : tensor<128x128xf32>
        %broadcast2 = diss.broadcast %arg2 : tensor<1x128xf32> -> tensor<128x128xf32>
        %mul1 = arith.mulf %broadcast0, %broadcast2 : tensor<128x128xf32>
  
        return %mul, %mul1 : tensor<128x128xf32>, tensor<128x128xf32>
        
    }


    func.func @test_expand_elementwise_pattern(%arg0: f32) -> (tensor<128x128x!diss.ptr<f32>>, tensor<128x128xf32>) {
        %c1 = arith.constant 1 : i64
        %a = arith.constant dense<1.0> : tensor<128x128xf32>
        // CHECK: %[[expand:.*]] = diss.expand %{{.*}} : f32 -> tensor<128x128xf32>
        %b = diss.expand %arg0 : f32 -> tensor<128x128xf32>
        %add = arith.addf %a, %b : tensor<128x128xf32>
        // CHECK: diss.int_to_ptr %[[c1:.*]] : i64 -> !diss.ptr<f32>
        // CHECK-NEXT: %{{.*}} = diss.expand %[[ptr:.*]] : !diss.ptr<f32> -> tensor<128x128x!diss.ptr<f32>>
        %c1_t = diss.expand %c1 : i64 -> tensor<128x128xi64>
        %ptr = diss.int_to_ptr %c1_t : tensor<128x128xi64> -> tensor<128x128x!diss.ptr<f32>>

        return %ptr, %add : tensor<128x128x!diss.ptr<f32>>, tensor<128x128xf32> 
        }

}