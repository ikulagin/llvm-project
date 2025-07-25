; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=memcpyopt -S %s -verify-memoryssa | FileCheck %s

; memset -> memcpy forwarding, if memcpy is larger than memset, but trailing
; bytes are known to be undef.


%T = type { i64, i32, i32 }

define void @test_alloca(ptr %result) {
; CHECK-LABEL: @test_alloca(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

define void @test_alloca_with_lifetimes(ptr %result) {
; CHECK-LABEL: @test_alloca_with_lifetimes(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr [[A]])
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr [[A]])
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.lifetime.start.p0(i64 16, ptr %a)
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  call void @llvm.lifetime.end.p0(i64 16, ptr %a)
  ret void
}

; memcpy size is larger than lifetime, don't optimize.
define void @test_copy_larger_than_lifetime_size(ptr %result) {
; CHECK-LABEL: @test_copy_larger_than_lifetime_size(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 12, ptr [[A]])
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 12, ptr [[A]])
; CHECK-NEXT:    call void @free(ptr [[A]])
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.lifetime.start.p0(i64 12, ptr %a)
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  call void @llvm.lifetime.end.p0(i64 12, ptr %a)
  call void @free(ptr %a)
  ret void
}

; The trailing bytes are not known to be undef, we can't ignore them.
define void @test_not_undef_memory(ptr %result, ptr %input) {
; CHECK-LABEL: @test_not_undef_memory(
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[INPUT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[INPUT]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0.i64(ptr align 8 %input, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %input, i64 16, i1 false)
  ret void
}

; Memset is volatile, memcpy is not. Can be optimized.
define void @test_volatile_memset(ptr %result) {
; CHECK-LABEL: @test_volatile_memset(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 true)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[RESULT:%.*]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 true)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

; Memcpy is volatile, memset is not. Cannot be optimized.
define void @test_volatile_memcpy(ptr %result) {
; CHECK-LABEL: @test_volatile_memcpy(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 true)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 true)
  ret void
}

; Write between memset and memcpy, can't optimize.
define void @test_write_between(ptr %result) {
; CHECK-LABEL: @test_write_between(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    store i8 -1, ptr [[A]], align 1
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  store i8 -1, ptr %a
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of the memset region.
; We could optimize this, but currently don't, because the used memory location is imprecise.
define void @test_write_before_memset_in_memset_region(ptr %result) {
; CHECK-LABEL: @test_write_before_memset_in_memset_region(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    store i8 -1, ptr [[A]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  store i8 -1, ptr %a
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 8, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of the memcpy (but not memset) region.
; This cannot be optimized.
define void @test_write_before_memset_in_memcpy_region(ptr %result) {
; CHECK-LABEL: @test_write_before_memset_in_memcpy_region(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[T]], ptr [[A]], i64 0, i32 2
; CHECK-NEXT:    store i32 -1, ptr [[C]], align 4
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %c = getelementptr inbounds %T, ptr %a, i64 0, i32 2
  store i32 -1, ptr %c
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 8, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

; A write prior to the memset, which is part of both the memset and memcpy regions.
; This cannot be optimized.
define void @test_write_before_memset_in_both_regions(ptr %result) {
; CHECK-LABEL: @test_write_before_memset_in_both_regions(
; CHECK-NEXT:    [[A:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[T]], ptr [[A]], i64 0, i32 1
; CHECK-NEXT:    store i32 -1, ptr [[C]], align 4
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 10, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %T, align 8
  %c = getelementptr inbounds %T, ptr %a, i64 0, i32 1
  store i32 -1, ptr %c
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 10, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

define void @test_negative_offset_memset(ptr %result) {
; CHECK-LABEL: @test_negative_offset_memset(
; CHECK-NEXT:    [[A1:%.*]] = alloca [16 x i8], align 8
; CHECK-NEXT:    [[A:%.*]] = getelementptr i8, ptr [[A1]], i32 4
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A1]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca [ 16 x i8 ], align 8
  %b = getelementptr i8, ptr %a, i32 4
  call void @llvm.memset.p0.i64(ptr align 8 %b, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 12, i1 false)
  ret void
}

define void @test_offset_memsetcpy(ptr %result) {
; CHECK-LABEL: @test_offset_memsetcpy(
; CHECK-NEXT:    [[A1:%.*]] = alloca [16 x i8], align 8
; CHECK-NEXT:    [[A:%.*]] = getelementptr i8, ptr [[A1]], i32 4
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A1]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[RESULT:%.*]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca [ 16 x i8 ], align 8
  %b = getelementptr i8, ptr %a, i32 4
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %b, i64 12, i1 false)
  ret void
}

define void @test_two_memset(ptr %result) {
; CHECK-LABEL: @test_two_memset(
; CHECK-NEXT:    [[A:%.*]] = alloca [16 x i8], align 8
; CHECK-NEXT:    [[B:%.*]] = getelementptr i8, ptr [[A]], i32 12
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[A]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[B]], i8 1, i64 4, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[RESULT:%.*]], ptr align 8 [[A]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca [ 16 x i8 ], align 8
  %b = getelementptr i8, ptr %a, i32 12
  call void @llvm.memset.p0.i64(ptr align 8 %a, i8 0, i64 12, i1 false)
  call void @llvm.memset.p0.i64(ptr align 8 %b, i8 1, i64 4, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %result, ptr align 8 %a, i64 16, i1 false)
  ret void
}

declare ptr @malloc(i64)
declare void @free(ptr)

declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1)
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture readonly, i64, i1)

declare void @llvm.lifetime.start.p0(i64, ptr nocapture)
declare void @llvm.lifetime.end.p0(i64, ptr nocapture)
