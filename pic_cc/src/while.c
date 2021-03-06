/*
 *	File while.c: 2.1 (83/03/20,16:02:22)
 *
 */

#include <stdio.h>

#include "defs.h"

#include "data.h"

addwhile (ptr)
int	ptr[];
{
	int	k;

	if (wsptr == WSMAX) {
		error ("too many active whiles");
		return;
	}
	k = 0;
	while (k < WSSIZ)
		*wsptr++ = ptr[k++];
}

delwhile ()
{
	if (readwhile ())
		wsptr = wsptr - WSSIZ;
}

readwhile ()
{
	if (wsptr == ws) {
		error ("no active do/for/while/switch");
		return (0);
	} else
		return ((int)(wsptr-WSSIZ));
}

findwhile ()
{
	int	*ptr;

	for (ptr = wsptr; ptr != ws;) {
		ptr = ptr - WSSIZ;
		if (ptr[WSTYP] != WSSWITCH)
			return ((int)ptr);
	}
	error ("no active do/for/while");
	return (0);
}

readswitch ()
{
	int	*ptr;

	if ( (ptr = (int *) readwhile ()) )
		if (ptr[WSTYP] == WSSWITCH)
			return ((int)ptr);
	return (0);
}

addcase (val)
int	val;
{
	int	lab;

	if (swstp == SWSTSZ)
		error ("too many case labels");
	else {
		swstcase[swstp] = val;
		swstlab[swstp++] = lab = getlabel ();
		printlabel (lab);
		col ();
		nl ();
	}
}
