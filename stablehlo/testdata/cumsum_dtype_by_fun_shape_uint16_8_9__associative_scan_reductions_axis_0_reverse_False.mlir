// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<8x9xui16>
    %1 = call @expected() : () -> tensor<8x9xui16>
    %2 = call @cumsum(%0) : (tensor<8x9xui16>) -> tensor<8x9xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<8x9xui16>, tensor<8x9xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<8x9xui16> {
    %0 = stablehlo.constant dense<[[3, 3, 1, 2, 1, 0, 0, 4, 0], [1, 3, 0, 2, 3, 1, 2, 3, 2], [0, 3, 1, 1, 1, 1, 3, 2, 3], [2, 4, 0, 2, 0, 3, 5, 0, 0], [0, 0, 7, 3, 3, 3, 1, 4, 1], [2, 1, 0, 4, 6, 1, 0, 0, 2], [1, 1, 3, 3, 3, 4, 2, 3, 5], [1, 0, 1, 3, 0, 0, 1, 0, 0]]> : tensor<8x9xui16>
    return %0 : tensor<8x9xui16>
  }
  func.func private @expected() -> tensor<8x9xui16> {
    %0 = stablehlo.constant dense<[[3, 3, 1, 2, 1, 0, 0, 4, 0], [4, 6, 1, 4, 4, 1, 2, 7, 2], [4, 9, 2, 5, 5, 2, 5, 9, 5], [6, 13, 2, 7, 5, 5, 10, 9, 5], [6, 13, 9, 10, 8, 8, 11, 13, 6], [8, 14, 9, 14, 14, 9, 11, 13, 8], [9, 15, 12, 17, 17, 13, 13, 16, 13], [10, 15, 13, 20, 17, 13, 14, 16, 13]]> : tensor<8x9xui16>
    return %0 : tensor<8x9xui16>
  }
  func.func private @cumsum(%arg0: tensor<8x9xui16>) -> tensor<8x9xui16> {
    %0 = "stablehlo.slice"(%arg0) {limit_indices = dense<[7, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xui16>) -> tensor<4x9xui16>
    %1 = "stablehlo.slice"(%arg0) {limit_indices = dense<[8, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xui16>) -> tensor<4x9xui16>
    %2 = stablehlo.add %0, %1 : tensor<4x9xui16>
    %3 = "stablehlo.slice"(%2) {limit_indices = dense<[3, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xui16>) -> tensor<2x9xui16>
    %4 = "stablehlo.slice"(%2) {limit_indices = dense<[4, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xui16>) -> tensor<2x9xui16>
    %5 = stablehlo.add %3, %4 : tensor<2x9xui16>
    %6 = "stablehlo.slice"(%5) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xui16>) -> tensor<1x9xui16>
    %7 = "stablehlo.slice"(%5) {limit_indices = dense<[2, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xui16>) -> tensor<1x9xui16>
    %8 = stablehlo.add %6, %7 : tensor<1x9xui16>
    %9 = "stablehlo.slice"(%8) {limit_indices = dense<[0, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<1x9xui16>) -> tensor<0x9xui16>
    %10 = "stablehlo.slice"(%5) {limit_indices = dense<[2, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xui16>) -> tensor<0x9xui16>
    %11 = stablehlo.add %9, %10 : tensor<0x9xui16>
    %12 = "stablehlo.slice"(%5) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<2x9xui16>) -> tensor<1x9xui16>
    %13 = stablehlo.concatenate %12, %11, dim = 0 : (tensor<1x9xui16>, tensor<0x9xui16>) -> tensor<1x9xui16>
    %14 = stablehlo.constant dense<0> : tensor<ui16>
    %15 = stablehlo.pad %13, %14, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<1x9xui16>, tensor<ui16>) -> tensor<2x9xui16>
    %16 = stablehlo.constant dense<0> : tensor<ui16>
    %17 = stablehlo.pad %8, %16, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<1x9xui16>, tensor<ui16>) -> tensor<2x9xui16>
    %18 = stablehlo.add %15, %17 : tensor<2x9xui16>
    %19 = "stablehlo.slice"(%18) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<2x9xui16>) -> tensor<1x9xui16>
    %20 = "stablehlo.slice"(%2) {limit_indices = dense<[4, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xui16>) -> tensor<1x9xui16>
    %21 = stablehlo.add %19, %20 : tensor<1x9xui16>
    %22 = "stablehlo.slice"(%2) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<4x9xui16>) -> tensor<1x9xui16>
    %23 = stablehlo.concatenate %22, %21, dim = 0 : (tensor<1x9xui16>, tensor<1x9xui16>) -> tensor<2x9xui16>
    %24 = stablehlo.constant dense<0> : tensor<ui16>
    %25 = stablehlo.pad %23, %24, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<2x9xui16>, tensor<ui16>) -> tensor<4x9xui16>
    %26 = stablehlo.constant dense<0> : tensor<ui16>
    %27 = stablehlo.pad %18, %26, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<2x9xui16>, tensor<ui16>) -> tensor<4x9xui16>
    %28 = stablehlo.add %25, %27 : tensor<4x9xui16>
    %29 = "stablehlo.slice"(%28) {limit_indices = dense<[3, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<4x9xui16>) -> tensor<3x9xui16>
    %30 = "stablehlo.slice"(%arg0) {limit_indices = dense<[8, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xui16>) -> tensor<3x9xui16>
    %31 = stablehlo.add %29, %30 : tensor<3x9xui16>
    %32 = "stablehlo.slice"(%arg0) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<8x9xui16>) -> tensor<1x9xui16>
    %33 = stablehlo.concatenate %32, %31, dim = 0 : (tensor<1x9xui16>, tensor<3x9xui16>) -> tensor<4x9xui16>
    %34 = stablehlo.constant dense<0> : tensor<ui16>
    %35 = stablehlo.pad %33, %34, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<4x9xui16>, tensor<ui16>) -> tensor<8x9xui16>
    %36 = stablehlo.constant dense<0> : tensor<ui16>
    %37 = stablehlo.pad %28, %36, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<4x9xui16>, tensor<ui16>) -> tensor<8x9xui16>
    %38 = stablehlo.add %35, %37 : tensor<8x9xui16>
    return %38 : tensor<8x9xui16>
  }
}
