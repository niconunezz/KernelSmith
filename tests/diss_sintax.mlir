module {
    // CHECK-LABEL: test_type_syntax
    func.func @test_syntax(%arg0: !diss.ptr<i32>) -> tensor<1024xi32> {
        %0 = diss.get_id x : i32
        
        %1 = arith.constant 16 : i32
        
        
        %2 = diss.range {begin = 0 : i32, end = 1024 : i32} : tensor<1024xi32>
        %3 = diss.expand %arg0 : !diss.ptr<i32> -> tensor<1024xi32>

        %4 = arith.addi %1, %1 : i32
        return %3: tensor<1024xi32>
    } 
}