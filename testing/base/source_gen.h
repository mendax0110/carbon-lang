// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef CARBON_TESTING_BASE_SOURCE_GEN_H_
#define CARBON_TESTING_BASE_SOURCE_GEN_H_

#include <string>

#include "absl/random/random.h"
#include "common/map.h"
#include "common/set.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Allocator.h"

namespace Carbon::Testing {

// Provides source code generation facilities.
//
// This class works to generate valid but random & meaningless source code in
// interesting patterns for benchmarking. It is very incomplete. A high level
// set of long-term goals:
//
// - Generate interesting patterns and structures of code that have emerged as
//   toolchain performance bottlenecks in practice in C++ codebases.
// - Generate code that includes most Carbon language features (and whatever
//   reasonable C++ analogs could be used for comparative purposes):
//   - Functions
//   - Classes with class functions, methods, and fields
//   - Interfaces
//   - Checked generics and templates
//   - Nested and unnested impls
//   - Nested classes
//   - Inline and out-of-line function and method definitions
//   - Imports and exports
//   - API files and impl files.
// - Be random but deterministic. The goal is benchmarking and so while this
//   code should strive for not producing trivially predictable patterns, it
//   should also strive to be consistent and suitable for benchmarking. Wherever
//   possible, it should permute the order and content without randomizing the
//   total count, size, or complexity.
//
// Note that the default and primary generation target is interesting Carbon
// source code. We have a best-effort to alternatively generate comparable C++
// constructs to the Carbon ones for comparative benchmarking, but there is no
// goal to cover all the interesting C++ patterns we might want to benchmark,
// and we don't aim for perfectly synthesizing C++ analogs. We can always drop
// fidelity for the C++ code path if needed for simplicity.
//
// TODO: There are numerous places where we hard code a fixed quantity. Instead,
// we should build a rich but general system to easily encode a discrete
// distribution that is sampled. We have a specialized version of this for
// identifiers that should be generalized.
class SourceGen {
 public:
  enum class Language {
    Carbon,
    Cpp,
  };

  struct FunctionDeclParams {
    // TODD: Arbitrary default, should switch to a distribution from data.
    int max_params = 4;
  };

  struct MethodDeclParams {
    // TODD: Arbitrary default, should switch to a distribution from data.
    int max_params = 4;
  };

  // Parameters used to generate a class in a generated file.
  //
  // Currently, this uses a fixed number of each kind of declaration, with
  // arbitrary defaults chosen. The defaults currently skew towards large
  // classes with lots of nested declarations.
  // TODO: Switch these to distributions based on data.
  //
  // TODO: Add support for generating definitions and parameters to control
  // them.
  struct ClassParams {
    int public_function_decls = 4;
    FunctionDeclParams public_function_decl_params = {.max_params = 8};

    int public_method_decls = 10;
    MethodDeclParams public_method_decl_params;

    int private_function_decls = 2;
    FunctionDeclParams private_function_decl_params = {.max_params = 6};

    int private_method_decls = 8;
    MethodDeclParams private_method_decl_params = {.max_params = 6};

    int private_field_decls = 6;
  };

  // Parameters used to generate a file with dense declarations.
  struct DenseDeclParams {
    // TODO: Add more parameters to control generating top-level constructs
    // other than class definitions.

    // Parameters used when generating class definitions.
    ClassParams class_params = {};
  };

  // Access a global instance of this type to generate Carbon code for
  // benchmarks, tests, or other places where sharing a common instance is
  // useful. Note that there is nothing thread safe about this instance or type.
  static auto Global() -> SourceGen&;

  // Construct a source generator for the provided language, by default Carbon.
  explicit SourceGen(Language language = Language::Carbon);

  // Generate an API file with dense classes containing function forward
  // declarations.
  //
  // Accepts a number of `target_lines` for the resulting source code. This is a
  // rough approximation used to scale all the other constructs up and down
  // accordingly. For C++ source generation, we work to generate the same number
  // of constructs as Carbon would for the given line count over keeping the
  // actual line count close to the target.
  //
  // TODO: Currently, the formatting and line breaks of generating code are
  // extremely rough still, and those are a large factor in adherence to
  // `target_lines`. Long term, the goal is to get as close as we can to any
  // automatically formatted code while still keeping the stability of
  // benchmarking.
  auto GenAPIFileDenseDecls(int target_lines, DenseDeclParams params)
      -> std::string;

  // Get some number of randomly shuffled identifiers.
  //
  // The identifiers start with a character [A-Za-z], other characters may also
  // include [0-9_]. Both Carbon and C++ keywords are excluded along with any
  // other non-identifier syntaxes that overlap to ensure all of these can be
  // used as identifiers.
  //
  // The order will be different for each call to this function, but the
  // specific identifiers may remain the same in order to reduce the cost of
  // repeated calls. However, the sum of the identifier sizes returned is
  // guaranteed to be the same for every call with the same number of
  // identifiers so that benchmarking all of these identifiers has predictable
  // and stable cost.
  //
  // Optionally, callers can request a minimum and maximum length. By default,
  // the length distribution used across the identifiers will mirror the
  // observed distribution of identifiers in C++ source code and our expectation
  // of them in Carbon source code. The maximum length in this default
  // distribution cannot be more than 64.
  //
  // Callers can request a uniform distribution across [min_length, max_length],
  // and when it is requested there is no limit on `max_length`.
  auto GetShuffledIdentifiers(int number, int min_length = 1,
                              int max_length = 64, bool uniform = false)
      -> llvm::SmallVector<llvm::StringRef>;

  // Same as `GetShuffledIdentifiers`, but ensures there are no collisions.
  auto GetShuffledUniqueIdentifiers(int number, int min_length = 4,
                                    int max_length = 64, bool uniform = false)
      -> llvm::SmallVector<llvm::StringRef>;

  // Returns a collection of un-shuffled identifiers, otherwise the same as
  // `GetShuffledIdentifiers`.
  //
  // Usually, benchmarks should use the shuffled version. However, this is
  // useful when there is already a post-processing step to shuffle things as it
  // is *dramatically* more efficient, especially in debug builds.
  auto GetIdentifiers(int number, int min_length = 1, int max_length = 64,
                      bool uniform = false)
      -> llvm::SmallVector<llvm::StringRef>;

  // Returns a collection of un-shuffled unique identifiers, otherwise the same
  // as `GetShuffledUniqueIdentifiers`.
  //
  // Usually, benchmarks should use the shuffled version. However, this is
  // useful when there is already a post-processing step to shuffle things.
  auto GetUniqueIdentifiers(int number, int min_length = 1, int max_length = 64,
                            bool uniform = false)
      -> llvm::SmallVector<llvm::StringRef>;

  // Returns a shared collection of random identifiers of a specific length.
  //
  // For a single, exact length, we have an even cheaper routine to return
  // access to a shared collection of identifiers. The order of these is a
  // single fixed random order for a given execution. The returned array
  // reference is only valid until the next call any method on this generator.
  auto GetSingleLengthIdentifiers(int length, int number)
      -> llvm::ArrayRef<llvm::StringRef>;

 private:
  // The shuffled state used to generate some number of classes.
  //
  // This state encodes all the shuffled entropy used for generating a number of
  // class definitions. While generating definitions, the state here will be
  // consumed until empty.
  struct ClassGenState {
    llvm::SmallVector<int> public_function_param_counts;
    llvm::SmallVector<int> public_method_param_counts;
    llvm::SmallVector<int> private_function_param_counts;
    llvm::SmallVector<int> private_method_param_counts;

    llvm::SmallVector<llvm::StringRef> class_names;
    llvm::SmallVector<llvm::StringRef> member_names;
    llvm::SmallVector<llvm::StringRef> param_names;
  };

  class UniqueIdentifierPopper;
  friend UniqueIdentifierPopper;

  using AppendFn = auto(int length, int number,
                        llvm::SmallVectorImpl<llvm::StringRef>& dest) -> void;

  auto IsCpp() -> bool { return language_ == Language::Cpp; }

  auto GenerateRandomIdentifier(llvm::MutableArrayRef<char> dest_storage)
      -> void;
  auto AppendUniqueIdentifiers(int length, int number,
                               llvm::SmallVectorImpl<llvm::StringRef>& dest)
      -> void;
  auto GetIdentifiersImpl(int number, int min_length, int max_length,
                          bool uniform, llvm::function_ref<AppendFn> append)
      -> llvm::SmallVector<llvm::StringRef>;

  auto GetShuffledInts(int number, int min, int max) -> llvm::SmallVector<int>;

  auto GetClassGenState(int number, ClassParams params) -> ClassGenState;

  auto GenerateFunctionDecl(llvm::StringRef name, bool is_private,
                            bool is_method, int param_count,
                            llvm::StringRef indent,
                            llvm::SmallVectorImpl<llvm::StringRef>& param_names,
                            llvm::raw_ostream& os) -> void;
  auto GenerateClassDef(const ClassParams& params, ClassGenState& state,
                        llvm::raw_ostream& os) -> void;

  absl::BitGen rng_;
  llvm::BumpPtrAllocator storage_;

  Map<int, llvm::SmallVector<llvm::StringRef>> identifiers_by_length_;
  Map<int, std::pair<int, Set<llvm::StringRef>>> unique_identifiers_by_length_;

  Language language_;
};

}  // namespace Carbon::Testing

#endif  // CARBON_TESTING_BASE_SOURCE_GEN_H_