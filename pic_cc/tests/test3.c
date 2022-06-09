/*
 * switch statement test
 */
 
char z[5]; 

main()
{  
   char i;
   for (i=0; i<5; i++) { 
     switch(i) {
     case 0: z[i]=f1();
             break;
     case 1: z[i]=f2();
             break;
     case 2: z[i]=f3();
             break;
     case 3: z[i]=f4();
             break;
     case 4: z[i]=f5();
             break;
     }
   }
}

f1() { return(1); }
f2() { return(2); }
f3() { return(3); }
f4() { return(4); }
f5() { return(5); }
