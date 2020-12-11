# autor: Tadija Sebez SV 4/2020
# zadatak pronalazi indeks elementa niza koji je najblizi 0
# kako biste testirali program za neki od ulaza potrebno je da otkomentarisete taj ulaz

# b: najveca ispravna pozitivna temperatura je 0x7fffffffffffffff

.section .data

NELEM = 6
niz: .quad 12, -4, 5, 7, 14, 2
najblizi_indeks: .long 0
greska: .long 0

.section .text
.globl main
main:
	movl $0, %esi
	movl $0x7fffffff, %ecx
	movl $0xffffffff, %ebx

	movl $0, %eax
	cmpl $NELEM, %eax
	je lose

petlja:
	cmpl $NELEM, %esi
	jae kraj
	shll $1, %esi
	movl niz(,%esi,4), %eax
	incl %esi
	movl niz(,%esi,4), %edx
	testl $0x80000000, %edx
	jz nastavi
	movl %eax, %edi
	movl $0, %eax
	subl %edi, %eax
	movl %edx, %edi
	movl $0, %edx
	sbbl %edi, %edx

nastavi:
	cmpl %ecx, %edx
	jb manji
	ja veci
	cmpl %ebx, %eax
	jb manji
	jmp veci

manji:
	shrl $1, %esi
	movl %esi, najblizi_indeks
	movl %eax, %ebx
	movl %edx, %ecx
	jmp dalje

veci:
	shrl $1, %esi

dalje:
	incl %esi
	jmp petlja

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

lose:
	movl $1, %eax
	movl %eax, greska
	movl $1, %ebx
	int $0x80
