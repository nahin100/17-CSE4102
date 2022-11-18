.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
input_integer_format byte "%d",0
output_integer_msg_format byte "%d", 0Ah, 0
number sdword ?

.code
main proc
    ;scanf("%d", &number);
    INVOKE scanf, ADDR input_integer_format, ADDR number

    ;printf("%d\n", number);
    INVOKE printf, ADDR output_integer_msg_format, number


    ret
main endp
end