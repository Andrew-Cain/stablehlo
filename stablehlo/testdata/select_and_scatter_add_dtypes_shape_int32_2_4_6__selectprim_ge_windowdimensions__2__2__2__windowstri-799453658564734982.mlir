// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x3x5xi32>, tensor<2x4x6xi32>)
    %1 = call @expected() : () -> tensor<2x4x6xi32>
    %2 = stablehlo.constant dense<-2147483648> : tensor<i32>
    %3 = stablehlo.pad %0#1, %2, low = [0, 0, 0], high = [0, 0, 0], interior = [0, 0, 0] : (tensor<2x4x6xi32>, tensor<i32>) -> tensor<2x4x6xi32>
    %4 = stablehlo.constant dense<0> : tensor<i32>
    %5 = "stablehlo.select_and_scatter"(%3, %0#0, %4) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %8 = stablehlo.compare  GE, %arg0, %arg1,  SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
      stablehlo.return %8 : tensor<i1>
    }, {
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %8 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %8 : tensor<i32>
    }) {window_dimensions = dense<2> : tensor<3xi64>} : (tensor<2x4x6xi32>, tensor<1x3x5xi32>, tensor<i32>) -> tensor<2x4x6xi32>
    %6 = "stablehlo.slice"(%5) {limit_indices = dense<[2, 4, 6]> : tensor<3xi64>, start_indices = dense<0> : tensor<3xi64>, strides = dense<1> : tensor<3xi64>} : (tensor<2x4x6xi32>) -> tensor<2x4x6xi32>
    %7 = stablehlo.custom_call @check.eq(%6, %1) : (tensor<2x4x6xi32>, tensor<2x4x6xi32>) -> tensor<i1>
    return %7 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x3x5xi32>, tensor<2x4x6xi32>) {
    %0 = stablehlo.constant dense<[[[0, -3, 1, -1, 2], [0, -4, -1, -1, 0], [-2, -1, 0, 1, -4]]]> : tensor<1x3x5xi32>
    %1 = stablehlo.constant dense<[[[1, 6, 0, 0, -3, -3], [0, 0, 3, 7, -2, 1], [0, -4, 0, 0, 3, 3], [1, -1, 1, 0, 1, 0]], [[6, -5, 3, 2, 0, 1], [-4, -1, -3, 0, -6, 3], [4, 2, 2, 2, -4, -3], [-1, 2, 0, -1, 0, 4]]]> : tensor<2x4x6xi32>
    return %0, %1 : tensor<1x3x5xi32>, tensor<2x4x6xi32>
  }
  func.func private @expected() -> tensor<2x4x6xi32> {
    %0 = stablehlo.constant dense<[[[0, -3, 0, 0, 0, 0], [0, 0, -4, -2, 0, 0], [0, 0, 0, 0, 1, 0], [0, 0, 0, 0, 0, 0]], [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 2], [-2, -1, 0, 0, 0, 0], [0, 0, 0, 0, 0, -4]]]> : tensor<2x4x6xi32>
    return %0 : tensor<2x4x6xi32>
  }
}

