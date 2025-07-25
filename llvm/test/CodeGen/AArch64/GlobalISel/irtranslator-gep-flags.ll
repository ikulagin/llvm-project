; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=aarch64-linux-gnu -global-isel -stop-after=irtranslator %s -o - | FileCheck %s

define i32 @gep_nusw_nuw(ptr %ptr, i32 %idx) {
  ; CHECK-LABEL: name: gep_nusw_nuw
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $w1, $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(s64) = G_SEXT [[COPY1]](s32)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK-NEXT:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL]](s64)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[PTR_ADD]](p0)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY2]](p0) :: (load (s32) from %ir.gep1)
  ; CHECK-NEXT:   [[MUL1:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL1]](s64)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = nuw nusw G_PTR_ADD [[PTR_ADD1]], [[C1]](s64)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD2]](p0) :: (load (s32) from %ir.gep2)
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[LOAD]], [[LOAD1]]
  ; CHECK-NEXT:   $w0 = COPY [[ADD]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  %sidx = sext i32 %idx to i64
  %gep1 = getelementptr inbounds [4 x i32], ptr %ptr, i64 %sidx, i64 0
  %v1 = load i32, ptr %gep1
  %gep2 = getelementptr nusw nuw [4 x i32], ptr %ptr, i64 %sidx, i64 1
  %v2 = load i32, ptr %gep2
  %res = add i32 %v1, %v2
  ret i32 %res
 }

define i32 @gep_nuw(ptr %ptr, i32 %idx) {
  ; CHECK-LABEL: name: gep_nuw
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $w1, $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(s64) = G_SEXT [[COPY1]](s32)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK-NEXT:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL]](s64)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[PTR_ADD]](p0)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY2]](p0) :: (load (s32) from %ir.gep1)
  ; CHECK-NEXT:   [[MUL1:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL1]](s64)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = nuw G_PTR_ADD [[PTR_ADD1]], [[C1]](s64)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD2]](p0) :: (load (s32) from %ir.gep2)
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[LOAD]], [[LOAD1]]
  ; CHECK-NEXT:   $w0 = COPY [[ADD]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  %sidx = sext i32 %idx to i64
  %gep1 = getelementptr inbounds [4 x i32], ptr %ptr, i64 %sidx, i64 0
  %v1 = load i32, ptr %gep1
  %gep2 = getelementptr nuw [4 x i32], ptr %ptr, i64 %sidx, i64 1
  %v2 = load i32, ptr %gep2
  %res = add i32 %v1, %v2
  ret i32 %res
 }

define i32 @gep_nusw(ptr %ptr, i32 %idx) {
  ; CHECK-LABEL: name: gep_nusw
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $w1, $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(s64) = G_SEXT [[COPY1]](s32)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK-NEXT:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL]](s64)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[PTR_ADD]](p0)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY2]](p0) :: (load (s32) from %ir.gep1)
  ; CHECK-NEXT:   [[MUL1:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL1]](s64)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = nusw G_PTR_ADD [[PTR_ADD1]], [[C1]](s64)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD2]](p0) :: (load (s32) from %ir.gep2)
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[LOAD]], [[LOAD1]]
  ; CHECK-NEXT:   $w0 = COPY [[ADD]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  %sidx = sext i32 %idx to i64
  %gep1 = getelementptr inbounds [4 x i32], ptr %ptr, i64 %sidx, i64 0
  %v1 = load i32, ptr %gep1
  %gep2 = getelementptr nusw [4 x i32], ptr %ptr, i64 %sidx, i64 1
  %v2 = load i32, ptr %gep2
  %res = add i32 %v1, %v2
  ret i32 %res
 }

define i32 @gep_none(ptr %ptr, i32 %idx) {
  ; CHECK-LABEL: name: gep_none
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $w1, $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(s64) = G_SEXT [[COPY1]](s32)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK-NEXT:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL]](s64)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[PTR_ADD]](p0)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY2]](p0) :: (load (s32) from %ir.gep1)
  ; CHECK-NEXT:   [[MUL1:%[0-9]+]]:_(s64) = G_MUL [[SEXT]], [[C]]
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[MUL1]](s64)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[PTR_ADD1]], [[C1]](s64)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD2]](p0) :: (load (s32) from %ir.gep2)
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[LOAD]], [[LOAD1]]
  ; CHECK-NEXT:   $w0 = COPY [[ADD]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  %sidx = sext i32 %idx to i64
  %gep1 = getelementptr inbounds [4 x i32], ptr %ptr, i64 %sidx, i64 0
  %v1 = load i32, ptr %gep1
  %gep2 = getelementptr [4 x i32], ptr %ptr, i64 %sidx, i64 1
  %v2 = load i32, ptr %gep2
  %res = add i32 %v1, %v2
  ret i32 %res
 }
