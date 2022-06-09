/* test i/o port modes */

#include "io.c"

char a, b;

main()
{

   SetP_A(0x3);
   SetP_B(0x0f);
   a=RdPortA();
   b=RdPortB();
   WrPortA(0x1);
   WrPortB(0x55);

}
