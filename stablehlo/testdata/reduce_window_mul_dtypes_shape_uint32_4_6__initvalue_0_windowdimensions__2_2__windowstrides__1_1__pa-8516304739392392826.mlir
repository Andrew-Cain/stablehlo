// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<4x6xui32>
    %1 = call @expected() : () -> tensor<3x5xui32>
    %2 = stablehlo.constant dense<0> : tensor<ui32>
    %3 = "stablehlo.reduce_window"(%0, %2) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {window_dimensions = dense<2> : tensor<2xi64>} : (tensor<4x6xui32>, tensor<ui32>) -> tensor<3x5xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x5xui32>, tensor<3x5xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<4x6xui32> {
    %0 = stablehlo.constant dense<[[3, 0, 0, 0, 2, 0], [3, 1, 1, 3, 0, 2], [3, 4, 1, 2, 3, 2], [1, 0, 1, 6, 4, 2]]> : tensor<4x6xui32>
    return %0 : tensor<4x6xui32>
  }
  func.func private @expected() -> tensor<3x5xui32> {
    %0 = stablehlo.constant dense<0> : tensor<3x5xui32>
    return %0 : tensor<3x5xui32>
  }
}

