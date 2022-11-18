enum code_ops 
{
    START, 
    HALT, 
    LD_INT, 
    LD_VAR, 
    STORE, 
    SCAN_INT_VALUE, 
    PRINT_INT_VALUE, 
    ADD
};

char *op_name[] = {"start", "halt", "ld_int", "ld_var", "store", "scan_int_value", "print_int_value", "add"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];
extern int address;
int code_offset = 0;