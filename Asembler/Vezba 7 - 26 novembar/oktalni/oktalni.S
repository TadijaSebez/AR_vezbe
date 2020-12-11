# Konverzija iz integera u oktalni string
# Autor: Tadija Sebez SV 4/2020

.section .data
.section .text

.global inter_to_oct_str

# unsigned int inter_to_oct_str(unsigned int broj, char* str, unsigned int duzina);
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp

	movl 12(%ebp), %esi
	movl $0, %edi
	movl 8(%ebp), %eax

# Promeniti u $16 za hex
	movl $8, %ebx

	movl 12(%ebp), %edi
	addl 16(%ebp), %edi
		
petlja:
	movl $0, %edx
	divl %ebx

# Dodati za hex
#	cmpl $9, %edx
#	jle broj

#slovo:
#	addl $'a'-10, %edx
#	jmp nastavi

#broj:
	addl $'0', %edx

nastavi:
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
