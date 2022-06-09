
char aa, bb, cc, dd;

main()
{  
   char kk;

   aa=3; 
   bb=5;
   cc=aa*bb;

   kk=cc+1; 
   dd=myfunc( kk );

}


myfunc( t )
char t;
{
    char c;  
     
    c=t+4;
    return( c );

}


    



