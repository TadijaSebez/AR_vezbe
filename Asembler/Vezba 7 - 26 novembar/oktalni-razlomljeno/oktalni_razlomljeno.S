# Konverzija razlomljenog broja u oktalni sistem
# Autor: Tadija Sebez SV 4/2020

.section .data
.section .text

.global inter_to_oct_str_float

# unsigned int inter_to_oct_str_float(unsigned int broj, char* str, unsigned int duzina);
inter_to_oct_str_float:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax
	movl $100000000, %ebx

	movl 12(%ebp), %esi
	movl 12(%ebp), %edi
	addl 16(%ebp), %edi
	decl %edi
	
	cmpl %edi, %esi
	jge greska	

	movb $'0', (%esi)
	incl %esi
	cmpl %edi, %esi
	jge greska

	movb $'.', (%esi)
	incl %esi
	cmpl %edi, %esi
	jge greska

petlja:
	shll $3, %eax
	movl $0, %edx
	divl %ebx
	xchgl %eax, %edx
	addl $'0', %edx
	movb %dl, (%esi)
	incl %esi
	cmpl %edi, %esi
	jge dobar
	cmpl $0, %eax
	je dobar
	jmp petlja

dobar:
	movb $0, (%esi)
	movl $0, %eax
	jmp kraj

greska:
	movl $1, %eax

kraj:
	movl %ebp, %esp
	popl %ebp
	ret
