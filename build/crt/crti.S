.section ".init","ax"
.global ._init
._init:
	mflr	%r0
	std		%r0, 0x10(%r1)
	stdu	%r1, -0x80(%r1)

.section ".fini","ax"
.global ._fini
._fini:
	mflr	%r0
	std		%r0, 0x10(%r1)
	stdu	%r1, -0x80(%r1)

.section ".opd","aw"
.global _init
_init:
	.quad ._init
	.quad .TOC.@tocbase
	.quad 0

.global _fini
_fini:
	.quad ._fini
	.quad .TOC.@tocbase
	.quad 0
