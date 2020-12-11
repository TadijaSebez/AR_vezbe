# Konverzija oktalnog stringa u float
# Autor: Tadija Sebez SV 4/2020

.section .data

.section .text

.global oct_str_float_to_inter

# unsigned int oct_str_float_to_inter(char* str, unsigned int* greska);
oct_str_float_to_inter:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %esi  # str
	movl 12(%ebp), %edi # greska
	
	movl $0, (%edi)
	movl $0, %ebx
	movl $0, %eax
	movl $0, %edx # brojac za '.'
	
	movl $100000000, %ecx # skaliranje

nadji_kraj:
	movb (%esi), %bl
	cmpb $0, %bl
	je dalje
	cmpb $'.', %bl
	je nastavi
	cmpb $'0', %bl
	jb greska
	cmpb $'7', %bl
	ja greska
	incl %esi
	jmp nadji_kraj

nastavi:
	incl %edx
	incl %esi
	jmp nadji_kraj

dalje:
	cmpl $1, %edx
	jne greska
	cmpl 8(%ebp), %esi
	je greska
	decl %esi

petlja_b:
	movl $0, %ebx
	movb (%esi), %bl
	cmpb $'.', %bl
	je petlja_e
	
	subb $'0', %bl
	xchgl %eax, %ebx	
	mull %ecx
	addl %ebx, %eax

	movl $0, %edx
	movl $8, %ecx
	divl %ecx
	movl $100000000, %ecx

	cmpl 8(%ebp), %esi
	je greska

	decl %esi
	jmp petlja_b

petlja_e:
	jmp kraj	

greska:
	movl $1, (%edi)
	jmp kraj

kraj:	
	movl %ebp, %esp
	popl %ebp
	ret
