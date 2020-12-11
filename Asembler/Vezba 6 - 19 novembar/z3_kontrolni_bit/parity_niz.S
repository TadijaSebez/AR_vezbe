# Autor: Tadija Sebez SV 4/2020

.section .text
.section .data
.global SetParityArray

# int SetParityArray(unsigned short int* niz, int n);
SetParityArray:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %esi # esi=niz
	pushl $0

petlja:
	movl 12(%ebp), %ebx # ebx=n
	addl 12(%ebp), %ebx
	addl 8(%ebp), %ebx
	cmpl %ebx, %esi
	jge kraj

	pushl %esi
	call SetParity
	popl %esi
	
	addl %eax, -4(%ebp)

	addl $2, %esi
	jmp petlja

kraj:
	movl -4(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret
