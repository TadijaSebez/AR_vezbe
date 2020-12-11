# Mnozenje 64 bitnih brojeva pomocu sabiranja
# Tadija Sebez SV 4/2020
.section .data
a: .quad 0x10
b: .quad 0x10000000
r: .quad 0
greska: .byte 0
.section .text
.global main
main:
	movl a+4, %eax
	movl b+4, %ebx
	cmpl %eax, %ebx
	jg radi
	jl zameni
	movl a, %eax
	movl b, %ebx
	cmpl %eax, %ebx
	jl zameni
	jmp radi
zameni:
	movl a, %eax
	movl a+4, %ebx
	movl b, %ecx
	movl b+4, %edx
	movl %eax, b
	movl %ebx, b+4
	movl %ecx, a
	movl %edx, a+4
radi:
	movl a+4, %eax
	cmpl $0, %eax
	jg nastavi
	movl a, %eax
	cmpl $0, %eax
	je kraj
nastavi:
	movl b, %eax
	movl b+4, %ebx
	addl %eax, r
	adcl %ebx, r+4
	jc err
	movl a, %eax
	cmpl $0, %eax
	je veci
	decl a
	jmp radi
veci:
	decl a+4
	movl $0xffffffff, %eax
	movl %eax, a
	jmp radi
err:
	movl $1, greska
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
