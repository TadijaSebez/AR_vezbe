# Template kod za ulaz i izlaz

.section .data

s: .fill 20,1,0
n: .long 20
m: .long 0
a: .long 0
b: .long 0

.section .text

.global main

main:
	pushl n
	pushl $s
	pushl $a
	call rsi
	addl $12, %esp
	
	cmpl $0, %eax
	jne main_greska

	pushl n
	pushl $s
	pushl $b
	call rsi
	addl $12, %esp
	
	cmpl $0, %eax
	jne main_greska

	movl a, %eax
	addl b, %eax
	jo main_greska
	
	pushl $m
	pushl n
	pushl $s
	pushl %eax
	call psi
	addl $16, %esp

	cmpl $0, %eax
	jne main_greska

main_dobar:
	jmp main_kraj

main_greska:
	movl $s, %esi
	movb $':', (%esi)
	movb $'(', 1(%esi)
	movb $'\n', 2(%esi)
	
	pushl $3
	pushl $s
	call ps
	addl $8, %esp
	
	movl $1, %eax
	movl $1, %ebx
	int $0x80

main_kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

# int rs(char s[], int n)
# Ucitava char array sa standardnog ulaza
# Vraca broj ucitanih karaktera ili negativan broj ako je doslo do greske
rs:
	pushl %ebp
	movl %esp, %ebp
	
	movl $3, %eax
	movl $0, %ebx
	movl 8(%ebp), %ecx
	movl 12(%ebp), %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

# int ps(char s[], int n)
# Ispisuje char array na standardni izlaz
# Vraca broj ispisanih karaktera ili negativan broj ako je doslo do greske
ps:
	pushl %ebp
	movl %esp, %ebp

	movl $4, %eax
	movl $1, %ebx
	movl 8(%ebp), %ecx
	movl 12(%ebp), %edx
	int $0x80

	movl %ebp, %esp
	popl %ebp
	ret

# int str_to_ui(char s[], unsigned int *a)
# Konvertuje char array u neoznaceni broj
# Vraca 1 ako je doslo do greske
str_to_ui:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %eax
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi

stui_loop_b:
	cmpb $'0', (%esi)
	jb stui_loop_e
	cmpb $'9', (%esi)
	ja stui_loop_e
	
	# Mnozim sa 10
	movl %eax, %edx
	movl $0, %eax
	shll $1, %edx
	jc stui_greska
	addl %edx, %eax
	jc stui_greska
	shll $2, %edx
	jc stui_greska
	addl %edx, %eax
	jc stui_greska

	# Dodajem cifru
	movl $0, %edx
	movb (%esi), %dl
	subb $'0', %dl
	addl %edx, %eax
	jc stui_greska

	incl %esi
	jmp stui_loop_b 

stui_loop_e:
	movl %eax, (%edi)
	jmp stui_dobar

stui_dobar:
	movl $0, %eax
	jmp stui_kraj

stui_greska:
	movl $1, %eax

stui_kraj:
	movl %ebp, %esp
	popl %ebp
	ret

# int str_to_si(char s[], int *a)
# Konvertuje char array u oznaceni broj
# Vraca 1 ako je doslo do greske
str_to_si:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %eax
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi
	
	movl $0, %ebx
	cmpb $'-', (%esi)
	jne stsi_loop_b
	movl $1, %ebx
	incl %esi

stsi_loop_b:
	cmpb $'0', (%esi)
	jb stsi_loop_e
	cmpb $'9', (%esi)
	ja stsi_loop_e
	
	# Mnozim sa 10
	movl %eax, %edx
	movl $0, %eax
	addl %edx, %edx
	jo stsi_greska
	addl %edx, %eax
	jo stsi_greska
	addl %edx, %edx
	jo stsi_greska
	addl %edx, %edx
	jo stsi_greska
	addl %edx, %eax
	jo stsi_greska

	# Dodajem cifru
	movl $0, %edx
	movb (%esi), %dl
	subb $'0', %dl
	addl %edx, %eax
	jo stsi_greska

	incl %esi
	jmp stsi_loop_b 

stsi_loop_e:
	cmpl $1, %ebx
	jne stsi_pozitivan
	negl %eax

stsi_pozitivan:
	movl %eax, (%edi)
	jmp stsi_dobar

stsi_dobar:
	movl $0, %eax
	jmp stsi_kraj

stsi_greska:
	movl $1, %eax

stsi_kraj:
	movl %ebp, %esp
	popl %ebp
	ret

# int ui_to_str(unsigned int a, char s[], int n, int *m)
# Konvertuje neoznaceni broj u char array
# Vraca 1 ako je doslo do greske
ui_to_str:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax
	movl $10, %ebx
	movl 12(%ebp), %esi
	movl %esi, %edi
	addl 16(%ebp), %edi

uits_loop_b:
	cmpl $0, %eax
	je uits_loop_e
	
	# Delim sa 10
	movl $0, %edx
	divl %ebx

	cmpl %edi, %esi
	jae uits_greska

	movb %dl, (%esi)
	addb $'0', (%esi)
	incl %esi

	jmp uits_loop_b	

uits_loop_e:
	cmpl %edi, %esi
	jae uits_greska

	movb $'\n', (%esi)
	decl %esi
	movl 12(%ebp), %edi

	movl 20(%ebp), %ecx
	movl %esi, (%ecx)
	subl %edi, (%ecx)
	addl $2, (%ecx)

uits_obrni_b:
	cmpl %esi, %edi
	jae uits_obrni_e
	movb (%esi), %dl
	movb (%edi), %dh
	movb %dh, (%esi)
	movb %dl, (%edi)
	decl %esi
	incl %edi
	jmp uits_obrni_b

uits_obrni_e:
	jmp uits_dobar

uits_dobar:
	movl $0, %eax
	jmp uits_kraj

uits_greska:
	movl $1, %eax

uits_kraj:
	movl %ebp, %esp
	popl %ebp
	ret

# int si_to_str(int a, char s[], int n, int *m)
# Konvertuje oznaceni broj u char array
# Vraca 1 ako je doslo do greske
si_to_str:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax
	movl $10, %ebx
	movl 12(%ebp), %esi
	movl %esi, %edi
	addl 16(%ebp), %edi
	movl 20(%ebp), %ecx
	movl $0, (%ecx)

	testl $0x80000000, %eax
	jz sits_loop_b
	movb $'-', (%esi)
	incl %esi
	incl 12(%ebp)
	negl %eax
	incl (%ecx)

sits_loop_b:
	cmpl $0, %eax
	je sits_loop_e
	
	# Delim sa 10
	movl $0, %edx
	divl %ebx

	cmpl %edi, %esi
	jae sits_greska

	movb %dl, (%esi)
	addb $'0', (%esi)
	incl %esi

	jmp sits_loop_b	

sits_loop_e:
	cmpl %edi, %esi
	jae sits_greska

	movb $'\n', (%esi)
	decl %esi
	movl 12(%ebp), %edi

	addl %esi, (%ecx)
	subl %edi, (%ecx)
	addl $2, (%ecx)

sits_obrni_b:
	cmpl %esi, %edi
	jae sits_obrni_e
	movb (%esi), %dl
	movb (%edi), %dh
	movb %dh, (%esi)
	movb %dl, (%edi)
	decl %esi
	incl %edi
	jmp sits_obrni_b

sits_obrni_e:
	jmp sits_dobar

sits_dobar:
	movl $0, %eax
	jmp sits_kraj

sits_greska:
	movl $1, %eax

sits_kraj:
	movl %ebp, %esp
	popl %ebp
	ret

# int pui(unsigned int a, char s[], int n, int *m)
# Ispisije neoznaceni broj na standardni izlaz
# Vraca 1 ako je doslo do greske
pui:
	pushl %ebp
	movl %esp, %ebp
	
	pushl 20(%ebp)
	pushl 16(%ebp)
	pushl 12(%ebp)
	pushl 8(%ebp)
	call ui_to_str
	addl $16, %esp
	
	cmpl $1, %eax
	je pui_greska

	movl 20(%ebp), %eax
	pushl (%eax)
	pushl 12(%ebp)
	call ps
	addl $8, %esp

	cmpl $0, %eax
	jb pui_greska

pui_dobar:
	movl $0, %eax
	jmp pui_kraj

pui_greska:
	movl $1, %eax

pui_kraj:
	movl %esp, %ebp
	popl %ebp
	ret

# int psi(int a, char s[], int n, int *m)
# Ispisije oznaceni broj na standardni izlaz
# Vraca 1 ako je doslo do greske
psi:
	pushl %ebp
	movl %esp, %ebp
	
	pushl 20(%ebp)
	pushl 16(%ebp)
	pushl 12(%ebp)
	pushl 8(%ebp)
	call si_to_str
	addl $16, %esp
	
	cmpl $1, %eax
	je psi_greska

	movl 20(%ebp), %eax
	pushl (%eax)
	pushl 12(%ebp)
	call ps
	addl $8, %esp

	cmpl $0, %eax
	jb psi_greska

psi_dobar:
	movl $0, %eax
	jmp psi_kraj

psi_greska:
	movl $1, %eax

psi_kraj:
	movl %esp, %ebp
	popl %ebp
	ret

# in rui(unsigned int *a, char s[], int n)
# Ucitava neoznaceni broj sa standardnog ulaza
# Vraca 1 ako je doslo do greske
rui:
	pushl %ebp
	movl %esp, %ebp

	pushl 16(%ebp)
	pushl 12(%ebp)
	call rs
	addl $8, %esp

	cmpl $0, %eax
	jl rui_greska

	pushl 8(%ebp)
	pushl 12(%ebp)
	call str_to_ui
	addl $8, %esp

	cmpl $0, %eax
	jne rui_greska

rui_dobar:
	movl $0, %eax
	jmp rui_kraj

rui_greska:
	movl $1, %eax

rui_kraj:
	movl %ebp, %esp
	popl %ebp
	ret

# in rsi(int *a, char s[], int n)
# Ucitava oznaceni broj sa standardnog ulaza
# Vraca 1 ako je doslo do greske
rsi:
	pushl %ebp
	movl %esp, %ebp

	pushl 16(%ebp)
	pushl 12(%ebp)
	call rs
	addl $8, %esp

	cmpl $0, %eax
	jl rsi_greska

	pushl 8(%ebp)
	pushl 12(%ebp)
	call str_to_si
	addl $8, %esp

	cmpl $0, %eax
	jne rsi_greska

rsi_dobar:
	movl $0, %eax
	jmp rsi_kraj

rsi_greska:
	movl $1, %eax

rsi_kraj:
	movl %ebp, %esp
	popl %ebp
	ret
