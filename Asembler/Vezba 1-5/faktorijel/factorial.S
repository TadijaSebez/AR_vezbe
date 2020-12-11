# Faktorijel
# Tadija Sebez SV 4/2020
.section .data
.section .text
.global main
main:
	movl $5, %eax
	movl $1, %ebx
radi:
	cmpl $1, %eax
	jle kraj
	movl %eax, %ecx
	movl $0, %edx
mnozi:
	cmpl $0, %ecx
	je nastavi
	addl %ebx, %edx
	subl $1, %ecx
	jmp mnozi
nastavi:
	movl %edx, %ebx
	subl $1, %eax
	jmp radi
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
