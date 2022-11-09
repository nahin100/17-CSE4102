.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
input_integer_format byte "%d",0
output_msg byte "ENTER NUMBER:",0
output_positive_msg byte "NUMBER IS POSITIVE", 0Ah, 0
output_negative_msg byte "NUMBER IS NEGATIVE", 0Ah, 0
output_msg_format byte "%s",0
output_integer_msg_format byte "%d", 0Ah, 0
number sdword ?

.code
main proc
    push eax
    push ebx
    push ecx
    push edx
    push ebp
    INVOKE printf, ADDR output_msg_format, ADDR output_msg
    pop ebp
    pop edx
    pop ecx
    pop ebx
    pop eax

    push eax
    push ebx
    push ecx
    push edx
    push ebp
    INVOKE scanf, ADDR input_integer_format, ADDR number
    pop ebp
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov ecx, number
LOOP_:
    cmp ecx, 0
    jle EXIT_

    mov number, ecx
    push eax
    push ebx
    push ecx
    push edx
    push ebp
    INVOKE printf, ADDR output_integer_msg_format, number
    pop ebp
    pop edx
    pop ecx
    pop ebx
    pop eax

    sub ecx, 1
    jmp LOOP_

EXIT_:
    ret
main endp
end