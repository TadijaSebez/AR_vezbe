# Autor: Tadija Sebez SV 4/2020

.section .data
.section .text
.global maska

# unsigned int maska(unsigned int n, unsigned int v);
maska:
	pushl %ebp
	movl %esp, %ebp
	# subl $4, %ebp

	movl 12(%ebp), %ebx # ebx=v
	movl 8(%ebp), %ecx # ecx=n
	
	cmpl $32, %ecx
	jge greska
	cmpl $1, %ebx
	jg greska

	cmpl $0, %ebx
	je v0

v1:
	movl $0, %eax
	jmp dalje

v0:
	movl $0xffffffff, %eax

dalje:
	movl $1, %ebx
	shll %cl, %ebx
	xorl %ebx, %eax
	jmp kraj

greska:
	movl $0, %eax

kraj:
	movl %ebp, %esp
	popl %ebp
	ret
