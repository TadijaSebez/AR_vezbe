# Konverzija iz oznacenog integera u oktalni string
# Autor: Tadija Sebez SV 4/2020

.section .data
.section .text

.global inter_to_oct_str

# unsigned int inter_to_oct_str(int broj, char* str, unsigned int duzina);
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp

	movl 12(%ebp), %esi
	movl 8(%ebp), %eax
	movl 12(%ebp), %edi
	addl 16(%ebp), %edi
	movl $0, %ecx

	cmpl $0, %eax
	jge pozitivan

	movl $1, %ecx

	movb $'-', (%esi)
	incl %esi
	cmpl %edi, %esi
	jge greska

	movl $0, %ebx
	subl %eax, %ebx
	movl %ebx, %eax

pozitivan:
	movl $8, %ebx

petlja:
	movl $0, %edx
	divl %ebx
	addl $'0', %edx
	movb %dl, (%esi)
	incl %esi
	cmpl %edi, %esi
	jge greska
	cmpl $0, %eax
	jne petlja

obrni:
	movl $0, (%esi)
	decl %esi
	movl 12(%ebp), %edi
	addl %ecx, %edi

radi:
	cmpl %esi, %edi
	jge dobar
	movb (%esi), %dl
	movb (%edi), %dh
	movb %dh, (%esi)
	movb %dl, (%edi)
	incl %edi
	decl %esi
	jmp radi

dobar:
	movl $0, %eax
	jmp kraj

greska:
	movl $1, %eax

kraj:
	movl %ebp, %esp
	popl %ebp
	ret
