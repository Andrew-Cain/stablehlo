// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3xf16>
    %1 = call @expected() : () -> tensor<1xf16>
    %2 = "stablehlo.slice"(%0) {limit_indices = dense<2> : tensor<1xi64>, start_indices = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>} : (tensor<3xf16>) -> tensor<1xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<1xf16>, tensor<1xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3xf16> {
    %0 = stablehlo.constant dense<[2.017580e+00, -6.440430e-01, -3.429690e+00]> : tensor<3xf16>
    return %0 : tensor<3xf16>
  }
  func.func private @expected() -> tensor<1xf16> {
    %0 = stablehlo.constant dense<-6.440430e-01> : tensor<1xf16>
    return %0 : tensor<1xf16>
  }
}
