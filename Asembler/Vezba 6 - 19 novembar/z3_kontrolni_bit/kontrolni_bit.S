# Autor: Tadija Sebez SV 4/2020

.section .text
.section .data
.global SetParity

# int SetParity(unsigned short int* v);
SetParity:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %eax
	movl 8(%ebp), %ebx # ebx=&v	
	movw (%ebx), %cx
	
petlja:
	cmpw $0, %cx
	je kraj
	
	movl $1, %edx
	andw %cx, %dx
	xorl %edx, %eax

	shrw $1, %cx
	jmp petlja

kraj:
	movw %ax, %dx
	shlw $15, %dx
	xorw %dx, (%ebx)
	movw (%ebx), %ax
	shrw $15, %ax
	
	movl %ebp, %esp
	popl %ebp
	ret
