//===- Utils.h - llvm-reduce utility functions ------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains some utility functions supporting llvm-reduce.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_REDUCE_DELTAS_UTILS_H
#define LLVM_TOOLS_LLVM_REDUCE_DELTAS_UTILS_H

#include "llvm/Support/CommandLine.h"

namespace llvm {
class BasicBlock;
class Function;
class Type;
class Value;

extern cl::opt<bool> Verbose;

Value *getDefaultValue(Type *T);
bool hasAliasUse(Function &F);
bool hasAliasOrBlockAddressUse(Function &F);

// Constant fold terminators in \p and minimally prune unreachable code from the
// function.
void simpleSimplifyCFG(Function &F, ArrayRef<BasicBlock *> BBs,
                       bool FoldBlockIntoPredecessor = true);

} // namespace llvm

#endif
