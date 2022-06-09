
char val;

main()
{  

   char aa,bb,cc,dd;
   load( &aa, &bb, &cc, &dd);
   val=aa+bb+cc+dd;
   
}


load( a, b, c, d )
char *a, *b, *c, *d;
{
     *a = 1;
     *b = 2;
     *c = 3;
     *d = 4;
}


    



