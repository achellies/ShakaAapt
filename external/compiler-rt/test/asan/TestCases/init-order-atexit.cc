// FIXME: https://code.google.com/p/address-sanitizer/issues/detail?id=316
// XFAIL: android
//
// Test for the following situation:
// (1) global A is constructed.
// (2) exit() is called during construction of global B.
// (3) destructor of A reads uninitialized global C from another module.
// We do *not* want to report init-order bug in this case.

// RUN: %clangxx_asan -O0 %s %p/Helpers/init-order-atexit-extra.cc -o %t
// RUN: env ASAN_OPTIONS=$ASAN_OPTIONS:strict_init_order=true not %run %t 2>&1 | FileCheck %s

#include <stdio.h>
#include <stdlib.h>

void AccessC();

class A {
 public:
  A() { }
  ~A() { AccessC(); printf("PASSED\n"); }
  // CHECK-NOT: AddressSanitizer
  // CHECK: PASSED
};

A a;

class B {
 public:
  B() { exit(1); }
  ~B() { }
};

B b;
