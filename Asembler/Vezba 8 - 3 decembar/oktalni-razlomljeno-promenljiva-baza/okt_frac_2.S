# Konverzija oktalnog stringa u float u odabranoj bazi
# Autor: Tadija Sebez SV 4/2020

.section .data

.section .text

.global oct_str_float_to_inter

# unsigned int oct_str_float_to_inter(char* str, unsigned int baza, unsigned int* greska);
oct_str_float_to_inter:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %esi  # str
	movl 12(%ebp), %ecx	
	movl 16(%ebp), %edi # greska

	cmpl $2, %ecx
	jb greska
	cmpl $36, %ecx
	ja greska
	
	movl $0, (%edi)
	movl $0, %ebx
	movl $0, %eax
	movl $0, %edx # brojac za '.'

nadji_kraj:
	movb (%esi), %bl
	cmpb $0, %bl
	je dalje
	cmpb $'.', %bl
	je nastavi
	
	cmpb $'0', %bl
	jb nije_broj
	cmpb $'7', %bl
	ja nije_broj
	
	subb $'0', %bl
	movb %bl, (%esi)
	jmp sledeca

nije_broj:
	cmpb $'a', %bl
	jb greska
	cmpb $'z', %bl
	ja greska
	
	subb $'a', %bl
	addb $10, %bl
	movb %bl, (%esi)

sledeca:
	cmpb %cl, %bl
	jae greska	
	
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
	movl $100000000, %ecx
	mull %ecx
	addl %ebx, %eax

	movl $0, %edx
	movl 12(%ebp), %ecx
	divl %ecx

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
