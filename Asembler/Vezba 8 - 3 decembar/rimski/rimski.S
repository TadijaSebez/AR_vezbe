# Konverzija rimskih brojeva
# Autor: Tadija Sebez SV 4/2020

.section .text
.globl roman_to_inter
dec:    .long 1000, 500, 100, 50, 10, 5, 1
rom:   .ascii "MDCLXVI\0"

# unsigned int roman_to_inter(char* str, unsigned int* greska);
roman_to_inter:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %esi  # str
	movl 12(%ebp), %edi # greska
	movl $0, (%edi)

pretvori:
	movb (%esi), %bl
	cmpb $0, %bl
	je dalje
	
	cmpb $'M', %bl
	je M
	cmpb $'D', %bl
	je D
	cmpb $'C', %bl
	je C
	cmpb $'L', %bl
	je L
	cmpb $'X', %bl
	je X
	cmpb $'V', %bl
	je V
	cmpb $'I', %bl
	je I
	jmp greska
M:
	movb $0, %bl
	jmp nastavi
D:
	movb $1, %bl
	jmp nastavi
C:
	movb $2, %bl
	jmp nastavi
L:
	movb $3, %bl
	jmp nastavi
X:
	movb $4, %bl
	jmp nastavi
V:
	movb $5, %bl
	jmp nastavi
I:
	movb $6, %bl
	jmp nastavi
nastavi:
	movb %bl, (%esi)
	incl %esi
	jmp pretvori

dalje:
	movl %esi, %ecx
	movb $10, (%esi)
	movl 8(%ebp), %esi
	movl $0, %eax
	movl $0, %ebx

petlja:
	cmpl %esi, %ecx
	je kraj
	movb (%esi), %bl
	movb 1(%esi), %dl
	cmpb %dl, %bl
	ja oduzmi
	shll $2, %ebx
	addl dec(%ebx), %eax
	jmp nastavi_petlju
oduzmi:
	shll $2, %ebx
	subl dec(%ebx), %eax

nastavi_petlju:
	incl %esi
	jmp petlja

greska:
	movl $1, (%edi)

kraj:
	movl %ebp, %esp
	popl %ebp
	ret
