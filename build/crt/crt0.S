#define LOAD_DWORD(reg, sym) \
	li		reg, (sym)@higher; \
	oris	reg, reg, (sym)@highest; \
	sldi	reg, reg, 0x20; \
	oris	reg, reg, (sym)@h; \
	ori		reg, reg, (sym)@l \
	

.global ._start
._start:
	LOAD_DWORD(%r2, __libc_stack_end)
	std		%r1, 0x00(%r2)
	mflr	%r0
	stdu	%r1, -0x80(%r1)
	std		%r0, 0x70(%r1)
	li		%r2, 0
	std		%r2, 0x00(%r1)
	LOAD_DWORD(%r2, _start)
	ld		%r2, 0x08(%r2)
	bl		._initialize
	ld		%r0, 0x70(%r1)
	addi	%r1, %r1, 0x80
	mtlr	%r0
	blr

.section ".bss","aw"
.global __libc_stack_end
__libc_stack_end:
	.quad 0	

.section ".opd","aw"
.global _start
_start:
	.quad ._start
	.quad .TOC.@tocbase
	.quad 0

