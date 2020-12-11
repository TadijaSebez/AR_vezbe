# NZD
# Tadija Sebez, SV 4/2020
.section .data
.section .text
.global main
main:
 movl $5, %eax
 movl $7, %ebx
ff1:
 cmpl %ebx, %eax
 je end
 ja if1
 subl %eax, %ebx
 jmp ff1
if1:
 subl %ebx, %eax
 jmp ff1
end:
 movl $1, %eax
 movl $0, %ebx
 int $0x80

