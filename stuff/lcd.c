
// PC0 -> LCD DB7
// PC1 -> LCD DB6
// PC2 -> LCD DB5
// PC3 -> LCD DB4
// PC4 -> LCD E
// PC5 -> LCD R/W
// PC6 -> LCD RS
// PC7 -> LCD BackLight
//
// PD0 ->
// PD1 ->
// PD2 ->
// PD3 ->
// PD4 ->
// PD5 ->
// PD6 ->
// PD7 -> LCD CONTRAST
//
//*****************************************************************************
//                        T I M E R   U S A G E
//
// Timer 0 not use
// Timer 1 not use
// Timer 2 not use
// Timer 3 not use
//
//*****************************************************************************

//*****************************************************************************
//                            I N C L U D E
//*****************************************************************************
#include <iom32v.h>
#include <shortnametype.h>
#include <macros.h>

//*****************************************************************************
//                            D E F I N E
//*****************************************************************************

// LCD
#define LCD_D7                  0x01
#define LCD_D6                  0x02
#define LCD_D5                  0x04
#define LCD_D4                  0x08
#define LCD_E                   0x10
#define LCD_RW                  0x20
#define LCD_RS                  0x40
#define LCD_BACKLIGHT           0x80

#define LCD_PIN                 PINC
#define LCD_DDR                 DDRC
#define LCD_PORT                PORTC

#define LCD_DATA                0x01
#define LCD_CTRL                0x00

#define LCD_C_BLINK_ON          0x09
#define LCD_C_BLINK_OFF         0xfe
#define LCD_C_ON                0x0a
#define LCD_C_OFF               0xfd
#define LCD_DISPLAY_ON          0x0c
#define LCD_DISPLAY_OFF         0xfb
#define LCD_BRIGHT_25           0x23
#define LCD_BRIGHT_50           0x22
#define LCD_BRIGHT_75           0x21
#define LCD_BRIGHT_100          0x20
#define LCD_BACKLIGHT_ON        0x24
#define LCD_BACKLIGHT_OFF       0x25

//*****************************************************************************
//                            P R O T O T Y P E
//*****************************************************************************
void main(void);

// LCD
void LCDInit(ushort x,ushort y);
void LCDOff(void);
void LCDClrSCR(void);
void LCDGotoXY(ushort,ushort);
ushort LCDWhereX(void);
ushort LCDWhereY(void);
void LCDWriteString(char *);
void LCDWriteConstString(const char *);
void LCDWriteChar(char);
void LCDWriteData(ushort,ushort);
ushort LCDReadData(ushort rs);
void LCDCreateCHR(ushort chnumber, char *ptr);
void LCDWait(void);
void LCDDelay50us(int Delay);
void LCDTextAttr(ushort attribute);
void LCDContrast(ushort Cont);

//*****************************************************************************
//                      G L O B A L   V A R I A B L E
//*****************************************************************************
// LCD
ushort MaxX, MaxY, LCDStat;
char Text[20];


//*****************************************************************************
//                      M A I N
//*****************************************************************************
void main()
{

  SEI(); //re-enable interrupts

  LCDInit(20,2);

  LCDClrSCR();
  LCDGotoXY(1,1);
  LCDWriteConstString("Test Test Test Test\0");
  LCDGotoXY(1,2);
  LCDWriteConstString("--------------------\0");


   while(TRUE)
   {
     WDR();
   }
}

//*****************************************************************************
// LCD Code
//*****************************************************************************
/******************************************************************************

Name:         LCDCreateCHR

Description:  Create a new char in CGRAM

Input:        ushort  : Character number (0-7)
              *ushort : 7 ushort containing the data

Output:       none

Misc:

******************************************************************************/
void LCDCreateCHR(ushort chnumber, char *ptr)
{
  ushort i,j;

  i = 8 * chnumber;

  for (j=0;j<8;j++)
  {
    LCDWriteData(LCD_CTRL,(0x40 | (i + j)));
    LCDWriteData(LCD_DATA,ptr[j]);
  }
}


/******************************************************************************

Name:         void LCDClrSCR(void)

Description:  Clear the LCD

Input:        none

Output:       none

Misc:

******************************************************************************/
void LCDClrSCR(void)
{
  LCDWait();
  LCDWriteData(LCD_CTRL,0x01);      // Clear display
}

/******************************************************************************

Name:         LCDGotoXY(ushort x, ushort y)

Description:  Position cursor on the LCD at X & Y location

Input:        X -> X position on the LCD
              Y -> Y position on the LCD

Output:       none

Misc:

******************************************************************************/
void LCDGotoXY(ushort x,ushort y)
{
  ushort address;

  x--;

  if (MaxY < 3)
  {
    switch(y)
    {
      case '\x01' :
      address = 0 + x;
      break;
      case '\x02' :
      address = 64 + x;
      break;
    }
  }
  else
  {
    switch(y)
    {
      case '\x01' :
      address = 0 + x;
      break;
      case '\x02' :
      address = 64 + x;
      break;
      case '\x03' :
      address = 20 + x;
      break;
      case '\x04' :
      address = 84 + x;
      break;
    }
  }
  LCDWriteData(LCD_CTRL,address | 0x80);
}

/******************************************************************************

Name:         LCDWhereX

Description:  Get the x position of the cursor on the LCD

Input:        None

Output:       ushort : Cursor position "x"

Misc:

******************************************************************************/
ushort LCDWhereX(void)
{
ushort i,x,y;

i = LCDReadData(LCD_CTRL) & 0x7f;

y = LCDWhereY();

if (MaxY == 2)
    {
    if (y == 1) x = i;
    if (y == 2) x = i - 0x40;
    }
else if (MaxY == 4)
    {
    if (y == 1) x = i;
    if (y == 2) x = i - 0x40;
    if (y == 3) x = i - 0x14;
    if (y == 4) x = i - 0x54;
    }
x = x + 1;
return x;
}

/******************************************************************************

Name:         LCDWhereY

Description:  Get the y position of the cursor on the LCD

Input:        None

Output:       ushort : Cursor position "y"

Misc:

******************************************************************************/
ushort LCDWhereY(void)
{
  ushort i,j;

  i = LCDReadData(LCD_CTRL) & 0x7f;

  if (MaxY == 2)
  {
    if (i < 0x28) j = 1;
    else j = 2;
  }
  else if (MaxY == 4)
  {
    if ((i >0x00) && (i < 0x15)) j = 1;
    if ((i >0x14) && (i < 0x28)) j = 3;
    if ((i >0x40) && (i < 0x55)) j = 2;
    if ((i >0x54) && (i < 0x68)) j = 4;
  }
  return j;
}

/******************************************************************************

Name:         WtireByteLCD(char byte)

Description:  Write a byte on the LCD at cursor position

Input:        byte

Output:       none

Misc:

******************************************************************************/
void LCDWriteChar(char byte)
{
  char tmp;

  tmp = byte & 0xf0;
  tmp = tmp >> 4;
  tmp += 0x30;
  if (tmp > 0x39) tmp += 0x07;
  LCDWriteData(LCD_DATA,tmp);

  tmp = byte & 0x0f;
  tmp += 0x30;
  if (tmp > 0x39) tmp += 0x07;
  LCDWriteData(LCD_DATA,tmp);
}

/******************************************************************************

Name:         void LCDWriteString(char *ptr)

Description:  Write a string from RAM on the LCD

Input:        string pointer

Output:       none

Misc:

******************************************************************************/
void LCDWriteString(char *ptr)
{
  ushort i;

  for (i=1;i<41;i++)
  {
    if (*ptr == 0x00) break;
    LCDWriteData(LCD_DATA,*ptr++);
  }
}

/******************************************************************************

Name:         void LCDWriteConstString(const char *ptr)

Description:  Write a constant string on the LCD

Input:        string pointer

Output:       none

Misc:

******************************************************************************/
void LCDWriteConstString(const char *ptr)
{
  ushort i;

  for (i=1;i<41;i++)
  {
    if (*ptr == 0x00) break;
    else if (i == 21) LCDGotoXY(1,2);
    LCDWriteData(LCD_DATA,*ptr++);
  }
}

/******************************************************************************

Name:         void LCDWriteData(ushort rs, ushort ch)

Description:  Write a byte in rs of the LCD

Input:        rs -> Register select
              ch -> byte to write

Output:       none

Misc:

******************************************************************************/
void LCDWriteData(ushort rs,ushort ch)
{
  ushort Stat;

  Stat = LCD_PIN & LCD_BACKLIGHT;

  LCD_PORT = Stat;

  LCDWait();

  if ((ch & 0x80) == 0x80) LCD_PORT |= LCD_D7;
  if ((ch & 0x40) == 0x40) LCD_PORT |= LCD_D6;
  if ((ch & 0x20) == 0x20) LCD_PORT |= LCD_D5;
  if ((ch & 0x10) == 0x10) LCD_PORT |= LCD_D4;
  if (rs == 1) LCD_PORT |= LCD_RS;
  LCDDelay50us(1);

  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;

  LCD_PORT = Stat;
  if ((ch & 0x08) == 0x08) LCD_PORT |= LCD_D7;
  if ((ch & 0x04) == 0x04) LCD_PORT |= LCD_D6;
  if ((ch & 0x02) == 0x02) LCD_PORT |= LCD_D5;
  if ((ch & 0x01) == 0x01) LCD_PORT |= LCD_D4;
  if (rs == 1) LCD_PORT |= LCD_RS;
   LCDDelay50us(1);

  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;
}

/******************************************************************************

Name:         ushort LCDRead(ushort rs)

Description:  read a byte in rs of the LCD

Input:        rs -> Register select

Output:       ushort

Misc:    

******************************************************************************/
ushort LCDReadData(ushort rs)
{
  ushort Byte=0;

  LCD_DDR &= ~(LCD_D7 + LCD_D6 + LCD_D5 + LCD_D4);

  LCD_PORT = LCD_PIN & LCD_BACKLIGHT;
  LCD_PORT |= LCD_RW;
  if (rs == 1) LCD_PORT |= LCD_RS;
  LCDDelay50us(1);

  LCD_PORT |= LCD_E;
  LCD_PORT |= LCD_E;
  if (LCD_PIN & LCD_D7) Byte |= 0x80;
  if (LCD_PIN & LCD_D6) Byte |= 0x40;
  if (LCD_PIN & LCD_D5) Byte |= 0x20;
  if (LCD_PIN & LCD_D4) Byte |= 0x10;
  LCD_PORT &= ~LCD_E;

   LCD_PORT |= LCD_E;
  LCD_PORT |= LCD_E;
  if (LCD_PIN & LCD_D7) Byte |= 0x08;
  if (LCD_PIN & LCD_D6) Byte |= 0x04;
  if (LCD_PIN & LCD_D5) Byte |= 0x02;
  if (LCD_PIN & LCD_D4) Byte |= 0x01;
  LCD_PORT &= ~LCD_E;

  LCD_PORT &= ~LCD_RW;

  LCD_DDR |= LCD_D7 + LCD_D6 + LCD_D5 + LCD_D4;

  return (Byte);
}

/******************************************************************************

Name:         void LCDWait(void)

Description:  wait for the LCD to be ready

Input:        none

Output:       none

Misc:    

******************************************************************************/
void LCDWait(void)
{
  while((LCDReadData(0) & 0x80) == 0x80) WDR();
}

/******************************************************************************

Name:         void LCDDelay50us(int Delay)

Description:  Delay of 50 us with a 16Mhz resonator

Input:        Delay X x 50us

Output:       none

Misc:

******************************************************************************/
void LCDDelay50us(int Delay)
{
  int i,j;

  for (i=0;i<Delay;i++)
  {
    for (j=1;j<120;j++);
    asm("WDR");
  }
}

/******************************************************************************

Name:         void LCDTextAttr(ushort Attribute)

Description:  Set the LCD attribute

Input:        LCD_C_BLINK_ON     : Cursor blink on
              LCD_C_BLINK_OFF    : Cursor blink off
              LCD_C_ON           : Cursor on
              LCD_C_OFF          : Cursor off
              LCD_DISPLAY_ON     : Display ON
              LCD_DISPLAY_OFF    : Display OFF
              LCD_BRIGHT_25      : VFD 25% Bright
              LCD_BRIGHT_50      : VFD 50% Bright
              LCD_BRIGHT_75      : VFD 75% Bright
              LCD_BRIGHT_100     : VFD 100% Bright
              LCD_BACK_LIGHT_ON  : Back Light ON
              LCD_BACK_LIGHT_OFF : Back Light OFF

Output:       none

Misc:

******************************************************************************/
void LCDTextAttr(ushort attribute)
{
switch (attribute)
    {
    case LCD_C_BLINK_ON:
         LCDStat |= LCD_C_BLINK_ON;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_C_BLINK_OFF:
         LCDStat &= LCD_C_BLINK_OFF;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_C_ON:
         LCDStat |= LCD_C_ON;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_C_OFF:
         LCDStat &= LCD_C_OFF;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_DISPLAY_ON:
         LCDStat |= LCD_DISPLAY_ON;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_DISPLAY_OFF:
         LCDStat &= LCD_DISPLAY_OFF;
         LCDWriteData(LCD_CTRL,LCDStat);
         break;

    case LCD_BRIGHT_25:
         LCDWriteData(LCD_CTRL,0x20);
         LCDWriteData(LCD_DATA,0x03);
         break;

    case LCD_BRIGHT_50:
         LCDWriteData(LCD_CTRL,0x20);
         LCDWriteData(LCD_DATA,0x02);
         break;

    case LCD_BRIGHT_75:
         LCDWriteData(LCD_CTRL,0x20);
         LCDWriteData(LCD_DATA,0x01);
         break;

    case LCD_BRIGHT_100:
         LCDWriteData(LCD_CTRL,0x20);
         LCDWriteData(LCD_DATA,0x00);
         break;

    case LCD_BACKLIGHT_ON:
         LCD_PORT |= LCD_BACKLIGHT;
         break;

    case LCD_BACKLIGHT_OFF:
         LCD_PORT &= ~(LCD_BACKLIGHT);
         break;
    }
}

/******************************************************************************

Name:         void LCDOn(ushort X, ushort Y)

Description:  Initialize LCD in 4bit mode

Input:        ushort X -> X size
              ushort Y -> Y size

Output:       none

Misc:

******************************************************************************/
void LCDInit(ushort X, ushort Y)
{
  MaxX = X;
  MaxY = Y;
  LCDStat = 0x0c;
  LCD_PORT = 0x00;
  LCD_DDR = LCD_D7+LCD_D6+LCD_D5+LCD_D4+LCD_E+LCD_RS+LCD_RW+LCD_BACKLIGHT;
  LCD_PORT = ~(LCD_D7+LCD_D6+LCD_D5+LCD_D4+LCD_E+LCD_RS+LCD_RW);
  LCD_PORT |= LCD_BACKLIGHT;
  LCDDelay50us(340);

  LCD_PORT = (LCD_D5 + LCD_D4 + LCD_BACKLIGHT);
  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;
  LCDDelay50us(100);
  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;
  LCDDelay50us(100);
  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;
  LCDDelay50us(100);

  LCD_PORT = (LCD_D5 + LCD_BACKLIGHT);
  LCD_PORT |= LCD_E;
  LCD_PORT &= ~LCD_E;
  LCDDelay50us(100);

  if (Y == 1) LCDWriteData(LCD_CTRL,0x20);    // 1 line
  else LCDWriteData(LCD_CTRL,0x28);           // 2 line

  LCDWriteData(LCD_CTRL,0x0c);                // Disp ON-Cur OFF-Blink OFF
  LCDWriteData(LCD_CTRL,0x01);                // Clear display
  LCDDelay50us(50);
  LCDWriteData(LCD_CTRL,0x06);                // Cursor INC Shift OFF

  DDRD |= 0x80;
  TCCR2 = 0x79;
  OCR2 = 0xff;
}

/******************************************************************************

Name:         void LCDContrast(ushort Cont)

Description:  Set the LCD Contrast

Input:        from 0 to 255

Output:       none

Misc:

******************************************************************************/
void LCDContrast(ushort Cont)
{
  OCR2 = Cont;
}

/******************************************************************************

Name:         void LCDOff(void)

Description:  Shut down LCD

Input:        none

Output:       none

Misc:

******************************************************************************/
void LCDOff(void)
{
 LCD_DDR = 0xff;
 LCD_PORT = 0x00;
 DDRD &= ~0x80;
}
