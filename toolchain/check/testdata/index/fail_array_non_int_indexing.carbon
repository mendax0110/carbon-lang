// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/index/fail_array_non_int_indexing.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/index/fail_array_non_int_indexing.carbon

var a: [i32; 1] = (12,);
// CHECK:STDERR: fail_array_non_int_indexing.carbon:[[@LINE+6]]:16: error: cannot implicitly convert from `f64` to `i32` [ImplicitAsConversionFailure]
// CHECK:STDERR: var b: i32 = a[2.6];
// CHECK:STDERR:                ^~~
// CHECK:STDERR: fail_array_non_int_indexing.carbon:[[@LINE+3]]:16: note: type `f64` does not implement interface `ImplicitAs(i32)` [MissingImplInMemberAccessNote]
// CHECK:STDERR: var b: i32 = a[2.6];
// CHECK:STDERR:                ^~~
var b: i32 = a[2.6];

// CHECK:STDOUT: --- fail_array_non_int_indexing.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %Int.type: type = fn_type @Int [template]
// CHECK:STDOUT:   %Int: %Int.type = struct_value () [template]
// CHECK:STDOUT:   %i32: type = int_type signed, %.1 [template]
// CHECK:STDOUT:   %.2: Core.IntLiteral = int_value 1 [template]
// CHECK:STDOUT:   %.3: type = array_type %.2, %i32 [template]
// CHECK:STDOUT:   %.5: Core.IntLiteral = int_value 12 [template]
// CHECK:STDOUT:   %tuple.type: type = tuple_type (Core.IntLiteral) [template]
// CHECK:STDOUT:   %.6: Core.IntLiteral = int_value 0 [template]
// CHECK:STDOUT:   %Convert.type.2: type = fn_type @Convert.1, @ImplicitAs(%i32) [template]
// CHECK:STDOUT:   %Convert.type.14: type = fn_type @Convert.2, @impl.1(%.1) [template]
// CHECK:STDOUT:   %Convert.14: %Convert.type.14 = struct_value () [template]
// CHECK:STDOUT:   %.30: <witness> = interface_witness (%Convert.14) [template]
// CHECK:STDOUT:   %.31: <bound method> = bound_method %.5, %Convert.14 [template]
// CHECK:STDOUT:   %.32: <specific function> = specific_function %.31, @Convert.2(%.1) [template]
// CHECK:STDOUT:   %.33: %i32 = int_value 12 [template]
// CHECK:STDOUT:   %array: %.3 = tuple_value (%.33) [template]
// CHECK:STDOUT:   %.34: f64 = float_literal 2.6000000000000001 [template]
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
// CHECK:STDOUT:   %.loc11_9.1: Core.IntLiteral = int_value 32 [template = constants.%.1]
// CHECK:STDOUT:   %int.make_type_signed.loc11: init type = call constants.%Int(%.loc11_9.1) [template = constants.%i32]
// CHECK:STDOUT:   %.loc11_14: Core.IntLiteral = int_value 1 [template = constants.%.2]
// CHECK:STDOUT:   %.loc11_9.2: type = value_of_initializer %int.make_type_signed.loc11 [template = constants.%i32]
// CHECK:STDOUT:   %.loc11_9.3: type = converted %int.make_type_signed.loc11, %.loc11_9.2 [template = constants.%i32]
// CHECK:STDOUT:   %.loc11_15: type = array_type %.loc11_14, %i32 [template = constants.%.3]
// CHECK:STDOUT:   %a.var: ref %.3 = var a
// CHECK:STDOUT:   %a: ref %.3 = bind_name a, %a.var
// CHECK:STDOUT:   %.loc18_8.1: Core.IntLiteral = int_value 32 [template = constants.%.1]
// CHECK:STDOUT:   %int.make_type_signed.loc18: init type = call constants.%Int(%.loc18_8.1) [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_8.2: type = value_of_initializer %int.make_type_signed.loc18 [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_8.3: type = converted %int.make_type_signed.loc18, %.loc18_8.2 [template = constants.%i32]
// CHECK:STDOUT:   %b.var: ref %i32 = var b
// CHECK:STDOUT:   %b: ref %i32 = bind_name b, %b.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc11_20: Core.IntLiteral = int_value 12 [template = constants.%.5]
// CHECK:STDOUT:   %.loc11_23.1: %tuple.type = tuple_literal (%.loc11_20)
// CHECK:STDOUT:   %.loc11_23.2: %Convert.type.2 = interface_witness_access constants.%.30, element0 [template = constants.%Convert.14]
// CHECK:STDOUT:   %.loc11_23.3: <bound method> = bound_method %.loc11_20, %.loc11_23.2 [template = constants.%.31]
// CHECK:STDOUT:   %.loc11_23.4: <specific function> = specific_function %.loc11_23.3, @Convert.2(constants.%.1) [template = constants.%.32]
// CHECK:STDOUT:   %int.convert_checked: init %i32 = call %.loc11_23.4(%.loc11_20) [template = constants.%.33]
// CHECK:STDOUT:   %.loc11_23.5: init %i32 = converted %.loc11_20, %int.convert_checked [template = constants.%.33]
// CHECK:STDOUT:   %.loc11_23.6: Core.IntLiteral = int_value 0 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_23.7: ref %i32 = array_index file.%a.var, %.loc11_23.6
// CHECK:STDOUT:   %.loc11_23.8: init %i32 = initialize_from %.loc11_23.5 to %.loc11_23.7 [template = constants.%.33]
// CHECK:STDOUT:   %.loc11_23.9: init %.3 = array_init (%.loc11_23.8) to file.%a.var [template = constants.%array]
// CHECK:STDOUT:   %.loc11_24: init %.3 = converted %.loc11_23.1, %.loc11_23.9 [template = constants.%array]
// CHECK:STDOUT:   assign file.%a.var, %.loc11_24
// CHECK:STDOUT:   %a.ref: ref %.3 = name_ref a, file.%a
// CHECK:STDOUT:   %.loc18_16.1: f64 = float_literal 2.6000000000000001 [template = constants.%.34]
// CHECK:STDOUT:   %.loc18_19.1: Core.IntLiteral = int_value 32 [template = constants.%.1]
// CHECK:STDOUT:   %int.make_type_signed: init type = call constants.%Int(%.loc18_19.1) [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_19.2: type = value_of_initializer %int.make_type_signed [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_19.3: type = converted %int.make_type_signed, %.loc18_19.2 [template = constants.%i32]
// CHECK:STDOUT:   %.loc18_16.2: %i32 = converted %.loc18_16.1, <error> [template = <error>]
// CHECK:STDOUT:   %.loc18_19.4: ref %i32 = array_index %a.ref, <error> [template = <error>]
// CHECK:STDOUT:   %.loc18_19.5: %i32 = bind_value %.loc18_19.4
// CHECK:STDOUT:   assign file.%b.var, %.loc18_19.5
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
