#autor: Tadija Sebez SV 4/2020

.section .data

ispis1:     .ascii "Unseite logicki izraz: \0"
ispis2:     .ascii "Rezultat: \0"
greska1:    .ascii "Greska kod operanda.\n\0"
greska2:    .ascii "Greska kod operacije.\n\0"
newlin:     .ascii "\n\0"

debug:      .ascii "debug :D\n\0"

buffer: .fill 200,1,0
token: .fill 200,1,0
res: .byte 0
operacija: .byte 0
res_okt: .fill 5,1,0

.section .text

.global main

main:
	movl $4, %eax
	movl $1, %ebx
	movl $ispis1, %ecx
	movl $ispis2-ispis1, %edx
	int $0x80

	movl $3, %eax
	movl $0, %ebx
	movl $buffer, %ecx
	movl $200, %edx
	int $0x80

	movl $buffer, %esi
	pushl %esi
	pushl $token
	call get_token
	addl $8, %esp
	movl %eax, %esi

	pushl $token
	call parse_int
	addl $4, %esp
	movb %al, res
	cmpl $1, %edx
	je los_operand

petlja:
	cmpb $' ', (%esi)
	jne kraj

	incl %esi
	pushl %esi
	pushl $token
	call get_token
	addl $8, %esp
	movl %eax, %esi
	incl %esi

	movb token, %al
	movb %al, operacija

	pushl %esi
	pushl $token
	call get_token
	addl $8, %esp
	movl %eax, %esi

	pushl $token
	call parse_int
	addl $4, %esp
	cmpl $1, %edx
	je los_operand
	
	movb operacija, %ah
	cmpb $'&', %ah
	je and
	cmpb $'|', %ah
	je or
	cmpb $'^', %ah
	je xor
	jmp losa_operacija

and:
	andb %al, res
	jmp dalje

or:
	orb %al, res
	jmp dalje

xor:
	xorb %al, res
	jmp dalje

dalje:
	jmp petlja

losa_operacija:
	movl $4, %eax
	movl $1, %ebx
	movl $greska2, %ecx
	movl $newlin-greska2, %edx
	int $0x80
	jmp zavrsi_lose

los_operand:
	movl $4, %eax
	movl $1, %ebx
	movl $greska1, %ecx
	movl $greska2-greska1, %edx
	int $0x80
	jmp zavrsi_lose

kraj:
	movl $4, %eax
	movl $1, %ebx
	movl $ispis2, %ecx
	movl $greska1-ispis2, %edx
	int $0x80

	movl $res_okt, %esi	
	movb res, %al
	shrb $6, %al
	cmpb $0, %al
	je cif2
	addb $'0', %al
	movb %al, (%esi)
	incl %esi

cif2:
	movb res, %al
	shrb $3, %al
	cmpb $0, %al
	je cif3
	andb $7, %al
	addb $'0', %al
	movb %al, (%esi)
	incl %esi

cif3:
	movb res, %al
	andb $7, %al
	addb $'0', %al
	movb %al, (%esi)
	incl %esi
	movb $'\n', (%esi)
	incl %esi

	movl $4, %eax
	movl $1, %ebx
	movl $res_okt, %ecx
	subl $res_okt, %esi
	movl %esi, %edx
	int $0x80

zavrsi:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

zavrsi_lose:
	movl $1, %eax
	movl $1, %ebx
	int $0x80

# char* get_token(char* token, char* buffer)
get_token:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ecx
	movl 12(%ebp), %eax

gt_petlja_b:
	cmpb $' ', (%eax)
	je gt_petlja_e
	cmpb $0, (%eax)
	je gt_petlja_e
	cmpb $'\n', (%eax)
	je gt_petlja_e
	movb (%eax), %dl
	movb %dl, (%ecx)
	incl %ecx
	incl %eax
	jmp gt_petlja_b

gt_petlja_e:
	movb $0, (%ecx)
	movl %ebp, %esp
	popl %ebp
	ret

# int parse_int(char* token)
parse_int:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %edx
	movl 8(%ebp), %edi
	movl $0, %eax

	cmpb $'x', 1(%edi)
	je hex
	cmpb $'X', 1(%edi)
	je hex

pi_petlja_b:
	cmpb $0, (%edi)
	je pi_petlja_e
	movl %eax, %ebx
	addl %ebx, %eax
	shll $3, %ebx
	addl %ebx, %eax
	movl $0, %ebx
	movb (%edi), %bl
	cmpb $'0', %bl
	jb greska_operand
	cmpb $'9', %bl
	ja greska_operand
	subl $'0', %ebx
	addl %ebx, %eax
	incl %edi
	jmp pi_petlja_b

pi_petlja_e:
	jmp pi_kraj

hex:
	addl $2, %edi

hex_petlja_b:
	cmpb $0, (%edi)
	je hex_petlja_e
	movl %eax, %ebx
	shll $4, %ebx
	movl %ebx, %eax
	movl $0, %ebx
	movb (%edi), %bl
	cmpb $'0', %bl
	jb slovo
	cmpb $'9', %bl
	ja slovo
	subl $'0', %ebx
	addl %ebx, %eax
	incl %edi	
	jmp hex_petlja_b

slovo:	
	cmpb $'a', %bl
	jb nije_malo
	cmpb $'f', %bl
	ja nije_malo
	subb $'a', %bl
	addb $10, %bl
	addl %ebx, %eax
	incl %edi
	jmp hex_petlja_b

nije_malo:
	cmpb $'A', %bl
	jb greska_operand
	cmpb $'F', %bl
	ja greska_operand
	subb $'A', %bl
	addb $10, %bl
	addl %ebx, %eax
	incl %edi
	jmp hex_petlja_b

hex_petlja_e:
	jmp pi_kraj

pi_kraj:
	cmpl $256, %eax
	jae greska_operand
	movl %ebp, %esp
	popl %ebp
	ret

greska_operand:
	movl $1, %edx
	movl %ebp, %esp
	popl %ebp
	ret

