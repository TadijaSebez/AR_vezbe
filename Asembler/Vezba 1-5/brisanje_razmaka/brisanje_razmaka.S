# Brisanje razmaka sa pocetka i kraja stringa
# Tadija Sebez SV 4/2020

.section .data
string: .ascii "   abcde   \0"
.section .text
.global main
main:
	movl $0, %esi
	movl $0, %edi
	movl $0, %ebx # broj razmaka na pocetku
	movb $0, %dl
	movb $' ', %dh
trazi_kraj_stringa:
	cmpb string(,%esi,1), %dl
	je brisi_sa_kraja
	incl %esi
	jmp trazi_kraj_stringa
brisi_sa_kraja:
	decl %esi
	cmpb string(,%esi,1), %dh
	jne prebroj_razmake_sa_pocetka
	movb %dl, string(,%esi,1)
	jmp brisi_sa_kraja
prebroj_razmake_sa_pocetka:
	cmpb string(,%ebx,1), %dl
	je brisi_sa_pocetka
	incl %ebx
	jmp prebroj_razmake_sa_pocetka
brisi_sa_pocetka:
	movb string(,%ebx,1), %al
	movb %al, string(,%edi,1)
	incl %ebx
	incl %edi
	cmpb %al, %dl
	jne brisi_sa_pocetka
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
