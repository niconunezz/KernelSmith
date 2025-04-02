module {
    // CHECK-LABEL: test_type_syntax
    func.func @test_syntax(%arg0: !diss.ptr<f32>) -> !diss.ptr<f32> {
        return %arg0: !diss.ptr<f32>
    } 
}