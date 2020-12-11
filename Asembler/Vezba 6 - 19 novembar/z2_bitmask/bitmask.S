# Autor: Tadija Sebez SV 4/2020

.section .data
.section .text
.global maska64

# unsigned long long maska64(unsigned int n, unsigned int v);
maska64:
	pushl %ebp
	movl %esp, %ebp

	movl 12(%ebp), %ebx # ebx=v
	movl 8(%ebp), %ecx # ecx=n
	
	cmpl $1, %ebx
	jg greska
	cmpl $63, %ecx
	jg greska

	cmpl $1, %ebx
	je v1

v0:
	movl $0xffffffff, %eax
	movl $0xffffffff, %edx
	jmp dalje

v1:
	movl $0, %eax
	movl $0, %edx

dalje:
	cmpl $31, %ebx
	jg visi

nizi:
	movl $1, %ebx
	shll %cl, %ebx
	xorl %ebx, %eax
	jmp kraj

visi:
	subl $32, %ecx
	movl $1, %ebx
	shll %cl, %ebx
	xorl %ebx, %edx
	jmp kraj

greska:
	movl $0, %eax
	movl $0, %edx

kraj:
	movl %ebp, %esp
	popl %ebp
	ret
