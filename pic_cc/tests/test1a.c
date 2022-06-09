/*
 * test1a.c - testing the while statement
 *
 */
 
char ad, d1, d2, d3;

/* 
 * d1, d2 and d3 are three decimal digits corresponding to the value in ad
 *
 * In this case we have ad = 255 and the resulting d1, d2 and d3
 * are 2, 5 and 5.
 *
 */

main()
{  
   ad = 255;

   d1 = 0;
   while (ad >= 100) { 
       ad = ad - 100;
       d1++;
   }
   d2 = 0;
   while (ad >= 10) { 
       ad = ad - 10;
       d2++;
   }
   d3 = 0;
   while (ad > 0) { 
       ad = ad - 1;
       d3++;
   }
}
