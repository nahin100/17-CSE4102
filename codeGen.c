#include "codeGen.h"

int gen_label()
{
    return code_offset;
}

void gen_code(enum code_ops op, int arg)
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;

    code_offset++;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);
    }
}

void print_assembly()
{
    int i = 0;
    int j = 0;

    int stack_variable_counter = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("\n;%s %d\n", op_name[code[i].op], code[i].arg);

        if(code[i].op == LD_INT || code[i].op == LD_VAR)
            stack_variable_counter++;
        
        if(code[i].op == ADD)
            stack_variable_counter--;

        switch(code[i].op)
        {
            case START:
                            printf(".686\n");
                            printf(".model flat, c\n");
                            printf("include C:\\masm32\\include\\msvcrt.inc\n");
                            printf("includelib C:\\masm32\\lib\\msvcrt.lib\n");                            
                            printf("\n");
                            printf(".stack 100h\n");
                            printf("printf PROTO arg1:Ptr Byte, printlist:VARARG\n");
                            printf("scanf PROTO arg2:Ptr Byte, inputlist:VARARG\n");
                            printf("\n");
                            printf(".data\n");
                            printf("output_integer_msg_format byte \"\% %d\", 0Ah, 0\n");
                            printf("output_string_msg_format byte \"\% %s\", 0Ah, 0\n");
                            printf("input_integer_format byte \"\% %d\",0\n");
                            printf("\n");
                            printf("number sdword ?\n");
                            printf("\n");
                            printf(".code\n");
                            printf("\n");
                            printf("main proc\n");
                            printf("\tpush ebp\n");
                            printf("\tmov ebp, esp\n");
                            printf("\tsub ebp, 100\n");
                            printf("\tmov ebx, ebp\n");
                            printf("\tadd ebx, 4\n");
                            break;

            case HALT:
                            printf("\tadd ebp, 100\n");
                            printf("\tmov esp, ebp\n");
                            printf("\tpop ebp\n");
                            printf("\tret\n");
                            printf("main endp\n");
                            printf("end\n");
                            break;

            case STORE:
                            printf("\tmov eax, [ebx-4]\n");
                            printf("\tmov dword ptr [ebp-%d], eax\n", 4*code[i].arg);
                            break;

            case SCAN_INT_VALUE:                                
                            printf("\tpush eax\n");
                            printf("\tpush ebx\n");
                            printf("\tpush ecx\n");
                            printf("\tpush edx\n");
                            for(j=address-1; j>=0; j--)
                                printf("\tpush [ebp-%d]\n", 4*j);
                            for(j=1; j<=stack_variable_counter; j++)
                                printf("\tpush [ebp+%d]\n", 4*j);
                            printf("\tpush ebp\n");
                            
                            printf("\tINVOKE scanf, ADDR input_integer_format, ADDR number\n");

                            printf("\tpop ebp\n");
                            for(j=stack_variable_counter; j>=1; j--)
                                printf("\tpop [ebp+%d]\n", 4*j);
                            for(j=0; j<=address-1; j++)
                                printf("\tpop [ebp-%d]\n", 4*j);

                            printf("\tmov eax, number\n");
                            printf("\tmov dword ptr [ebp-%d], eax\n", 4*code[i].arg);

                            printf("\tpop edx\n");
                            printf("\tpop ecx\n");
                            printf("\tpop ebx\n");
                            printf("\tpop eax\n");
                            break;


            case PRINT_INT_VALUE:              
                            printf("\tpush eax\n");
                            printf("\tpush ebx\n");
                            printf("\tpush ecx\n");
                            printf("\tpush edx\n");
                            for(j=address-1; j>=0; j--)
                                printf("\tpush [ebp-%d]\n", 4*j);
                            for(j=1; j<=stack_variable_counter; j++)
                                printf("\tpush [ebp+%d]\n", 4*j);
                            printf("\tpush ebp\n");

                            printf("\tmov eax, [ebp-%d]\n", 4*code[i].arg);
                            printf("\tINVOKE printf, ADDR output_integer_msg_format, eax\n");

                            printf("\tpop ebp\n");
                            for(j=stack_variable_counter; j>=1; j--)
                                printf("\tpop [ebp+%d]\n", 4*j);
                            for(j=0; j<=address-1; j++)
                                printf("\tpop [ebp-%d]\n", 4*j);
                            printf("\tpop edx\n");
                            printf("\tpop ecx\n");
                            printf("\tpop ebx\n");
                            printf("\tpop eax\n");
                            break;

            case LD_VAR: 
                            printf("\tmov eax, [ebp-%d]\n", 4*code[i].arg);
                            printf("\tmov dword ptr [ebx], eax\n");
                            printf("\tadd ebx, 4\n");
                            printf("\n");
                            break;

            case LD_INT:
                            printf("\tmov eax, %d\n", code[i].arg);
                            printf("\tmov dword ptr [ebx], eax\n");
                            printf("\tadd ebx, 4\n");
                            printf("\n");
                            break;

            case ADD:
                            printf("\tsub ebx, 4\n");
                            printf("\tmov eax, [ebx]\n");
                            printf("\tsub ebx, 4\n");
                            printf("\tmov edx, [ebx]\n");
                            printf("\tadd eax, edx\n");
                            printf("\tmov dword ptr [ebx], eax\n");
                            printf("\tadd ebx, 4\n");
                            printf("\n");
                            break;
            case GT_OP:
                            printf("\tsub ebx, 4\n");
                            printf("\tmov eax, [ebx]\n");
                            printf("\tsub ebx, 4\n");
                            printf("\tmov edx, [ebx]\n");
                            printf("\tcmp edx, eax\n");

                            {
                                char relop_start_label[50]="LS";
                                char relop_end_label[50]="LE";
                                char number[10];
                                itoa(code[i].arg, number, 10);
                                strcat(relop_end_label, number);
                                strcat(relop_start_label, number);

                                printf("\tjg %s\n", relop_start_label);
                                printf("\tmov dword ptr [ebx], 0\n");
                                printf("\tjmp %s\n", relop_end_label);
                                printf("\t%s: mov dword ptr [ebx], 1\n", relop_start_label);
                                printf("\t%s: add ebx, 4\n\n", relop_end_label);
                            }
                            printf("\n");
                            break;
            case LT_OP:
                            printf("\tsub ebx, 4\n");
                            printf("\tmov eax, [ebx]\n");
                            printf("\tsub ebx, 4\n");
                            printf("\tmov edx, [ebx]\n");
                            printf("\tcmp edx, eax\n");

                            {
                                char relop_start_label[50]="LS";
                                char relop_end_label[50]="LE";
                                char number[10];
                                itoa(code[i].arg, number, 10);
                                strcat(relop_end_label, number);
                                strcat(relop_start_label, number);

                                printf("\tjl %s\n", relop_start_label);
                                printf("\tmov dword ptr [ebx], 0\n");
                                printf("\tjmp %s\n", relop_end_label);
                                printf("\t%s: mov dword ptr [ebx], 1\n", relop_start_label);
                                printf("\t%s: add ebx, 4\n\n", relop_end_label);
                            }
                            printf("\n");
                            break;
            case IF_START:
                            printf("\tmov eax, [ebx-4]\n");
                            printf("\tcmp eax, 0\n");
                            {
                                char else_start_label[]="ELSE_START_LABEL_";
                                char number[10];
                                strcat(else_start_label,itoa(code[i].arg, number, 10));
                                printf("\tjle %s\n", else_start_label);
                            }
                            printf("\n");
                            break;
            case ELSE_START:
                            {
                                char else_start_label[50]="ELSE_START_LABEL_";
                                char else_end_label[50]="ELSE_END_LABEL_";
                                char number[10];
                                itoa(code[i].arg, number, 10);
                                strcat(else_end_label, number);
                                printf("\tjmp %s\n", else_end_label);
                                strcat(else_start_label, number);
                                printf("%s:\n", else_start_label);
                            }
                            printf("\n");
                            break;
            case ELSE_END:
                            {
                                char else_end_label[50]="ELSE_END_LABEL_";
                                char number[10];
                                itoa(code[i].arg, number, 10);
                                strcat(else_end_label, number);
                                printf("%s:\n", else_end_label);
                            }
                            printf("\n");
                            break;
            case WHILE_LABEL:
                            {
                                char while_start_label[]="WHILE_START_LABEL_";
                                char number[10];
                                strcat(while_start_label,itoa(code[i].arg, number, 10));
                                printf("%s:\n", while_start_label);
                            }
                            printf("\n");
                            break;
            case WHILE_START:
                            printf("\tmov eax, [ebx-4]\n");
                            printf("\tcmp eax, 0\n");
                            {
                                char while_end_label[]="WHILE_END_LABEL_";
                                char number[10];
                                strcat(while_end_label,itoa(code[i].arg, number, 10));
                                printf("\tjle %s\n", while_end_label);
                            }
                            printf("\n");
                            break;
            case WHILE_END:
                            {
                                char while_start_label[50]="WHILE_START_LABEL_";
                                char while_end_label[50]="WHILE_END_LABEL_";
                                char number[10];
                                itoa(code[i].arg, number, 10);
                                strcat(while_start_label, number);
                                printf("\tjmp %s\n", while_start_label);
                                strcat(while_end_label, number);
                                printf("%s:\n", while_end_label);
                            }
                            printf("\n");
                            break;
            default:
                            break;
        }

    }
}