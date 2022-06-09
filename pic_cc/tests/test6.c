
/* example of including static strings in compiler */

char a, b, i;
char c[7];	/* these arrays are here only to check that the strings */
char d[5];	/* are correctly read by the GetChar routine */
main() {

    a="hello";
    b="goodbye";
    for (i=0; i<7; i++)
      c[i]=GetChar(b,i);	/* index through the string */
    for (i=0; i<5; i++)		/* ditto */
      d[i]=GetChar(a,i);
}

#include "getchar.c"

