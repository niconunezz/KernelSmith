module {
    // CHECK-LABEL: test_type_syntax
    func.func @test_syntax(%arg0: !diss.ptr<i32>, %arg1: !diss.ptr<i32>, %arg2: !diss.ptr<i32>, %arg3: i32) -> tensor<1024xi32> {
        %0 = arith.constant 1024 : i32
        %1 = diss.get_id x : i32
        %2 = arith.muli %0, %1: i32

        %3 = diss.range {begin = 0 : i32, end = 1024 : i32} : tensor<1024xi32>
        %4 = diss.expand %1 : i32 -> tensor<1024xi32>

        %5 = arith.addi %3, %4 : tensor<1024xi32>
        %6 = diss.expand %arg3 : i32 -> tensor<1024xi32>

        %7 = diss.expand %arg0: !diss.ptr<i32> -> tensor<1024x!diss.ptr<i32>>
        %8 = diss.sum_ptr %7, %5 :  tensor<1024x!diss.ptr<i32>>, tensor<1024xi32> -> tensor<1024x!diss.ptr<i32>>
        %9 = diss.load %8 : tensor<1024x!diss.ptr<i32>> -> tensor<1024xi32>
        
        %10 = diss.expand %arg1: !diss.ptr<i32> -> tensor<1024x!diss.ptr<i32>>
        %11 = diss.sum_ptr %10, %5 :  tensor<1024x!diss.ptr<i32>>, tensor<1024xi32> -> tensor<1024x!diss.ptr<i32>>
        %12 = diss.load %11 : tensor<1024x!diss.ptr<i32>> -> tensor<1024xi32>
        
        %13 = arith.addi %9, %12 : tensor<1024xi32>
        %14 = diss.expand %arg2: !diss.ptr<i32> -> tensor<1024x!diss.ptr<i32>>
        %15 = diss.sum_ptr %14, %5 :  tensor<1024x!diss.ptr<i32>>, tensor<1024xi32> -> tensor<1024x!diss.ptr<i32>>
        diss.save %15, %13 : tensor<1024x!diss.ptr<i32>>, tensor<1024xi32>
        return %5: tensor<1024xi32>
    } 
}