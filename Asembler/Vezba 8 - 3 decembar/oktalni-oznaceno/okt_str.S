# Konverzija oktalnog stringa u neoznaceni integer
# Autor: Tadija Sebez SV 4/2020

.section .data

.section .text

.global oct_str_to_inter

# unsigned int oct_str_to_inter(char* str, unsigned int* greska);
oct_str_to_inter:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %esi  # str
	movl 12(%ebp), %edi # greska
	
	movl $0, (%edi)
	movl $0, %ebx
	movl $0, %eax

petlja_b:
	movb (%esi), %bl
	cmpb $0, %bl
	je petlja_e
	cmpb $'0', %bl
	jb greska_1
	cmpb $'7', %bl
	ja greska_1

	testl $0xe0000000, %eax
	jnz greska_2
	shll $3, %eax
	subb $'0', %bl
	addl %ebx, %eax
	jc greska_2

	incl %esi
	jmp petlja_b

petlja_e:
	cmpl 8(%ebp), %esi
	je greska_1
	jmp kraj	

greska_1:
	movl $1, (%edi)
	jmp kraj

greska_2:
	movl $2, (%edi)
	jmp kraj

kraj:	
	movl %ebp, %esp
	popl %ebp
	ret
