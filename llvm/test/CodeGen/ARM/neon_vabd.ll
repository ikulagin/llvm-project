; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7a-eabihf -mattr=+neon %s -o - | FileCheck %s

;
; SABD
;

define <8 x i8> @sabd_8b(<8 x i8> %a, <8 x i8> %b) {
; CHECK-LABEL: sabd_8b:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s8 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <8 x i8> %a to <8 x i16>
  %b.sext = sext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.sext, %b.sext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  %trunc = trunc <8 x i16> %abs to <8 x i8>
  ret <8 x i8> %trunc
}

define <16 x i8> @sabd_16b(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: sabd_16b:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.sext = sext <16 x i8> %a to <16 x i16>
  %b.sext = sext <16 x i8> %b to <16 x i16>
  %sub = sub <16 x i16> %a.sext, %b.sext
  %abs = call <16 x i16> @llvm.abs.v16i16(<16 x i16> %sub, i1 true)
  %trunc = trunc <16 x i16> %abs to <16 x i8>
  ret <16 x i8> %trunc
}

define <4 x i16> @sabd_4h(<4 x i16> %a, <4 x i16> %b) {
; CHECK-LABEL: sabd_4h:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s16 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <4 x i16> %a to <4 x i32>
  %b.sext = sext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.sext, %b.sext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  %trunc = trunc <4 x i32> %abs to <4 x i16>
  ret <4 x i16> %trunc
}

define <4 x i16> @sabd_4h_promoted_ops(<4 x i8> %a, <4 x i8> %b) {
; CHECK-LABEL: sabd_4h_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vshl.i16 d16, d1, #8
; CHECK-NEXT:    vshl.i16 d17, d0, #8
; CHECK-NEXT:    vshr.s16 d16, d16, #8
; CHECK-NEXT:    vshr.s16 d17, d17, #8
; CHECK-NEXT:    vabd.s16 d0, d17, d16
; CHECK-NEXT:    bx lr
  %a.sext = sext <4 x i8> %a to <4 x i16>
  %b.sext = sext <4 x i8> %b to <4 x i16>
  %sub = sub <4 x i16> %a.sext, %b.sext
  %abs = call <4 x i16> @llvm.abs.v4i16(<4 x i16> %sub, i1 true)
  ret <4 x i16> %abs
}

define <8 x i16> @sabd_8h(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: sabd_8h:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.sext = sext <8 x i16> %a to <8 x i32>
  %b.sext = sext <8 x i16> %b to <8 x i32>
  %sub = sub <8 x i32> %a.sext, %b.sext
  %abs = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %sub, i1 true)
  %trunc = trunc <8 x i32> %abs to <8 x i16>
  ret <8 x i16> %trunc
}

define <8 x i16> @sabd_8h_promoted_ops(<8 x i8> %a, <8 x i8> %b) {
; CHECK-LABEL: sabd_8h_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.s8 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <8 x i8> %a to <8 x i16>
  %b.sext = sext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.sext, %b.sext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <2 x i32> @sabd_2s(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: sabd_2s:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s32 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <2 x i32> %a to <2 x i64>
  %b.sext = sext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.sext, %b.sext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  %trunc = trunc <2 x i64> %abs to <2 x i32>
  ret <2 x i32> %trunc
}

define <2 x i32> @sabd_2s_promoted_ops(<2 x i16> %a, <2 x i16> %b) {
; CHECK-LABEL: sabd_2s_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vshl.i32 d16, d1, #16
; CHECK-NEXT:    vshl.i32 d17, d0, #16
; CHECK-NEXT:    vshr.s32 d16, d16, #16
; CHECK-NEXT:    vshr.s32 d17, d17, #16
; CHECK-NEXT:    vabd.s32 d0, d17, d16
; CHECK-NEXT:    bx lr
  %a.sext = sext <2 x i16> %a to <2 x i32>
  %b.sext = sext <2 x i16> %b to <2 x i32>
  %sub = sub <2 x i32> %a.sext, %b.sext
  %abs = call <2 x i32> @llvm.abs.v2i32(<2 x i32> %sub, i1 true)
  ret <2 x i32> %abs
}

define <4 x i32> @sabd_4s(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: sabd_4s:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.sext = sext <4 x i32> %a to <4 x i64>
  %b.sext = sext <4 x i32> %b to <4 x i64>
  %sub = sub <4 x i64> %a.sext, %b.sext
  %abs = call <4 x i64> @llvm.abs.v4i64(<4 x i64> %sub, i1 true)
  %trunc = trunc <4 x i64> %abs to <4 x i32>
  ret <4 x i32> %trunc
}

define <4 x i32> @sabd_4s_promoted_ops(<4 x i16> %a, <4 x i16> %b) {
; CHECK-LABEL: sabd_4s_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.s16 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <4 x i16> %a to <4 x i32>
  %b.sext = sext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.sext, %b.sext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @sabd_2d(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: sabd_2d:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    mov r6, #0
; CHECK-NEXT:    vmov r2, r3, d3
; CHECK-NEXT:    vmov r12, lr, d0
; CHECK-NEXT:    vmov r4, r5, d2
; CHECK-NEXT:    vsub.i64 q8, q0, q1
; CHECK-NEXT:    subs r0, r2, r0
; CHECK-NEXT:    sbcs r0, r3, r1
; CHECK-NEXT:    mov r0, #0
; CHECK-NEXT:    movwlt r0, #1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    mvnne r0, #0
; CHECK-NEXT:    subs r1, r4, r12
; CHECK-NEXT:    sbcs r1, r5, lr
; CHECK-NEXT:    vdup.32 d19, r0
; CHECK-NEXT:    movwlt r6, #1
; CHECK-NEXT:    cmp r6, #0
; CHECK-NEXT:    mvnne r6, #0
; CHECK-NEXT:    vdup.32 d18, r6
; CHECK-NEXT:    veor q8, q8, q9
; CHECK-NEXT:    vsub.i64 q0, q9, q8
; CHECK-NEXT:    pop {r4, r5, r6, pc}
  %a.sext = sext <2 x i64> %a to <2 x i128>
  %b.sext = sext <2 x i64> %b to <2 x i128>
  %sub = sub <2 x i128> %a.sext, %b.sext
  %abs = call <2 x i128> @llvm.abs.v2i128(<2 x i128> %sub, i1 true)
  %trunc = trunc <2 x i128> %abs to <2 x i64>
  ret <2 x i64> %trunc
}

define <2 x i64> @sabd_2d_promoted_ops(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: sabd_2d_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.s32 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.sext = sext <2 x i32> %a to <2 x i64>
  %b.sext = sext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.sext, %b.sext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

;
; UABD
;

define <8 x i8> @uabd_8b(<8 x i8> %a, <8 x i8> %b) {
; CHECK-LABEL: uabd_8b:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u8 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <8 x i8> %a to <8 x i16>
  %b.zext = zext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.zext, %b.zext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  %trunc = trunc <8 x i16> %abs to <8 x i8>
  ret <8 x i8> %trunc
}

define <16 x i8> @uabd_16b(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: uabd_16b:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.zext = zext <16 x i8> %a to <16 x i16>
  %b.zext = zext <16 x i8> %b to <16 x i16>
  %sub = sub <16 x i16> %a.zext, %b.zext
  %abs = call <16 x i16> @llvm.abs.v16i16(<16 x i16> %sub, i1 true)
  %trunc = trunc <16 x i16> %abs to <16 x i8>
  ret <16 x i8> %trunc
}

define <4 x i16> @uabd_4h(<4 x i16> %a, <4 x i16> %b) {
; CHECK-LABEL: uabd_4h:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u16 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <4 x i16> %a to <4 x i32>
  %b.zext = zext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.zext, %b.zext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  %trunc = trunc <4 x i32> %abs to <4 x i16>
  ret <4 x i16> %trunc
}

define <4 x i16> @uabd_4h_promoted_ops(<4 x i8> %a, <4 x i8> %b) {
; CHECK-LABEL: uabd_4h_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vbic.i16 d1, #0xff00
; CHECK-NEXT:    vbic.i16 d0, #0xff00
; CHECK-NEXT:    vabd.u16 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <4 x i8> %a to <4 x i16>
  %b.zext = zext <4 x i8> %b to <4 x i16>
  %sub = sub <4 x i16> %a.zext, %b.zext
  %abs = call <4 x i16> @llvm.abs.v4i16(<4 x i16> %sub, i1 true)
  ret <4 x i16> %abs
}

define <8 x i16> @uabd_8h(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: uabd_8h:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.zext = zext <8 x i16> %a to <8 x i32>
  %b.zext = zext <8 x i16> %b to <8 x i32>
  %sub = sub <8 x i32> %a.zext, %b.zext
  %abs = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %sub, i1 true)
  %trunc = trunc <8 x i32> %abs to <8 x i16>
  ret <8 x i16> %trunc
}

define <8 x i16> @uabd_8h_promoted_ops(<8 x i8> %a, <8 x i8> %b) {
; CHECK-LABEL: uabd_8h_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.u8 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <8 x i8> %a to <8 x i16>
  %b.zext = zext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.zext, %b.zext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <2 x i32> @uabd_2s(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: uabd_2s:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u32 d0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <2 x i32> %a to <2 x i64>
  %b.zext = zext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.zext, %b.zext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  %trunc = trunc <2 x i64> %abs to <2 x i32>
  ret <2 x i32> %trunc
}

define <2 x i32> @uabd_2s_promoted_ops(<2 x i16> %a, <2 x i16> %b) {
; CHECK-LABEL: uabd_2s_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov.i32 d16, #0xffff
; CHECK-NEXT:    vand d17, d1, d16
; CHECK-NEXT:    vand d16, d0, d16
; CHECK-NEXT:    vabd.u32 d0, d16, d17
; CHECK-NEXT:    bx lr
  %a.zext = zext <2 x i16> %a to <2 x i32>
  %b.zext = zext <2 x i16> %b to <2 x i32>
  %sub = sub <2 x i32> %a.zext, %b.zext
  %abs = call <2 x i32> @llvm.abs.v2i32(<2 x i32> %sub, i1 true)
  ret <2 x i32> %abs
}

define <4 x i32> @uabd_4s(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: uabd_4s:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a.zext = zext <4 x i32> %a to <4 x i64>
  %b.zext = zext <4 x i32> %b to <4 x i64>
  %sub = sub <4 x i64> %a.zext, %b.zext
  %abs = call <4 x i64> @llvm.abs.v4i64(<4 x i64> %sub, i1 true)
  %trunc = trunc <4 x i64> %abs to <4 x i32>
  ret <4 x i32> %trunc
}

define <4 x i32> @uabd_4s_promoted_ops(<4 x i16> %a, <4 x i16> %b) {
; CHECK-LABEL: uabd_4s_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.u16 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <4 x i16> %a to <4 x i32>
  %b.zext = zext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.zext, %b.zext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @uabd_2d(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: uabd_2d:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vqsub.u64 q8, q1, q0
; CHECK-NEXT:    vqsub.u64 q9, q0, q1
; CHECK-NEXT:    vorr q0, q9, q8
; CHECK-NEXT:    bx lr
  %a.zext = zext <2 x i64> %a to <2 x i128>
  %b.zext = zext <2 x i64> %b to <2 x i128>
  %sub = sub <2 x i128> %a.zext, %b.zext
  %abs = call <2 x i128> @llvm.abs.v2i128(<2 x i128> %sub, i1 true)
  %trunc = trunc <2 x i128> %abs to <2 x i64>
  ret <2 x i64> %trunc
}

define <2 x i64> @uabd_2d_promoted_ops(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: uabd_2d_promoted_ops:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabdl.u32 q0, d0, d1
; CHECK-NEXT:    bx lr
  %a.zext = zext <2 x i32> %a to <2 x i64>
  %b.zext = zext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.zext, %b.zext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

define <16 x i8> @uabd_v16i8_nuw(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: uabd_v16i8_nuw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i8 q8, q0, q1
; CHECK-NEXT:    vabs.s8 q0, q8
; CHECK-NEXT:    bx lr
  %sub = sub nuw <16 x i8> %a, %b
  %abs = call <16 x i8> @llvm.abs.v16i8(<16 x i8> %sub, i1 true)
  ret <16 x i8> %abs
}

define <8 x i16> @uabd_v8i16_nuw(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: uabd_v8i16_nuw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i16 q8, q0, q1
; CHECK-NEXT:    vabs.s16 q0, q8
; CHECK-NEXT:    bx lr
  %sub = sub nuw <8 x i16> %a, %b
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <4 x i32> @uabd_v4i32_nuw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: uabd_v4i32_nuw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i32 q8, q0, q1
; CHECK-NEXT:    vabs.s32 q0, q8
; CHECK-NEXT:    bx lr
  %sub = sub nuw <4 x i32> %a, %b
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @uabd_v2i64_nuw(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: uabd_v2i64_nuw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i64 q8, q0, q1
; CHECK-NEXT:    vshr.s64 q9, q8, #63
; CHECK-NEXT:    veor q8, q8, q9
; CHECK-NEXT:    vsub.i64 q0, q8, q9
; CHECK-NEXT:    bx lr
  %sub = sub nuw <2 x i64> %a, %b
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

define <16 x i8> @sabd_v16i8_nsw(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: sabd_v16i8_nsw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <16 x i8> %a, %b
  %abs = call <16 x i8> @llvm.abs.v16i8(<16 x i8> %sub, i1 true)
  ret <16 x i8> %abs
}

define <8 x i16> @sabd_v8i16_nsw(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: sabd_v8i16_nsw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <8 x i16> %a, %b
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <4 x i32> @sabd_v4i32_nsw(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: sabd_v4i32_nsw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <4 x i32> %a, %b
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @sabd_v2i64_nsw(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: sabd_v2i64_nsw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i64 q8, q0, q1
; CHECK-NEXT:    vshr.s64 q9, q8, #63
; CHECK-NEXT:    veor q8, q8, q9
; CHECK-NEXT:    vsub.i64 q0, q8, q9
; CHECK-NEXT:    bx lr
  %sub = sub nsw <2 x i64> %a, %b
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

define <16 x i8> @smaxmin_v16i8(<16 x i8> %0, <16 x i8> %1) {
; CHECK-LABEL: smaxmin_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <16 x i8> @llvm.smax.v16i8(<16 x i8> %0, <16 x i8> %1)
  %b = tail call <16 x i8> @llvm.smin.v16i8(<16 x i8> %0, <16 x i8> %1)
  %sub = sub <16 x i8> %a, %b
  ret <16 x i8> %sub
}

define <8 x i16> @smaxmin_v8i16(<8 x i16> %0, <8 x i16> %1) {
; CHECK-LABEL: smaxmin_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <8 x i16> @llvm.smax.v8i16(<8 x i16> %0, <8 x i16> %1)
  %b = tail call <8 x i16> @llvm.smin.v8i16(<8 x i16> %0, <8 x i16> %1)
  %sub = sub <8 x i16> %a, %b
  ret <8 x i16> %sub
}

define <4 x i32> @smaxmin_v4i32(<4 x i32> %0, <4 x i32> %1) {
; CHECK-LABEL: smaxmin_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <4 x i32> @llvm.smax.v4i32(<4 x i32> %0, <4 x i32> %1)
  %b = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %0, <4 x i32> %1)
  %sub = sub <4 x i32> %a, %b
  ret <4 x i32> %sub
}

define <2 x i64> @smaxmin_v2i64(<2 x i64> %0, <2 x i64> %1) {
; CHECK-LABEL: smaxmin_v2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    mov r6, #0
; CHECK-NEXT:    vmov r2, r3, d3
; CHECK-NEXT:    vmov r12, lr, d0
; CHECK-NEXT:    vmov r4, r5, d2
; CHECK-NEXT:    vsub.i64 q8, q0, q1
; CHECK-NEXT:    subs r0, r2, r0
; CHECK-NEXT:    sbcs r0, r3, r1
; CHECK-NEXT:    mov r0, #0
; CHECK-NEXT:    movwlt r0, #1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    mvnne r0, #0
; CHECK-NEXT:    subs r1, r4, r12
; CHECK-NEXT:    sbcs r1, r5, lr
; CHECK-NEXT:    vdup.32 d19, r0
; CHECK-NEXT:    movwlt r6, #1
; CHECK-NEXT:    cmp r6, #0
; CHECK-NEXT:    mvnne r6, #0
; CHECK-NEXT:    vdup.32 d18, r6
; CHECK-NEXT:    veor q8, q8, q9
; CHECK-NEXT:    vsub.i64 q0, q9, q8
; CHECK-NEXT:    pop {r4, r5, r6, pc}
  %a = tail call <2 x i64> @llvm.smax.v2i64(<2 x i64> %0, <2 x i64> %1)
  %b = tail call <2 x i64> @llvm.smin.v2i64(<2 x i64> %0, <2 x i64> %1)
  %sub = sub <2 x i64> %a, %b
  ret <2 x i64> %sub
}

define <16 x i8> @umaxmin_v16i8(<16 x i8> %0, <16 x i8> %1) {
; CHECK-LABEL: umaxmin_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <16 x i8> @llvm.umax.v16i8(<16 x i8> %0, <16 x i8> %1)
  %b = tail call <16 x i8> @llvm.umin.v16i8(<16 x i8> %0, <16 x i8> %1)
  %sub = sub <16 x i8> %a, %b
  ret <16 x i8> %sub
}

define <8 x i16> @umaxmin_v8i16(<8 x i16> %0, <8 x i16> %1) {
; CHECK-LABEL: umaxmin_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <8 x i16> @llvm.umax.v8i16(<8 x i16> %0, <8 x i16> %1)
  %b = tail call <8 x i16> @llvm.umin.v8i16(<8 x i16> %0, <8 x i16> %1)
  %sub = sub <8 x i16> %a, %b
  ret <8 x i16> %sub
}

define <4 x i32> @umaxmin_v4i32(<4 x i32> %0, <4 x i32> %1) {
; CHECK-LABEL: umaxmin_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <4 x i32> @llvm.umax.v4i32(<4 x i32> %0, <4 x i32> %1)
  %b = tail call <4 x i32> @llvm.umin.v4i32(<4 x i32> %0, <4 x i32> %1)
  %sub = sub <4 x i32> %a, %b
  ret <4 x i32> %sub
}

define <2 x i64> @umaxmin_v2i64(<2 x i64> %0, <2 x i64> %1) {
; CHECK-LABEL: umaxmin_v2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vqsub.u64 q8, q1, q0
; CHECK-NEXT:    vqsub.u64 q9, q0, q1
; CHECK-NEXT:    vorr q0, q9, q8
; CHECK-NEXT:    bx lr
  %a = tail call <2 x i64> @llvm.umax.v2i64(<2 x i64> %0, <2 x i64> %1)
  %b = tail call <2 x i64> @llvm.umin.v2i64(<2 x i64> %0, <2 x i64> %1)
  %sub = sub <2 x i64> %a, %b
  ret <2 x i64> %sub
}

define <16 x i8> @umaxmin_v16i8_com1(<16 x i8> %0, <16 x i8> %1) {
; CHECK-LABEL: umaxmin_v16i8_com1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %a = tail call <16 x i8> @llvm.umax.v16i8(<16 x i8> %0, <16 x i8> %1)
  %b = tail call <16 x i8> @llvm.umin.v16i8(<16 x i8> %1, <16 x i8> %0)
  %sub = sub <16 x i8> %a, %b
  ret <16 x i8> %sub
}
