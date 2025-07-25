; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-windows < %s | FileCheck %s

declare void @addrof_i1(ptr)
declare void @addrof_i32(ptr)
declare void @addrof_i64(ptr)
declare void @addrof_i128(ptr)
declare void @addrof_i32_x3(ptr, ptr, ptr)

define void @simple(i32 %x) {
; CHECK-LABEL: simple:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i32
  store i32 %x, ptr %x.addr
  call void @addrof_i32(ptr %x.addr)
  ret void
}

; We need to load %x before calling addrof_i32 now because it could mutate %x in
; place.

define i32 @use_arg(i32 %x) {
; CHECK-LABEL: use_arg:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i32
  store i32 %x, ptr %x.addr
  call void @addrof_i32(ptr %x.addr)
  ret i32 %x
}

; We won't copy elide for types needing legalization such as i64 or i1.

define i64 @split_i64(i64 %x) {
; CHECK-LABEL: split_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i64
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    movl %edi, %edx
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i64, align 4
  store i64 %x, ptr %x.addr, align 4
  call void @addrof_i64(ptr %x.addr)
  ret i64 %x
}

define i1 @i1_arg(i1 %x) {
; CHECK-LABEL: i1_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %ebx
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movb %al, {{[0-9]+}}(%esp)
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i1
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    retl
  %x.addr = alloca i1
  store i1 %x, ptr %x.addr
  call void @addrof_i1(ptr %x.addr)
  ret i1 %x
}

; We can't copy elide when an i64 is split between registers and memory in a
; fastcc function.

define fastcc i64 @fastcc_split_i64(ptr %p, i64 %x) {
; CHECK-LABEL: fastcc_split_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %edx, (%esp)
; CHECK-NEXT:    movl %esp, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i64
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    movl %edi, %edx
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i64, align 4
  store i64 %x, ptr %x.addr, align 4
  call void @addrof_i64(ptr %x.addr)
  ret i64 %x
}

; We can't copy elide when it would reduce the user requested alignment.

define void @high_alignment(i32 %x) {
; CHECK-LABEL: high_alignment:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-128, %esp
; CHECK-NEXT:    subl $128, %esp
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    movl %esp, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
  %x.p = alloca i32, align 128
  store i32 %x, ptr %x.p
  call void @addrof_i32(ptr %x.p)
  ret void
}

; We can't copy elide when it would reduce the ABI required alignment.
; FIXME: We should lower the ABI alignment of i64 on Windows, since MSVC
; doesn't guarantee it.

define void @abi_alignment(i64 %x) {
; CHECK-LABEL: abi_alignment:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-8, %esp
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    movl 12(%ebp), %ecx
; CHECK-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    movl %esp, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i64
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
  %x.p = alloca i64
  store i64 %x, ptr %x.p
  call void @addrof_i64(ptr %x.p)
  ret void
}

; The code we generate for this is unimportant. This is mostly a crash test.

define void @split_i128(ptr %sret, i128 %x) {
; CHECK-LABEL: split_i128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    andl $-16, %esp
; CHECK-NEXT:    subl $48, %esp
; CHECK-NEXT:    movl 24(%ebp), %eax
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    movl 28(%ebp), %ebx
; CHECK-NEXT:    movl 32(%ebp), %esi
; CHECK-NEXT:    movl 36(%ebp), %edi
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i128
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    movl %edi, 12(%eax)
; CHECK-NEXT:    movl %esi, 8(%eax)
; CHECK-NEXT:    movl %ebx, 4(%eax)
; CHECK-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; CHECK-NEXT:    movl %ecx, (%eax)
; CHECK-NEXT:    leal -12(%ebp), %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i128
  store i128 %x, ptr %x.addr
  call void @addrof_i128(ptr %x.addr)
  store i128 %x, ptr %sret
  ret void
}

; Check that we load all of x, y, and z before the call.

define i32 @three_args(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: three_args:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    addl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    addl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    pushl %ecx
; CHECK-NEXT:    pushl %edx
; CHECK-NEXT:    calll _addrof_i32_x3
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
entry:
  %z.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %x.addr = alloca i32, align 4
  store i32 %z, ptr %z.addr, align 4
  store i32 %y, ptr %y.addr, align 4
  store i32 %x, ptr %x.addr, align 4
  call void @addrof_i32_x3(ptr %x.addr, ptr %y.addr, ptr %z.addr)
  %s1 = add i32 %x, %y
  %sum = add i32 %s1, %z
  ret i32 %sum
}

define void @two_args_same_alloca(i32 %x, i32 %y) {
; CHECK-LABEL: two_args_same_alloca:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    retl
entry:
  %x.addr = alloca i32
  store i32 %x, ptr %x.addr
  store i32 %y, ptr %x.addr
  call void @addrof_i32(ptr %x.addr)
  ret void
}

define void @avoid_byval(ptr byval(i32) %x) {
; CHECK-LABEL: avoid_byval:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
entry:
  %x.p.p = alloca ptr
  store ptr %x, ptr %x.p.p
  call void @addrof_i32(ptr %x)
  ret void
}

define void @avoid_inalloca(ptr inalloca(i32) %x) {
; CHECK-LABEL: avoid_inalloca:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
entry:
  %x.p.p = alloca ptr
  store ptr %x, ptr %x.p.p
  call void @addrof_i32(ptr %x)
  ret void
}

define void @avoid_preallocated(ptr preallocated(i32) %x) {
; CHECK-LABEL: avoid_preallocated:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
entry:
  %x.p.p = alloca ptr
  store ptr %x, ptr %x.p.p
  call void @addrof_i32(ptr %x)
  ret void
}

; Don't elide the copy when the alloca is escaped with a store.
define void @escape_with_store(i32 %x) {
; CHECK-LABEL: escape_with_store:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %esp, %ecx
; CHECK-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    pushl %ecx
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    retl
  %x1 = alloca i32
  %x2 = alloca ptr
  store ptr %x1, ptr %x2
  %x3 = load ptr, ptr %x2
  store i32 0, ptr %x3
  store i32 %x, ptr %x1
  call void @addrof_i32(ptr %x1)
  ret void
}

; This test case exposed issues with the use of TokenFactor.

define void @sret_and_elide(ptr sret(i32) %sret, i32 %v) {
; CHECK-LABEL: sret_and_elide:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
  %v.p = alloca i32
  store i32 %v, ptr %v.p
  call void @addrof_i32(ptr %v.p)
  store i32 %v, ptr %sret
  ret void
}

define void @avoid_partially_initialized_alloca(i32 %x) {
; CHECK-LABEL: avoid_partially_initialized_alloca:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-8, %esp
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    movl %esp, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    calll _addrof_i32
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
  %a = alloca i64
  store i32 %x, ptr %a
  call void @addrof_i32(ptr %a)
  ret void
}

; Ensure no copy elision happens as the two i3 values fed into icmp may have
; garbage in the upper bits, a truncation is needed.

define i1 @use_i3(i3 %a1, i3 %a2) {
; CHECK-LABEL: use_i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    andb $7, %al
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    andb $7, %cl
; CHECK-NEXT:    movb %cl, {{[0-9]+}}(%esp)
; CHECK-NEXT:    cmpb %cl, %al
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    popl %ecx
; CHECK-NEXT:    retl
  %tmp = alloca i3
  store i3 %a2, ptr %tmp
  %val = load i3, ptr %tmp
  %res = icmp eq i3 %a1, %val
  ret i1 %res
}

