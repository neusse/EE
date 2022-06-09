/*	File code8080.c: 2.2 (84/08/31,10:05:09) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*	Define ASNM and LDNM to the names of the assembler and linker
	respectively */

/*
 *	Some predefinitions:
 *
 *	INTSIZE is the size of an integer in the target machine
 *	BYTEOFF is the offset of an byte within an integer on the
 *		target machine. (ie: 8080,pdp11 = 0, 6809 = 1,
 *		360 = 3)
 *	This compiler assumes that an integer is the SAME length as
 *	a pointer - in fact, the compiler uses INTSIZE for both.
 */
#define	INTSIZE	2
#define	BYTEOFF	0

FILE *Trace;
int TRACE;
/*
 *	print all assembler info before any code is generated
 *
 */
inittrace()
{
   Trace=fopen("trace.out","w");
}

endtrace()
{
    fclose(Trace);
}

header ()
{

        if (TRACE) fprintf(output,";header()\n");

	outstr (";	Small C 8080;\n;\tCoder (2.4,84/11/27)\n;");
	FEvers();
	nl ();
	ol ("extrn	?gchar,?gint,?pchar,?pint,?bool");
	ol ("extrn	?sxt");
	ol ("extrn	?or,?and,?xor");
	ol ("extrn	?eq,?ne,?gt,?le,?ge,?lt,?uge,?ult,?ugt,?ule");
	ol ("extrn	?asr,?asl");
	ol ("extrn	?sub,?neg,?com,?lneg,?mul,?div");
	ol ("extrn	?case");
}

nl ()
{
	outbyte (EOL);
}
initmac()
{
        if (TRACE) fprintf(output,";initmac()\n");
	defmac("cpm\t1");
	defmac("I8080\t1");
	defmac("RMAC\t1");
	defmac("smallc\t1");
}

galign(t)
int	t;
{
        if (TRACE) fprintf(output,";galign(%d)\n",t);
	return(t);
}

/*
 *	return size of an integer
 */
intsize() {
	return(INTSIZE);
}

/*
 *	return offset of ls byte within word
 *	(ie: 8080 & pdp11 is 0, 6809 is 1, 360 is 3)
 */
byteoff() {
	return(BYTEOFF);
}

/*
 *	Output internal generated label prefix
 */
olprfix() {
	outbyte('?');
}

/*
 *	Output a label definition terminator
 */
col ()
{
	outbyte (58);
}

/*
 *	begin a comment line for the assembler
 *
 */
comment ()
{
	outbyte (';');
}

/*
 *	Emit user label prefix
 */
prefix ()
{
        if (TRACE) fprintf(output,";prefix()\n");
}


/*
 *	print any assembler stuff needed after all code
 *
 */
trailer ()
{
        if (TRACE) fprintf(output,";trailer()\n");
	ol ("end");
}

/*
 *	function prologue
 */
prologue ()
{
        if (TRACE) fprintf(output,";prologue()\n");
}

/*
 *	text (code) segment
 */
gtext ()
{
        if (TRACE) fprintf(output,";gtext()\n");
	ol ("cseg");
}

/*
 *	data segment
 */
gdata ()
{
        if (TRACE) fprintf(output,";gdata()\n");
	ol ("dseg");
}

/*
 *  Output the variable symbol at scptr as an extrn or a public
 */
ppubext(scptr)
char *scptr;
{
        if (TRACE) fprintf(output,";ppubext(%s)\n",scptr);
	if (cptr[STORAGE] == STATIC) return;
	ot (scptr[STORAGE] == EXTERN ? "extrn\t" : "public\t");
	prefix ();
	outstr (scptr);
	nl();
}

/*
 * Output the function symbol at scptr as an extrn or a public
 */
fpubext(scptr)
char *scptr;
{
        if (TRACE) fprintf(output,";ppubext(%s)\n",scptr);
	if (scptr[STORAGE] == STATIC) return;
	ot (scptr[OFFSET] == FUNCTION ? "public\t" : "extrn\t");
	prefix ();
	outstr (scptr);
	nl ();
}

/*
 *  Output a decimal number to the assembler file
 */
onum(num)
int num;
{
        if (TRACE) fprintf(output,";onum(%d)\n",num);
	outdec(num);	/* pdp11 needs a "." here */
}


/*
 *	fetch a static memory cell into the primary register
 */
getmem (sym)
char	*sym;
{
        if (TRACE) fprintf(output,";getmem(%s)\n",sym);
	if ((sym[IDENT] != POINTER) & (sym[TYPE] == CCHAR)) {
		ot ("lda\t");
		outstr (sym + NAME);
		nl ();
		gcall ("?sxt");
	} else {
		ot ("lhld\t");
		outstr (sym + NAME);
		nl ();
	}
}

/*
 *	fetch the address of the specified symbol into the primary register
 *
 */
getloc (sym)
char	*sym;
{
        if (TRACE) fprintf(output,";getloc(%s)\n",sym);
	immed ();
	if (sym[STORAGE] == LSTATIC) {
		printlabel(glint(sym));
		nl();
	} else {
		outdec (glint(sym) - stkp);
		nl ();
		ol ("dad\tsp");
	}
}

/*
 *	store the primary register into the specified static memory cell
 *
 */
putmem (sym)
char	*sym;
{
        if (TRACE) fprintf(output,";putmem(%s)\n",sym);
	if ((sym[IDENT] != POINTER) & (sym[TYPE] == CCHAR)) {
		ol ("mov\ta,l");
		ot ("sta\t");
	} else
		ot ("shld\t");
	outstr (sym + NAME);
	nl ();
}

/*
 *	store the specified object type in the primary register
 *	at the address on the top of the stack
 *
 */
putstk (typeobj)
char	typeobj;
{
        if (TRACE) fprintf(output,";putstk(%d)\n",typeobj);
	gpop ();
	if (typeobj == CCHAR)
		gcall ("?pchar");
	else
		gcall ("?pint");
}

/*
 *	fetch the specified object type indirect through the primary
 *	register into the primary register
 *
 */
indirect (typeobj)
char	typeobj;
{
        if (TRACE) fprintf(output,";indirect(%d)\n",typeobj);
	if (typeobj == CCHAR)
		gcall ("?gchar");
	else
		gcall ("?gint");
}

/*
 *	swap the primary and secondary registers
 *
 */
swap ()
{
        if (TRACE) fprintf(output,";swap\n");
	ol ("xchg");
}

/*
 *	print partial instruction to get an immediate value into
 *	the primary register
 *
 */
immed ()
{
        if (TRACE) fprintf(output,";immed()\n");
	ot ("lxi\th,");
}

/*
 *	push the primary register onto the stack
 *
 */
gpush ()
{
        if (TRACE) fprintf(output,";gpush\n");
	ol ("push\th");
	stkp = stkp - INTSIZE;
}

/*
 *	pop the top of the stack into the secondary register
 *
 */
gpop ()
{
        if (TRACE) fprintf(output,";gpop\n");
	ol ("pop\td");
	stkp = stkp + INTSIZE;
}

/*
 *	swap the primary register and the top of the stack
 *
 */
swapstk ()
{
        if (TRACE) fprintf(output,";swapstk\n");
	ol ("xthl");
}

/*
 *	call the specified subroutine name
 *
 */
gcall (sname)
char	*sname;
{
        if (TRACE) fprintf(output,";gcall\n",sname);
	ot ("call\t");
	outstr (sname);
	nl ();
}

/*
 *	return from subroutine
 *
 */
gret ()
{
        if (TRACE) fprintf(output,";gret\n");
	ol ("ret");
}

/*
 *	perform subroutine call to value on top of stack
 *
 */
callstk ()
{
        if (TRACE) fprintf(output,";callstk\n");
	immed ();
	outstr ("$+5");
	nl ();
	swapstk ();
	ol ("pchl");
	stkp = stkp + INTSIZE;
}

/*
 *	jump to specified internal label number
 *
 */
jump (label)
int	label;
{
        if (TRACE) fprintf(output,";jump(%d)\n",label);
	ot ("jmp\t");
	printlabel (label);
	nl ();
}

/*
 *	test the primary register and jump if false to label
 *
 */
testjump (label, ft)
int	label,
	ft;
{
        if (TRACE) fprintf(output,";testjump(%d,%d)\n",label,ft);
	ol ("mov\ta,h");
	ol ("ora\tl");
	if (ft)
		ot ("jnz\t");
	else
		ot ("jz\t");
	printlabel (label);
	nl ();
}

/*
 *	print pseudo-op  to define a byte
 *
 */
defbyte ()
{
        if (TRACE) fprintf(output,";defbyte()\n");
	ot ("db\t");
}

/*
 *	print pseudo-op to define storage
 *
 */
defstorage ()
{
        if (TRACE) fprintf(output,";defstorage()\n");
	ot ("ds\t");
}

/*
 *	print pseudo-op to define a word
 *
 */
defword ()
{
        if (TRACE) fprintf(output,";defword()\n");
	ot ("dw\t");
}

/*
 *	modify the stack pointer to the new value indicated
 *
 */
modstk (newstkp)
int	newstkp;
{
	int	k;

        if (TRACE) fprintf(output,";modstk(%d)\n",newstkp);

	k = galign(newstkp - stkp);
	if (k == 0)
		return (newstkp);
	if (k > 0) {
		if (k < 7) {
			if (k & 1) {
				ol ("inx\tsp");
				k--;
			}
			while (k) {
				ol ("pop\tb");
				k = k - INTSIZE;
			}
			return (newstkp);
		}
	} else {
		if (k > -7) {
			if (k & 1) {
				ol ("dcx\tsp");
				k++;
			}
			while (k) {
				ol ("push\tb");
				k = k + INTSIZE;
			}
			return (newstkp);
		}
	}
	swap ();
	immed ();
	outdec (k);
	nl ();
	ol ("dad\tsp");
	ol ("sphl");
	swap ();
	return (newstkp);
}

/*
 *	multiply the primary register by INTSIZE
 */
gaslint ()
{
        if (TRACE) fprintf(output,";gaslint()\n");
	ol ("dad\th");
}

/*
 *	divide the primary register by INTSIZE
 */
gasrint()
{
        if (TRACE) fprintf(output,";gasrint()\n");
	gpush();	/* push primary in prep for gasr */
	immed ();
	onum (1);
	nl ();
	gasr ();  /* divide by two */
}

/*
 *	Case jump instruction
 */
gjcase() {
        if (TRACE) fprintf(output,";gjcase()\n");
	ot ("jmp\t?case");
	nl ();
}

/*
 *	add the primary and secondary registers
 *	if lval2 is int pointer and lval is not, scale lval
 */
gadd (lval,lval2) int *lval,*lval2;
{
        if (TRACE) fprintf(output,";gadd(%d, %d)\n",*lval,*lval2);
	gpop ();
	if (dbltest (lval2, lval)) {
		swap ();
		gaslint ();
		swap ();
	}
	ol ("dad\td");
}

/*
 *	subtract the primary register from the secondary
 *
 */
gsub ()
{
        if (TRACE) fprintf(output,";gsub()\n");
	gpop ();
	gcall ("?sub");
}

/*
 *	multiply the primary and secondary registers
 *	(result in primary)
 *
 */
gmult ()
{
        if (TRACE) fprintf(output,";gmult()\n");
	gpop();
	gcall ("?mul");
}

/*
 *	divide the secondary register by the primary
 *	(quotient in primary, remainder in secondary)
 *
 */
gdiv ()
{
        if (TRACE) fprintf(output,";gdiv()\n");
	gpop();
	gcall ("?div");
}

/*
 *	compute the remainder (mod) of the secondary register
 *	divided by the primary register
 *	(remainder in primary, quotient in secondary)
 *
 */
gmod ()
{
        if (TRACE) fprintf(output,";gmod()\n");
	gdiv ();
	swap ();
}

/*
 *	inclusive 'or' the primary and secondary registers
 *
 */
gor ()
{
        if (TRACE) fprintf(output,";gor()\n");
	gpop();
	gcall ("?or");
}

/*
 *	exclusive 'or' the primary and secondary registers
 *
 */
gxor ()
{
        if (TRACE) fprintf(output,";gxor()\n");
	gpop();
	gcall ("?xor");
}

/*
 *	'and' the primary and secondary registers
 *
 */
gand ()
{
        if (TRACE) fprintf(output,";gand()\n");
	gpop();
	gcall ("?and");
}

/*
 *	arithmetic shift right the secondary register the number of
 *	times in the primary register
 *	(results in primary register)
 *
 */
gasr ()
{
        if (TRACE) fprintf(output,";gasr()\n");
	gpop();
	gcall ("?asr");
}

/*
 *	arithmetic shift left the secondary register the number of
 *	times in the primary register
 *	(results in primary register)
 *
 */
gasl ()
{
        if (TRACE) fprintf(output,";gasl()\n");
	gpop ();
	gcall ("?asl");
}

/*
 *	two's complement of primary register
 *
 */
gneg ()
{
        if (TRACE) fprintf(output,";gneg()\n");
	gcall ("?neg");
}

/*
 *	logical complement of primary register
 *
 */
glneg ()
{
        if (TRACE) fprintf(output,";glneg()\n");
	gcall ("?lneg");
}

/*
 *	one's complement of primary register
 *
 */
gcom ()
{
        if (TRACE) fprintf(output,";gcom()\n");
	gcall ("?com");
}

/*
 *	Convert primary value into logical value (0 if 0, 1 otherwise)
 *
 */
gbool ()
{
        if (TRACE) fprintf(output,";gbool()\n");
	gcall ("?bool");
}

/*
 *	increment the primary register by 1 if char, INTSIZE if
 *      int
 */
ginc (lval)
int lval[];
{
        if (TRACE) fprintf(output,";ginc()\n");
	ol ("inx\th");
	if (lval[2] == CINT)
		ol ("inx\th");
}

/*
 *	decrement the primary register by one if char, INTSIZE if
 *	int
 */
gdec (lval)
int lval[];
{
        if (TRACE) fprintf(output,";gdec()\n");
	ol ("dcx\th");
	if (lval[2] == CINT)
		ol("dcx\th");
}

/*
 *	following are the conditional operators.
 *	they compare the secondary register against the primary register
 *	and put a literl 1 in the primary if the condition is true,
 *	otherwise they clear the primary register
 *
 */

/*
 *	equal
 *
 */
geq ()
{
        if (TRACE) fprintf(output,";geq()\n");
	gpop();
	gcall ("?eq");
}

/*
 *	not equal
 *
 */
gne ()
{
        if (TRACE) fprintf(output,";gne()\n");
	gpop();
	gcall ("?ne");
}

/*
 *	less than (signed)
 *
 */
glt ()
{
        if (TRACE) fprintf(output,";glt()\n");
	gpop();
	gcall ("?lt");
}

/*
 *	less than or equal (signed)
 *
 */
gle ()
{
        if (TRACE) fprintf(output,";gle()\n");
	gpop();
	gcall ("?le");
}

/*
 *	greater than (signed)
 *
 */
ggt ()
{
        if (TRACE) fprintf(output,";ggt()\n");
	gpop();
	gcall ("?gt");
}

/*
 *	greater than or equal (signed)
 *
 */
gge ()
{
        if (TRACE) fprintf(output,";gge()\n");
	gpop();
	gcall ("?ge");
}

/*
 *	less than (unsigned)
 *
 */
gult ()
{
        if (TRACE) fprintf(output,";gult()\n");
	gpop();
	gcall ("?ult");
}

/*
 *	less than or equal (unsigned)
 *
 */
gule ()
{
        if (TRACE) fprintf(output,";gule()\n");
	gpop();
	gcall ("?ule");
}

/*
 *	greater than (unsigned)
 *
 */
gugt ()
{
        if (TRACE) fprintf(output,";gugt()\n");
	gpop();
	gcall ("?ugt");
}

/*
 *	greater than or equal (unsigned)
 *
 */
guge ()
{
        if (TRACE) fprintf(output,";guge()\n");
	gpop();
	gcall ("?uge");
}

inclib() {
#ifdef	cpm
	return("B:");
#endif
#ifdef	unix
	return(INCDIR);
#endif
}

/*	Squirrel away argument count in a register that modstk
	doesn't touch.
*/

gnargs(d)
int	d;
{
        if (TRACE) fprintf(output,";gnargs(%d)\n",d);
	ot ("mvi\ta,");
	onum(d);
	nl ();
}

assemble(s)
char	*s; {
        if (TRACE) fprintf(output,";assemble(%s)\n",s);
#ifdef	ASNM
	char buf[100];
	strcpy(buf, ASNM);
	strcat(buf, " ");
	strcat(buf, s);
	buf[strlen(buf)-1] = 's';
	return(system(buf));
#else
	return(0);
#endif
}

link() {
#ifdef	LDNM
	fputs("I don't know how to link files yet\n", stderr);
#else
	return(0);
#endif
}
