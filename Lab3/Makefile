
input = input.txt
output = output.txt

prog = prog4
flex_file = prog4.l
bison_file = prog4.y

main: prog1.l
	flex prog1.l
	gcc lex.yy.c
	a <$(input) >$(output)

main2: $(flex_file) $(bison_file)
	bison -d $(bison_file)
	flex $(flex_file)
	gcc $(prog).tab.c lex.yy.c
	a <$(input) >$(output)
