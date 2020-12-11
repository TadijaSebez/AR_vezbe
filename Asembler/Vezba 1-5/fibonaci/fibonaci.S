# Fibonaci
# Tadija Sebez SV 4/2020
.section .data
.section .text
.global main
main:
	movl $1, %eax
	movl $1, %ebx
	movl $5, %ecx
radi:
	cmpl $1, %ecx
	je kraj
	movl %ebx, %edx
	addl %eax, %ebx
	movl %edx, %eax
	subl $1, %ecx
	jmp radi
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
