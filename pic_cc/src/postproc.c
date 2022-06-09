/*
 *	postproc.c - rearranges assembler output, putting globals first
 *
 */
 
#include <stdio.h>

#include "defs.h"

#include "data.h"

hack ()		/* this is really, really an ugly hack */
		/* but it works */
{
	openin2();	/* open input file (with .s suffix) */
	openout2();	/* open output file (with .asm suffix) */
	copy_prolog();	/* copy everything until beginning of code segment */
	copy_globals();	/* skip until data segment, copy data segment */
	copy_rest();	/* copy code segment, copy end of the file */
	fclose (input); /* close input file */
	fclose (output);/* close output file */
	return;
}

/*
 *	open assembler file with .s suffix
 */
openin2 ()
{
	if (!checkname2 (fname))
		return (NO);
	if ((input = fopen (fname, "r")) == NULL) {
		pl ("Open failure\n");
		return (NO);
	}
	kill ();
	return (YES);
}

/*
 *	open output file
 */
openout2 ()
{
	outfname2 (fname);
	if ((output = fopen (fname, "w")) == NULL) {
		pl ("Open failure");
		return (NO);
	}
	kill ();
	return (YES);
}

/*
 *	change input filename to output filename
 */
outfname2 (s)
char	*s;
{
	while (*s)
		s++;
	s[-1] = 'a';
	*s++ = 's';
	*s++ = 'm';
	*s = '\0';
}

/*
 *	check that filename is "*.s"
 */
checkname2 (s)
char	*s;
{
	while (*s)
		s++;
	if (*--s != 's')
		return (NO);
	if (*--s != '.')
		return (NO);
	return (YES);
}

/*
 *	copy top of the file, until beginning of code segment
 */
copy_prolog ()
{
	char	*assem_line;
	while (1)
	{
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "code segment") == NULL)
				        {
					    fputs (assem_line, output);
					}
				    else
				  	    break;
				}
			}
		else
			break;
	}
}

/*
 *	copy data segment
 */
copy_globals ()
{
	char	*assem_line;
	while (1)	/* find data segment */
	{
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "data segment") == NULL)
				        continue;
				    else
				        break;
				}
			}
		else
			break;
	}
	fputs (assem_line, output);

	while (1)	/* copy data segment */
	{		
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "in compilation") == NULL)
				        {
					    fputs (assem_line, output);
					}
				    else
				  	    break;
				}
			}
		else
			break;
	}
}

/*
 *	copy code segment and rest of file
 */
copy_rest ()
{
	char	*assem_line;
	rewind (input);
	while (1)	/* find code segment */
	{
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "code segment") == NULL)
				        continue;
				    else
				        break;
				}
			}
		else
			break;
	}
	fputs (assem_line, output);

	while (1)	/* copy code segment until data segment*/
	{		
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "data segment") == NULL)
				        {
					    fputs (assem_line, output);
					}
				    else
				  	    break;
				}
			}
		else
			break;
	}
	
	while (1)	/* find rest of file */
	{
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
			        {
				    if (strstr (assem_line, "in compilation") == NULL)
				        continue;
				    else
				        break;
				}
			}
		else
			break;
	}
	fputs (assem_line, output);

	while (1)	/* copy until end of file*/
	{		
		if (!feof (input))
			{
			    if (fgets (assem_line, 255, input))
					    fputs (assem_line, output);
			}
		else
			break;
	}
}
