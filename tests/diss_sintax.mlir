module {
    // CHECK-LABEL: test_type_syntax
    func.func @test_syntax(%arg0: !diss.ptr<f32>) -> !diss.ptr<f32> {
        %0 = diss.get_id x : i32
        
        %1 = arith.constant 16 : i32
        
        %2 = diss.range {begin = 0 : i32, end = 1024 : i32} : tensor<1024xi32>
        return %arg0: !diss.ptr<f32>
    } 
}