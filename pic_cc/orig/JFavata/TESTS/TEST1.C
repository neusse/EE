#define TRUE 1
#define FALSE 0

char ad, d1, d2, d3;

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
{
   char v;
   v=0xff;    
   return(v);

}


    



