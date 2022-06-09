/*	File main.c
 *	Parses command line, opens source file, steps through compilation
 *
 */

#define PICASM		/* define single-pass assembler */

#include <stdio.h>

#include "defs.h"

#include "data.h"

main (argc, argv)
int	argc, *argv;
{
	char	*p,*bp;
	int smacptr;
	macptr = 0;
	ctext = 0;
	argc--; argv++;
	errs = 0;
	aflag = 1;
        TRACE=0;

        inittrace();
	while ( (p = (char *) *argv++) )
		if (*p == '-') while (*++p)
			switch(*p) {
				case 't': case 'T':
					ctext = 1;
					break;
				case 's': case 'S':
					sflag = 1;
					break;
				case 'c': case 'C':
					cflag = 1;
					break;
				case 'a': case 'A':
					aflag = 0;
					break;
				case 'd': case 'D':
					bp = ++p;
					if (!*p) usage();
					while (*p && *p != '=') p++;
					if (*p == '=') *p = '\t';
					while (*p) p++;
					p--;
					defmac(bp);
					break;
                                case 'r': case 'R':
                                	TRACE=1;
                                        break;
				default:
					usage();
			}
			else break;

	smacptr = macptr;
	if (!p)
		usage();
	while (p) {
		errfile = 0;
		if (ftypeof(p) == 'c') {

			if (!openin (p))
				return;
			if (!openout ())
				return;

			glbptr = STARTGLB;
			locptr = STARTLOC;
			wsptr = ws;
			inclsp =
			iflevel =
			skiplevel =
			swstp =
			litptr =
			stkp =
			errcnt =
			ncmp =
			lastst =
			quote[1] =
			0;
			macptr = smacptr;
			input2 = NULL;
			quote[0] = '"';
			cmode = 1;
			glbflag = 1;
			nxtlab = 0;
			litlab = getlabel ();
			defmac("end\tmemory");
			addglb("memory", ARRAY, CCHAR, 0, EXTERN);
			addglb("stack", ARRAY, CCHAR, 0, EXTERN);
			rglbptr = glbptr;
			addglb ("etext", ARRAY, CCHAR, 0, EXTERN);
			addglb ("edata", ARRAY, CCHAR, 0, EXTERN);
			defmac("short\tint");
			initmac();
			/*
			 *	compiler body
			 */
                        /*******
			if (!openin (p))
				return;
			if (!openout ())
				return;
                        **********/
			header ();
			gtext ();
			parse ();
			fclose (input);
			/* gdata ();   imbed lits in code space */
			dumplits ();
                        gdata();
			dumpglbs ();
			errorsummary ();
			trailer ();
			fclose (output);
#ifdef PICASM
			hack();		/* picasm is a single-pass assembler, */
					/* we have to put the globals before */
					/* the actual code uses them */
#endif			
			pl ("");
			errs = errs || errfile;
#ifndef	NOASLD
		}
		if (!errfile && !sflag)
			errs = errs || assemble(p);
#else
		} else {
			fputs("Don't understand file ", stderr);
			fputs(p, stderr);
			errs = 1;
		}
#endif
		p = (char *) *argv++;
	}
#ifndef	NOASLD
	if (!errs && !sflag && !cflag)
		errs = errs || link();
#endif
        endtrace();
	exit(errs != 0);
}

FEvers()
{
	outstr(";\tFront End");
}

usage()
{
	fputs("usage: pic_cc [-acdrst] [-DSYM[=VALUE]] files\n", stderr);
	fputs("        -r: trace on.\n", stderr);
	exit(1);
}

/*
 *	process all input text
 *
 *	at this level, only static declarations, defines, includes,
 *	and function definitions are legal.
 *
 */
parse ()
{
	while (!feof (input)) {
		if (amatch ("extern", 6))
			dodcls(EXTERN);
		else if (amatch ("static",6))
			dodcls(STATIC);
		else if (dodcls(PUBLIC)) ;
		else if (match ("#asm"))
			doasm ();
		else if (match ("#include"))
			doinclude ();
		else if (match ("#define"))
			dodefine();
		else if (match ("#undef"))
			doundef();
		else
			newfunc ();
		blanks ();
	}
}

/*
 *		parse top level declarations
 */

dodcls(stclass)
int stclass; {
	blanks();
	if (amatch("char", 4))
		declglb(CCHAR, stclass);
	else if (amatch("int", 3))
		declglb(CINT, stclass);
	else if (stclass == PUBLIC)
		return(0);
	else
		declglb(CINT, stclass);
	ns ();
	return(1);
}


/*
 *	dump the literal pool
 */
dumplits ()
{
	int	j, k;
        char ch;

	if (litptr == 0)
		return;

        outstr("\n; Begin global string table\n");
        outstr("\n_string_table_\n");     /* add a new special label */
        ol("addwf\t_pcl,F");		  /* for strings */
	printlabel (litlab);
	col ();
	k = 0;
	while (k < litptr) {
		j = 255;		/* max string length */
	        ch=litq[k++] & 127;
		while (j--) {
			if ((j == 0) || (k >= litptr) || (ch==0)) {
                                ot("retlw\t0");
                                nl ();
				break;
			}
			else {
				ot("retlw\t");
				outdec(ch);
				ot("; ");
				outbyte('\'');
				outbyte(ch);
				outbyte('\'');
				nl ();
				break;
			}
		}
	}
}


#ifdef OLDVER
dumplits ()
{
	int	j, k;

	if (litptr == 0)
		return;
	printlabel (litlab);
	col ();
	k = 0;
	while (k < litptr) {
		defbyte ();
		j = 8;
		while (j--) {
			onum (litq[k++] & 127);
			if ((j == 0) | (k >= litptr)) {
				nl ();
				break;
			}
			outbyte (',');
		}
	}
}
#endif
/*
 *	dump all static variables
 */
dumpglbs ()
{
	int	j;

	if (!glbflag)
		return;
	cptr = rglbptr;
	while (cptr < glbptr) {
		if (cptr[IDENT] != FUNCTION) {
			ppubext(cptr);
			if (cptr[STORAGE] != EXTERN) {
				prefix ();
				outstr (cptr);
				col ();
				defstorage ();
				j = glint(cptr);
				if ((cptr[TYPE] == CINT) ||
				    (cptr[IDENT] == POINTER))
					j = j * intsize();
				onum (j);
				nl ();
			}
		} else {
			fpubext(cptr);
		}
		cptr = cptr + SYMSIZ;
	}
}

/*
 *	report errors
 */
errorsummary ()
{
	if (ncmp)
		error ("missing closing bracket");
	nl ();
	comment ();
	outdec (errcnt);
	if (errcnt) errfile = YES;
	outstr (" error(s) in compilation");
	nl ();
	comment();
	ot("literal pool:");
	outdec(litptr);
	nl();
	comment();
	ot("global pool:");
	outdec(glbptr-rglbptr);
	nl();
	comment();
	ot("Macro pool:");
	outdec(macptr);
	nl();
	pl (errcnt ? "Error(s)" : "No errors");
}

ftypeof(s)
char	*s; {
	s += strlen(s) - 2;
	if (*s == '.')
		return(*(s+1));
	return(' ');
}
