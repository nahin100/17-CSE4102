enum code_ops {START,HALT, LD_INT_VALUE, ST, LD_VAR, ADD, LD_INT, STS, WRITE_INT, SCAN_INT};
char *op_name[] = {"start", "halt", "ld_int_value", "store", "ld_var", "add", "ld_int", "store_from_stack", "write_int_value", "scan_int_value"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];

extern int address;
int code_offset = 0;
