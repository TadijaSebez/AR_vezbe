# autor: Tadija Sebez SV 4/2020

.section .data

.section .text

.global spoji_stringove

# void spoji_stringove(char* str, char* drugi, char* rez, int n);
spoji_stringove:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %esi
	movl 16(%ebp), %ecx
	movl 20(%ebp), %ebx

petlja:
	cmpb $0, (%esi)
	je kraj
	movb (%esi), %dl
	movb %dl, (%ecx)
	incl %ecx
	decl %ebx
	cmpl $0, %ebx
	ja dalje
	movl 20(%ebp), %ebx
	movl 12(%ebp), %edi

ubaci:
	cmpb $0, (%edi)
	je dalje
	movb (%edi), %dl
	movb %dl, (%ecx)
	incl %ecx	
	incl %edi
	jmp ubaci

dalje:
	incl %esi
	jmp petlja

kraj:
	movb $0, (%ecx)
	movl %ebp, %esp
	popl %ebp
	ret
