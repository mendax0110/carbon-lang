// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/basics/fail_bad_run.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/basics/fail_bad_run.carbon

// CHECK:STDERR: fail_bad_run.carbon:[[@LINE+7]]:1: error: invalid signature for `Main.Run` function; expected `fn ()` or `fn () -> i32` [InvalidMainRunSignature]
// CHECK:STDERR: fn Run() -> String {}
// CHECK:STDERR: ^~~~~~~~~~~~~~~~~~~~
// CHECK:STDERR:
// CHECK:STDERR: fail_bad_run.carbon:[[@LINE+3]]:21: error: missing `return` at end of function with declared return type [MissingReturnStatement]
// CHECK:STDERR: fn Run() -> String {}
// CHECK:STDERR:                     ^
fn Run() -> String {}

// CHECK:STDOUT: --- fail_bad_run.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Run.type: type = fn_type @Run [template]
// CHECK:STDOUT:   %Run: %Run.type = struct_value () [template]
// CHECK:STDOUT:   %.1: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %Int.type: type = fn_type @Int [template]
// CHECK:STDOUT:   %Int: %Int.type = struct_value () [template]
// CHECK:STDOUT:   %i32: type = int_type signed, %.1 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Run = %Run.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Run.decl: %Run.type = fn_decl @Run [template = constants.%Run] {
// CHECK:STDOUT:     %return.patt: String = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: String = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %return.param: ref String = out_param runtime_param0
// CHECK:STDOUT:     %return: ref String = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %.loc18_20.1: Core.IntLiteral = int_value 32 [template = constants.%.1]
// CHECK:STDOUT:   %int.make_type_signed: init type = call constants.%Int(%.loc18_20.1) [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_20.2: type = value_of_initializer %int.make_type_signed [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_20.3: type = converted %int.make_type_signed, %.loc18_20.2 [template = constants.%i32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Run() -> %return: String {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT: }
// CHECK:STDOUT:
