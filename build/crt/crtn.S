.section ".init","ax"
	addi	%r1, %r1, 0x80
	ld		%r0, 0x10(%r1)
	mtlr	%r0
	blr

.section ".fini","ax"
	addi	%r1, %r1, 0x80
	ld		%r0, 0x10(%r1)
	mtlr	%r0
	blr
