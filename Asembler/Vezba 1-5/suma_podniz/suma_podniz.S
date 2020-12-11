# Suma na podnizu
# Tadija Sebez SV 4/2020

.section .data
N = 10
niz: .long 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
suma: .long 0
l: .long 2
r: .long 6
.section .text 
.global main
main:
	movl l, %esi
	movl $0, %eax
petlja:
	cmpl r, %esi
	ja kraj
	addl niz(,%esi,4), %eax
	incl %esi
	jmp petlja
kraj:
	movl %eax, suma
	movl $1, %eax
	movl $0, %ebx
	int $0x80
