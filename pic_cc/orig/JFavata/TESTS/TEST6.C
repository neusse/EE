
/* example of including static strings in compiler */

char a, b, c, d;

main() {

    a="hello";
    b="goodbye";
    for (d=0; d<7; d++)
      c=GetChar(b,d);      /* index through the string */
    for (d=0; d<5; d++)    /* ditto */
      c=GetChar(a,d);
}

#include "getchar.c"

