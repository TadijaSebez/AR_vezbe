# Minimum i maksimum u nizu
# Tadija Sebez SV 4/2020

.section .data
N = 10
niz: .long 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
max: .long 0
min: .long 0
.section .text
.global main
main:
	movl $1, %esi
	movl niz, %ecx
	movl niz, %edx
petlja:
	cmpl $N, %esi
	jge kraj
	cmpl niz(,%esi,4), %ecx
	jge nastavi1
	movl niz(,%esi,4), %ecx
nastavi1:
	cmpl niz(,%esi,4), %edx
	jle nastavi2
	movl niz(,%esi,4), %edx
nastavi2:
	incl %esi
	jmp petlja
kraj:
	movl %ecx, max
	movl %edx, min
	movl $1, %eax
	movl $0, %ebx
	int $0x80

