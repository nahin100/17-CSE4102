;start
.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
output_integer_msg_format byte "%d", 0Ah, 0
output_string_msg_format byte "%s", 0Ah, 0
input_integer_format byte "%d",0

number sdword ?

.code

main proc
	push ebp
	mov ebp, esp
	sub ebp, 100
	mov ebx, ebp
	add ebx, 4

;scan_int_value
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-4]
	push [ebp-0]
	push ebp
	INVOKE scanf, ADDR input_integer_format, ADDR number
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	mov eax, number
	mov dword ptr [ebp-0], eax
	pop edx
	pop ecx
	pop ebx
	pop eax

;scan_int_value
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-4]
	push [ebp-0]
	push ebp
	INVOKE scanf, ADDR input_integer_format, ADDR number
	pop ebp
	pop [ebp-0]
	pop [ebp-4]
	mov eax, number
	mov dword ptr [ebp-4], eax
	pop edx
	pop ecx
	pop ebx
	pop eax

;ld_var
	mov eax, [ebp-0]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int
	mov eax, 1
	mov dword ptr [ebx], eax
	add ebx, 4


;add
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	add eax, edx
	mov dword ptr [ebx], eax
	add ebx, 4


;store
	mov dword ptr [ebp-0], eax

;ld_var
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int
	mov eax, 1
	mov dword ptr [ebx], eax
	add ebx, 4


;add
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	add eax, edx
	mov dword ptr [ebx], eax
	add ebx, 4


;store
	mov dword ptr [ebp-4], eax

;write_int_value
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-4]
	push [ebp-0]
	push [ebp+4]
	push [ebp+8]
	push ebp
	mov eax, [ebp-0]
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+8]
	pop [ebp+4]
	pop [ebp-0]
	pop [ebp-4]
	pop edx
	pop ecx
	pop ebx
	pop eax

;write_int_value
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-4]
	push [ebp-0]
	push [ebp+4]
	push [ebp+8]
	push ebp
	mov eax, [ebp-4]
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+8]
	pop [ebp+4]
	pop [ebp-0]
	pop [ebp-4]
	pop edx
	pop ecx
	pop ebx
	pop eax

;halt
	add ebp, 100
	mov esp, ebp
	pop ebp
	ret
main endp
end
