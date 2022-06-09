
char z; 

main()
{  
   char i;
   i=0;
   while(i<5) { 
     if (i==0) 
       z=f1();
     if (i==1) 
       z=f2();
     if (i==2) 
       z=f3();
     if (i==3) 
       z=f4();
     if (i==4)
       z=f5();
     i++;
   }
}

f1() { return(1); }
f2() { return(2); }
f3() { return(3); }
f4() { return(4); }
f5() { return(5); }



    



