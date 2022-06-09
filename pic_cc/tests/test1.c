/*
 * test1.c - testing the while statement
 *
 */
 
#define TRUE 1
#define FALSE 0

char ad, d1, d2, d3;

/* GetAD simulates reading an 8-bit A/D converter.
 * d1, d2 and d3 are three decimal digits corresponding to the value read
 *
 * In this case we read 0xff and the resulting d1, d2 and d3 are 2, 5 and 5.
 *
 */

main()
{  
   char cnt;
   while(TRUE) {   
     ad=GetAD();
     cnt=0;
     while (ad>=100) { 
       ad=ad-100;
       cnt++;
     }
     d1=cnt;
     cnt=0;
     while (ad>=10) { 
       ad=ad-10;
       cnt++;
     }
     d2=cnt;
     cnt=0;
     while (ad>0) { 
       ad=ad-1;
       cnt++;
     }
     d3=cnt;
   }
}


GetAD() 
/* v is our local variable */
{
   char v;
   v=0xff;    
   return(v);
}
