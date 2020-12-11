# Razdvajanje bajtova
# Tadija Sebez SV 4/2020
.section .data
a: .long 0x12345678
.section .text
.global main
main:
	movb a, %al
	movb a+1, %ah
	movb a+2, %bl
	movb a+3, %bh
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
