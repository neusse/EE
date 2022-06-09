
char z; 

main()
{  
   char i;
   for (i=0; i<5; i++) { 
     switch(i) {
     case 0: z=f1();
             break;
     case 1: z=f2();
             break;
     case 2: z=f3();
             break;
     case 3: z=f4();
             break;
     case 4: z=f5();
             break;
     }
   }
}

f1() { return(1); }
f2() { return(2); }
f3() { return(3); }
f4() { return(4); }
f5() { return(5); }



    



