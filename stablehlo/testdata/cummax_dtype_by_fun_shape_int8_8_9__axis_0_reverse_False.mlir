// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<8x9xi8>
    %1 = call @expected() : () -> tensor<8x9xi8>
    %2 = call @cummax(%0) : (tensor<8x9xi8>) -> tensor<8x9xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<8x9xi8>, tensor<8x9xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<8x9xi8> {
    %0 = stablehlo.constant dense<[[-1, 0, -3, -4, 0, 1, 6, 4, 0], [2, 0, -3, 2, -1, -1, -2, -2, 3], [-3, 0, 0, 4, 4, -4, -1, 5, -2], [3, -3, -1, -2, -1, -1, 1, 2, 1], [6, 0, 0, 0, 6, 0, 1, 0, 0], [-2, 1, -2, 3, 1, 0, 1, 1, 2], [-1, -1, -2, 0, 4, -3, 3, 0, 0], [-4, 2, 1, 0, 4, 1, -5, 0, -3]]> : tensor<8x9xi8>
    return %0 : tensor<8x9xi8>
  }
  func.func private @expected() -> tensor<8x9xi8> {
    %0 = stablehlo.constant dense<[[-1, 0, -3, -4, 0, 1, 6, 4, 0], [2, 0, -3, 2, 0, 1, 6, 4, 3], [2, 0, 0, 4, 4, 1, 6, 5, 3], [3, 0, 0, 4, 4, 1, 6, 5, 3], [6, 0, 0, 4, 6, 1, 6, 5, 3], [6, 1, 0, 4, 6, 1, 6, 5, 3], [6, 1, 0, 4, 6, 1, 6, 5, 3], [6, 2, 1, 4, 6, 1, 6, 5, 3]]> : tensor<8x9xi8>
    return %0 : tensor<8x9xi8>
  }
  func.func private @cummax(%arg0: tensor<8x9xi8>) -> tensor<8x9xi8> {
    %0 = "stablehlo.slice"(%arg0) {limit_indices = dense<[7, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xi8>) -> tensor<4x9xi8>
    %1 = "stablehlo.slice"(%arg0) {limit_indices = dense<[8, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xi8>) -> tensor<4x9xi8>
    %2 = stablehlo.maximum %0, %1 : tensor<4x9xi8>
    %3 = "stablehlo.slice"(%2) {limit_indices = dense<[3, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xi8>) -> tensor<2x9xi8>
    %4 = "stablehlo.slice"(%2) {limit_indices = dense<[4, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xi8>) -> tensor<2x9xi8>
    %5 = stablehlo.maximum %3, %4 : tensor<2x9xi8>
    %6 = "stablehlo.slice"(%5) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xi8>) -> tensor<1x9xi8>
    %7 = "stablehlo.slice"(%5) {limit_indices = dense<[2, 9]> : tensor<2xi64>, start_indices = dense<[1, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xi8>) -> tensor<1x9xi8>
    %8 = stablehlo.maximum %6, %7 : tensor<1x9xi8>
    %9 = "stablehlo.slice"(%8) {limit_indices = dense<[0, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<1x9xi8>) -> tensor<0x9xi8>
    %10 = "stablehlo.slice"(%5) {limit_indices = dense<[2, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<2x9xi8>) -> tensor<0x9xi8>
    %11 = stablehlo.maximum %9, %10 : tensor<0x9xi8>
    %12 = "stablehlo.slice"(%5) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<2x9xi8>) -> tensor<1x9xi8>
    %13 = stablehlo.concatenate %12, %11, dim = 0 : (tensor<1x9xi8>, tensor<0x9xi8>) -> tensor<1x9xi8>
    %14 = stablehlo.constant dense<0> : tensor<i8>
    %15 = stablehlo.pad %13, %14, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<1x9xi8>, tensor<i8>) -> tensor<2x9xi8>
    %16 = stablehlo.constant dense<0> : tensor<i8>
    %17 = stablehlo.pad %8, %16, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<1x9xi8>, tensor<i8>) -> tensor<2x9xi8>
    %18 = stablehlo.add %15, %17 : tensor<2x9xi8>
    %19 = "stablehlo.slice"(%18) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<2x9xi8>) -> tensor<1x9xi8>
    %20 = "stablehlo.slice"(%2) {limit_indices = dense<[4, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<4x9xi8>) -> tensor<1x9xi8>
    %21 = stablehlo.maximum %19, %20 : tensor<1x9xi8>
    %22 = "stablehlo.slice"(%2) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<4x9xi8>) -> tensor<1x9xi8>
    %23 = stablehlo.concatenate %22, %21, dim = 0 : (tensor<1x9xi8>, tensor<1x9xi8>) -> tensor<2x9xi8>
    %24 = stablehlo.constant dense<0> : tensor<i8>
    %25 = stablehlo.pad %23, %24, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<2x9xi8>, tensor<i8>) -> tensor<4x9xi8>
    %26 = stablehlo.constant dense<0> : tensor<i8>
    %27 = stablehlo.pad %18, %26, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<2x9xi8>, tensor<i8>) -> tensor<4x9xi8>
    %28 = stablehlo.add %25, %27 : tensor<4x9xi8>
    %29 = "stablehlo.slice"(%28) {limit_indices = dense<[3, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<4x9xi8>) -> tensor<3x9xi8>
    %30 = "stablehlo.slice"(%arg0) {limit_indices = dense<[8, 9]> : tensor<2xi64>, start_indices = dense<[2, 0]> : tensor<2xi64>, strides = dense<[2, 1]> : tensor<2xi64>} : (tensor<8x9xi8>) -> tensor<3x9xi8>
    %31 = stablehlo.maximum %29, %30 : tensor<3x9xi8>
    %32 = "stablehlo.slice"(%arg0) {limit_indices = dense<[1, 9]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<8x9xi8>) -> tensor<1x9xi8>
    %33 = stablehlo.concatenate %32, %31, dim = 0 : (tensor<1x9xi8>, tensor<3x9xi8>) -> tensor<4x9xi8>
    %34 = stablehlo.constant dense<0> : tensor<i8>
    %35 = stablehlo.pad %33, %34, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<4x9xi8>, tensor<i8>) -> tensor<8x9xi8>
    %36 = stablehlo.constant dense<0> : tensor<i8>
    %37 = stablehlo.pad %28, %36, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<4x9xi8>, tensor<i8>) -> tensor<8x9xi8>
    %38 = stablehlo.add %35, %37 : tensor<8x9xi8>
    return %38 : tensor<8x9xi8>
  }
}
