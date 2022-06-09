/*      File codepic.c: 1.0 2/15/95 */
/*                                  */
/*      Version 0.002  John Favata  */

/* Revision history */
/* 2/16/95  generates less inline code */
/* 2/15/95  minor glitch in gsub */
/*                               */

#include <stdio.h>

#include "defs.h"

#include "data.h"

#define INCDIR "./"

#define ERRMSG "FATAL ERROR in code generation\n"
#define WARNING ";FYI: WARNING: Signed chars are not implemented\n"
#define CHAR_WARNING ";FYI: WARNING: only char ptrs are allowed\n"

/*      Define ASNM and LDNM to the names of the assembler and linker
	respectively */

/*
 *      Some predefinitions:
 *
 *      INTSIZE is the size of an integer in the target machine
 *      BYTEOFF is the offset of an byte within an integer on the
 *              target machine. (ie: 8080,pdp11 = 0, 6809 = 1,
 *              360 = 3)
 *      This compiler assumes that an integer is the SAME length as
 *      a pointer - in fact, the compiler uses INTSIZE for both.
 */
#define INTSIZE 1
#define BYTEOFF 0

FILE *Trace;
int TRACE;

int M_lib=FALSE;   /* see if we have to load MULT library */
int S_lib=FALSE;   /* see if we need shift library */
int G_lib=FALSE;   /* see if we need comp library */

/*
 *      print all assembler info before any code is generated
 *
 */
inittrace()
{
   /* Trace=fopen("trace.out","w"); */
}

endtrace()
{
   /* fclose(Trace);  */
}

header ()
{

	if (TRACE) fprintf(output,";header()\n");

	outstr (";Small C PIC16C84;\n;\tCoder (1.0 2/10/95)\n");
	outstr (";\tVersion 0.002 \n\n;");
	FEvers();
	nl ();
	nl ();
	outstr ("\tinclude '16c84.h'");
	nl ();
}

nl ()
{
	outbyte (EOL);
}


initmac()
{
	if (TRACE)
	   fprintf(output,";initmac()\n");
	defmac("cpm\t1");
	defmac("I8080\t1");
	defmac("RMAC\t1");
	defmac("smallc\t1");
}


galign(t)
int     t;
{
	if (TRACE)
	   fprintf(output,";galign(%d)\n",t);
	return(t);
}

/*
 *      return size of an integer
 */
intsize() {
	return(INTSIZE);
}

/*
 *      return offset of ls byte within word
 *      (ie: 8080 & pdp11 is 0, 6809 is 1, 360 is 3)
 */

byteoff() {
	return(BYTEOFF);
}

/*
 *      Output internal generated label prefix
 */
olprfix() {
	outbyte('_');
}

/*
 *      Output a label definition terminator
 */
col ()
{
	outbyte ('_');
}

/*
 *      begin a comment line for the assembler
 *
 */
comment ()
{
	outbyte (';');
}

/*
 *      Emit user label prefix
 */
prefix ()
{
       /* outbyte('_'); */
}


/*
 *      print any assembler stuff needed after all code
 *
 */
trailer ()
{
	if (TRACE)
	  fprintf(output,"\n;trailer()\n");

	ol ("end");
	nl();
}

/*
 *      function prologue
 */
prologue ()
{
	if (TRACE)
	   fprintf(output,";prologue()\n");
	ol("\n\n; Begin Function \n");
	ol("\n");
}

/*
 *      text (code) segment
 */
gtext ()
{
	if (TRACE)
	   fprintf(output,";gtext()\n");
	ol ("\n; **************code segment cseg*******************");
	ol ("\n  org _CSEG\n");
}

/*
 *      data segment
 */
gdata ()
{
	if (TRACE) fprintf(output,";gdata()\n");
        if (M_lib==TRUE) {
          outstr("\n;*******need mult/div standard library********\n");
          ol("\n\tinclude 'mlibpic.h'\n");
        }

        if (S_lib==TRUE) {
          outstr("\n;*******need shift/sub standard library********\n");
          ol("\n\tinclude 'slibpic.h'\n");
        }

        if (G_lib==TRUE) {
          outstr("\n;*******need compare standard library********\n");
          ol("\n\tinclude 'glibpic.h'\n");
        }

	ol ("\n\n; **************data segment dseg*******************");
	ol ("\n  org _DSEG\n");
}

/*
 *  Output the variable symbol at scptr as an extrn or a public
 */
ppubext(scptr)
char *scptr;
{
	if (TRACE)
	  fprintf(output,";ppubext(%s)\n",scptr);
	/******
	if (cptr[STORAGE] == STATIC) return;
	ot (scptr[STORAGE] == EXTERN ? "extrn\t" : "public\t");
	prefix ();
	outstr (scptr);
	nl();
	*******/
}

/*
 * Output the function symbol at scptr as an extrn or a public
 */
fpubext(scptr)
char *scptr;
{
	if (TRACE)
	   fprintf(output,";ppubext(%s)\n",scptr);
	/*******
	if (scptr[STORAGE] == STATIC) return;
	ot (scptr[OFFSET] == FUNCTION ? "public\t" : "extrn\t");
	prefix ();
	outstr (scptr);
	nl ();
	********/
}

/*
 *  Output a decimal number to the assembler file
 */
onum(num)
int num;
{
	outdec(num);
}


/*
 *      fetch a static memory cell into the primary register
 */
getmem (sym)
char    *sym;
{
	if (TRACE)
	   fprintf(output,";getmem(%s)\n",sym);
	if ((sym[IDENT] != POINTER) &
	    (sym[TYPE] == CCHAR)) {
		ot ("mov _primary, ");
		outstr (sym + NAME);
		col();
		nl ();
		/* gcall ("?sxt"); */
	} else {
		outstr(CHAR_WARNING);
		ot ("mov _primary, ");
		outstr (sym + NAME);
		nl ();
	}
}

/*
 *      fetch the address of the specified symbol into the primary register
 *
 */
getloc (sym)
char    *sym;
{
	if (TRACE)
	   fprintf(output,";getloc(%s)\n",sym);
	immed();
	if (sym[STORAGE] == LSTATIC) {
		printlabel(glint(sym));
		nl();
	} else {
		outdec (glint(sym) - stkp ); /**/
		nl ();
		/* outstr (";*****dad sp****\n"); */
		ol ("add _primary, _stackptr");
	}
}

/*
 *      store the primary register into the specified static memory cell
 *
 */
putmem (sym)
char    *sym;
{
	if (TRACE)
	   fprintf(output,";putmem(%s)\n",sym);
	if ((sym[IDENT] != POINTER) &
	    (sym[TYPE] == CCHAR)) {
		ot ("mov ");
		outstr (sym + NAME);
		col();
		ot (", _primary");
	} else {
		outstr(CHAR_WARNING);
		ot ("mov ");
		outstr (sym + NAME);
		col();
		ot (", _primary");
	}
	nl ();
}

/*
 *      store the specified object type in the primary register
 *      at the address on the top of the stack
 *
 */
putstk (typeobj)
char    typeobj;
{
	if (TRACE)
	   fprintf(output,";putstk(%d)\n",typeobj);
	gpop ();
	if (typeobj == CCHAR) {
            gcall("_putstk");
/****
	   ol( "mov _fr4, _secondary\n");
	   ol( "mov _fr0, _primary\n");
*****/
	}
	else {
            outstr(CHAR_WARNING);
            gcall("_putstk");
/*****
	    ol( "mov _fr4, _secondary\n");
	    ol( "mov _fr0, _primary\n");
*****/
	}
}

/*
 *      fetch the specified object type indirect through the primary
 *      register into the primary register
 *
 */
indirect (typeobj)
char    typeobj;
{
	if (TRACE)
	   fprintf(output,";indirect(%d)\n",typeobj);
	if (typeobj == CCHAR) {
	     /*   ol("add _primary, _stackptr");  */
             gcall("_indr");
/****
	     ol("mov _fr4, _primary");
	     ol("mov _primary, _fr0");
****/
	}
	else {
	     outstr(CHAR_WARNING);
             gcall("_indr");
/***
	     ol("mov _fr4, _primary");
	     ol("mov _primary, _fr0");
****/
	}
}

/*
 *      swap the primary and secondary registers
 *
 */
swap ()
{
	if (TRACE)
	   fprintf(output,";swap\n");
        gcall("_swap");
/******
	ol ("mov _temp, _primary");
	ol ("mov _primary, _secondary");
	ol ("mov _secondary, _temp");
*******/
}

/*
 *      print partial instruction to get an immediate value into
 *      the primary register
 *
 */

immed ()
{
	if (TRACE)
	   fprintf(output,";immed()\n");
	ot ("mov _primary, #");
}

immed_nopound ()
{
	if (TRACE)
	   fprintf(output,";immed()\n");
	ot ("mov _primary, ");
}


/*
 *      push the primary register onto the stack
 *
 */
gpush ()
{
	if (TRACE)
	   fprintf(output,";gpush\n");
/*****
	ol ("dec _stackptr");
	ol ("mov _fr4, _stackptr");
	ol ("mov _fr0, _primary");
******/
        gcall("_push");
	stkp = stkp - INTSIZE;
}

/*
 *      pop the top of the stack into the secondary register
 *
 */
gpop ()
{
	if (TRACE)
	   fprintf(output,";gpop\n");
/*****
	ol ("mov _fr4, _stackptr");
	ol ("mov _secondary, _fr0");
	ol ("inc _stackptr");
*****/
        gcall("_pop");
	stkp = stkp + INTSIZE;
}

/*
 *      swap the primary register and the top of the stack
 *
 */
swapstk ()
{
	if (TRACE)
	  fprintf(output,";swapstk\n");
        gcall("_swaps");
/*****
	ol ("mov _fr4, _stackptr");
	ol ("mov _temp, _fr0");
	ol ("mov _fr0, _primary");
	ol ("mov _primary, _temp");
*****/
}

/*
 *      call the specified subroutine name
 *
 */
gcall (sname)
char    *sname;
{
	if (TRACE)
	   fprintf(output,";gcall\n",sname);
	ot ("call ");
	outstr (sname);
	col();
	nl ();
}

/*
 *      return from subroutine
 *
 */
gret ()
{
	if (TRACE)
	   fprintf(output,";gret\n");
	ol ("ret");
}

/*
 *      perform subroutine call to value on top of stack
 *
 */
callstk ()
{
	if (TRACE)
	   fprintf(output,";callstk\n");
outstr( ERRMSG );
	return;
/******
	immed ();
	outstr ("$+5");
	nl ();
	swapstk ();
	ol ("pchl");
	stkp = stkp + INTSIZE;
******/
}

/*
 *      jump to specified internal label number
 *
 */
jump (label)
int     label;
{
	if (TRACE)
	   fprintf(output,";jump(%d)\n",label);
	ot ("jmp ");
	printlabel (label);
	col();
	nl ();
}

/*
 *      test the primary register and jump if false to label
 *
 */
testjump (label, ft)
int     label,
	ft;
{
	if (TRACE)
	   fprintf(output,";testjump(%d,%d)\n",label,ft);
	ol ("mov W, _primary");
	if (ft)
		ot ("jnz ");
	else
		ot ("jz ");
	printlabel (label);
	col();
	nl ();
}

/*
 *      print pseudo-op  to define a byte
 *
 */
defbyte ()
{
	if (TRACE)
	   fprintf(output,";defbyte()\n");
	ot ("db ");
}

/*
 *      print pseudo-op to define storage
 *
 */
defstorage ()
{
	if (TRACE)
	   fprintf(output,";defstorage()\n");
	ot ("ds\t");
}

/*
 *      print pseudo-op to define a word
 *
 */
defword ()
{
	if (TRACE)
	   fprintf(output,";defword()\n");
	ot ("dw\t");
}

/*
 *      modify the stack pointer to the new value indicated
 *
 */
modstk (newstkp)
int     newstkp;
{
	int     k;
        char buffer[50];

	if (TRACE)
	   fprintf(output,";modstk(%d)\n",newstkp);

	k = galign(newstkp - stkp);

	if (k == 0) {
	   return (newstkp);
	}
	/* forget about stack alignment */
	if (k > 0) {
          sprintf(buffer,"add _stackptr, #%d",k);
          ol(buffer);
	  return (newstkp);
	}
	else {
          k=-k;
          sprintf(buffer,"sub _stackptr, #%d",k);
          ol(buffer);
	  return (newstkp);
	}
}

/*
 *      multiply the primary register by INTSIZE
 */
gaslint ()
{
	if (TRACE)
	   fprintf(output,";gaslint()\n");
	/* ol ("dad\th"); */
}

/*
 *      divide the primary register by INTSIZE
 */
gasrint()
{
	if (TRACE)
	  fprintf(output,";gasrint()\n");
	return;
#ifdef INTEGERS
	gpush();        /* push primary in prep for gasr */
	immed ();
	onum (1);
	nl ();
	gasr ();  /* divide by two */
#endif
}

/*
 *      Case jump instruction
 */

gjcase( label )
int label;
{
	if (TRACE)
	   fprintf(output,";gjcase()\n");
	jump(label);
}

/* this is a real hack */
/* output inline code for case statement */

outcase( typ, value, label )
int typ;
int value;
int label;
{
    char buffer[50];

    if (TRACE)
       fprintf(output,";outcase()\n");
    if (typ==CASE) {
      sprintf(buffer,"cje _primary,#%d, _%d_",value,label);
      ol(buffer);
    }
    else
    if (typ==DEFAULT) {
      sprintf(buffer,"jmp _%d_",label);
      ol(buffer);
    }
    else
      outstr(ERRMSG);
}

/*
 *      add the primary and secondary registers
 *      if lval2 is int pointer and lval is not, scale lval
 */

gadd (lval,lval2)
int *lval,*lval2;
{
	if (TRACE)
	   fprintf(output,";gadd(%d, %d)\n",*lval,*lval2);
	gpop ();
	if (dbltest (lval2, lval)) {
		swap ();
		gaslint ();
		swap ();
	}
	ol ("add _primary, _secondary");
}

/*
 *      subtract the primary register from the secondary
 *      P=S-P;
 */
gsub ()
{
	if (TRACE)
	  fprintf(output,";gsub()\n");
	gpop ();
        S_lib=TRUE;
        gcall("_sub");
/*****
	ol ("mov _temp, _secondary");
	ol ("sub _temp, _primary");
	ol ("mov _primary, _temp");
******/
}

/*
 *      multiply the primary and secondary registers
 *      (result in primary)
 *
 */
gmult ()
{
	if (TRACE)
	   fprintf(output,";gmult()\n");
        M_lib=TRUE;
	gpop();
	gcall ("_mul");
}

/*
 *      divide the secondary register by the primary
 *      (quotient in primary, remainder in secondary)
 *
 */
gdiv ()
{
	if (TRACE)
	   fprintf(output,";gdiv()\n");
        M_lib=TRUE;
	gpop();
	gcall ("_div");
}

/*
 *      compute the remainder (mod) of the secondary register
 *      divided by the primary register
 *      (remainder in primary, quotient in secondary)
 *
 */

gmod ()
{
	if (TRACE)
	   fprintf(output,";gmod()\n");
        M_lib=TRUE;
	gdiv ();
	swap ();
}

/*
 *      inclusive 'or' the primary and secondary registers
 *
 */
gor ()
{
	if (TRACE)
	   fprintf(output,";gor()\n");
	gpop();
	ol ("or _primary, _secondary");
}

/*
 *      exclusive 'or' the primary and secondary registers
 *
 */
gxor ()
{
	if (TRACE)
	  fprintf(output,";gxor()\n");
	gpop();
	ol ("mov W, _secondary");
	ol ("xor _primary, W");
}

/*
 *      'and' the primary and secondary registers
 *
 */
gand ()
{
	if (TRACE)
	   fprintf(output,";gand()\n");
	gpop();
	ol ("and _primary, _secondary");
}

/*
 *      arithmetic shift right the secondary register the number of
 *      times in the primary register
 *      (results in primary register)
 *
 */
gasr ()
{
	if (TRACE)
	   fprintf(output,";gasr()\n");
	gpop();
        S_lib=TRUE;
        gcall ("_asr");
/**********
      ol("clc");
      ol("mov W,>>_secondary");
      ol("mov _secondary, W");
      ol("djnz _primary, $-3");
      ol("mov _primary,_secondary");
**********/
}

/*
 *      arithmetic shift left the secondary register the number of
 *      times in the primary register
 *      (results in primary register)
 *
 */
gasl ()
{
	if (TRACE)
	  fprintf(output,";gasl()\n");
	gpop ();
        S_lib=TRUE;
	gcall ("_asl");
/*******
      ol("clc");
      ol("mov W,<<_secondary");
      ol("mov _secondary, W");
      ol("djnz _primary, $-3");
      ol("mov _primary,_secondary");
*******/
}

/*
 *      two's complement of primary register
 *
 */
gneg ()
{
	if (TRACE)
	   fprintf(output,";gneg()\n");
	ol ("neg _primary");
}

/*
 *      logical complement of primary register
 *
 */
glneg ()
{
	if (TRACE)
	  fprintf(output,";glneg()\n");
     /* gcall ("_logneg");  */
	ol ( "mov W, #1");
	ol ( "xor _primary, W");
}

/*
 *      one's complement of primary register
 *
 */
gcom ()
{
	if (TRACE)
	  fprintf(output,";gcom()\n");
	ol ("not _primary");
}

/*
 *      Convert primary value into logical value (0 if 0, 1 otherwise)
 *
 */
gbool ()
{
	if (TRACE)
	   fprintf(output,";gbool()\n");
        G_lib=TRUE;
	gcall ("_bool");
/********
	ol ( "mov W, _primary" );
	ol ( "jnz $+3");
	ol ( "mov _primary, #0" );
	ol ( "skip");
	ol ( "mov _primary, #1" );
*********/
}

/*
 *      increment the primary register by 1 if char, INTSIZE if
 *      int
 */
ginc (lval)
int lval[];
{
	if (TRACE)
	   fprintf(output,";ginc()\n");
	ol ("inc _primary");
	if (lval[2] == CINT) {
outstr( ERRMSG );
	  ol ("inc _primary");
	  ol ("inc _primary");
	}

}

/*
 *      decrement the primary register by one if char, INTSIZE if
 *      int
 */
gdec (lval)
int lval[];
{
	if (TRACE) fprintf(output,";gdec()\n");
	ol ("dec _primary");
	if (lval[2] == CINT) {
outstr( ERRMSG );
	  ol("dec _primary");
	  ol("dec _primary");
	}
}

/*
 *      following are the conditional operators.
 *      they compare the secondary register against the primary register
 *      and put a literl 1 in the primary if the condition is true,
 *      otherwise they clear the primary register
 *
 */

/*
 *      equal
 *
 */
geq ()
{
	if (TRACE)
	   fprintf(output,";geq()\n");
	gpop();
        G_lib=TRUE;
        gcall("_geq");
/******
	ol("csne _primary, _secondary");
	ol("jmp $+3");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*******/

}

/*
 *      not equal
 *
 */
gne ()
{
	if (TRACE)
	  fprintf(output,";gne()\n");
	gpop();
        G_lib=TRUE;
        gcall("_gne");
/*******
	ol("cse _primary, _secondary");
	ol("jmp $+4");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
********/
}

/* ******  signed chars are not handled yet, use unsigned versions ******/
/*
 *      less than (signed)
 *
 */

glt ()
{
	if (TRACE)
	   fprintf(output,";glt()\n");
outstr( WARNING );
	gpop();
        G_lib=TRUE;
        gcall( "_glt");
/********
	ol("cjb _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
********/
}


/*
 *      less than or equal (signed)
 *
 */
gle ()
{
	if (TRACE)
	   fprintf(output,";gle()\n");
outstr( WARNING );
	gpop();
        G_lib=TRUE;
        gcall("_gle");
/********
	ol("cjbe _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*********/
}

/*
 *      greater than (signed)
 *
 */
ggt ()
{
	if (TRACE)
	   fprintf(output,";ggt()\n");
outstr( WARNING );
	gpop();
        G_lib=TRUE;
        gcall("_ggt");
/********
	ol("cja _secondary, _primary, $+7");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
********/
}

/*
 *      greater than or equal (signed)
 *
 */
gge ()
{
	if (TRACE)
	   fprintf(output,";gge()\n");
outstr( WARNING );
	gpop();
        G_lib=TRUE;
        gcall ("_gge");

/******
	ol("cjae _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*******/
}

/*
 *      less than (unsigned)
 *
 */
gult ()
{
	if (TRACE)
	   fprintf(output,";gult()\n");
	gpop();
        G_lib=TRUE;
	gcall ("_gult");
/*******
	ol("cjb _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*******/
}

/*
 *      less than or equal (unsigned)
 *
 */
gule ()
{
	if (TRACE)
	  fprintf(output,";gule()\n");
	gpop();
        G_lib=TRUE;
	gcall ("_gule");
/*******
	ol("cjbe _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*******/
}

/*
 *      greater than (unsigned)
 *
 */
gugt ()
{
	if (TRACE)
	   fprintf(output,";gugt()\n");
	gpop();
        G_lib=TRUE;
	gcall ("_gugt");
/********
	ol("cja _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
*********/

}

/*
 *      greater than or equal (unsigned)
 *
 */
guge ()
{
	if (TRACE)
	   fprintf(output,";guge()\n");
	gpop();
        G_lib=TRUE;
	gcall ("_guge");
/**********
	ol("cjae _secondary, _primary, $+7 ");
	ol("mov _primary, #0");
	ol("skip");
	ol("mov _primary, #1");
**********/

}

inclib() {
	return(INCDIR);
}


/*      Squirrel away argument count in a register that modstk
	doesn't touch.
*/

gnargs(d)
int     d;
{
	if (TRACE)
	   fprintf(output,";gnargs(%d)\n",d);
	ot (";;(# args passed) mov W, #");
	onum(d);
	nl ();
}

assemble(s)
char    *s; {
	if (TRACE)
	   fprintf(output,";assemble(%s)\n",s);
#ifdef  ASNM
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
#ifdef  LDNM
	fputs("I don't know how to link files yet\n", stderr);
#else
	return(0);
#endif
}

