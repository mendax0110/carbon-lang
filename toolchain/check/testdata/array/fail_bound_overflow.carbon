// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/array/fail_bound_overflow.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/array/fail_bound_overflow.carbon

// CHECK:STDERR: fail_bound_overflow.carbon:[[@LINE+4]]:14: error: array bound of 39999999999999999993 is too large [ArrayBoundTooLarge]
// CHECK:STDERR: var a: [i32; 39999999999999999993];
// CHECK:STDERR:              ^~~~~~~~~~~~~~~~~~~~
// CHECK:STDERR:
var a: [i32; 39999999999999999993];

// CHECK:STDERR: fail_bound_overflow.carbon:[[@LINE+6]]:9: error: cannot implicitly convert from `Core.IntLiteral` to `type` [ImplicitAsConversionFailure]
// CHECK:STDERR: var b: [1; 39999999999999999993];
// CHECK:STDERR:         ^
// CHECK:STDERR: fail_bound_overflow.carbon:[[@LINE+3]]:9: note: type `Core.IntLiteral` does not implement interface `ImplicitAs(type)` [MissingImplInMemberAccessNote]
// CHECK:STDERR: var b: [1; 39999999999999999993];
// CHECK:STDERR:         ^
var b: [1; 39999999999999999993];

// CHECK:STDOUT: --- fail_bound_overflow.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %Int.type: type = fn_type @Int [template]
// CHECK:STDOUT:   %Int: %Int.type = struct_value () [template]
// CHECK:STDOUT:   %i32: type = int_type signed, %.1 [template]
// CHECK:STDOUT:   %.2: Core.IntLiteral = int_value 39999999999999999993 [template]
// CHECK:STDOUT:   %.3: Core.IntLiteral = int_value 1 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     .ImplicitAs = %import_ref.2
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %.loc15_9.1: Core.IntLiteral = int_value 32 [template = constants.%.1]
// CHECK:STDOUT:   %int.make_type_signed: init type = call constants.%Int(%.loc15_9.1) [template = constants.%i32]
// CHECK:STDOUT:   %.loc15_14: Core.IntLiteral = int_value 39999999999999999993 [template = constants.%.2]
// CHECK:STDOUT:   %.loc15_9.2: type = value_of_initializer %int.make_type_signed [template = constants.%i32]
// CHECK:STDOUT:   %.loc15_9.3: type = converted %int.make_type_signed, %.loc15_9.2 [template = constants.%i32]
// CHECK:STDOUT:   %.loc15_34: type = array_type %.loc15_14, %i32 [template = <error>]
// CHECK:STDOUT:   %a.var: ref <error> = var a
// CHECK:STDOUT:   %a: ref <error> = bind_name a, %a.var
// CHECK:STDOUT:   %.loc23_9.1: Core.IntLiteral = int_value 1 [template = constants.%.3]
// CHECK:STDOUT:   %.loc23_12: Core.IntLiteral = int_value 39999999999999999993 [template = constants.%.2]
// CHECK:STDOUT:   %.loc23_9.2: type = converted %.loc23_9.1, <error> [template = <error>]
// CHECK:STDOUT:   %.loc23_32: type = array_type %.loc23_12, <error> [template = <error>]
// CHECK:STDOUT:   %b.var: ref <error> = var b
// CHECK:STDOUT:   %b: ref <error> = bind_name b, %b.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
