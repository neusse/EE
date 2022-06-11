LAB-XUSB README.TXT file, Copyright (C) 2008 microEngineering Labs, Inc.

The files on this disk should include:

	DS1307.PDF		Dallas real time clock data sheet
        LABXUSB.TXT             LAB-XUSB instruction file
        LABXUSCH.PDF            LAB-XUSB schematic
        MAX549A.PDF		Maxim DAC data sheet
        README.TXT              This file
        PBC\*.BAS               PICBASIC(TM) sample programs
        PBC\*.HEX               Compiled PICBASIC sample programs
        PBP\*.BAS               PICBASIC PRO(TM) sample programs
        PBP\*.HEX               Compiled PICBASIC PRO sample programs



LAB-XUSB Instructions

A printed schematic is included with the LAB-XUSB.  The file LABXUSB.TXT
contains LAB-XUSB assembly and operating instructions.



LAB-XUSB Power

Jumper JP2 is critical to the operation of the LAB-XUSB.  It is used to
select between powering the board from a PC through the USB connector, J4,
or with an AC adapter connected to J2.  If JP2 pins 1 and 2 (labeled USB)
are jumpered, power will be taken from the USB connector.  If pins 2 and 3
(labeled Ext.) are jumpered, power is taken from an AC adapter via the
on-board regulator.  An AC adapter that provides between +7.5 and +16 volts
DC is recommended to power the LAB-XUSB through J2.  The center pin on the
connector is positive.



PICBASIC(TM) Sample Program Information

The PICBASIC sample programs on this disk have been compiled with the
PICBASIC Compiler version 1.45 for the PIC16F877(A) running at 20MHz (HS).
They do not use any USB features of the board as the standard PICBASIC
Compiler does not support the USB devices.



PICBASIC PRO(TM) Sample Program Information

The PICBASIC PRO sample programs on this disk have been compiled with the
PICBASIC PRO Compiler version 2.46 for the PIC18F4550 with a 20MHz crystal
(HSPLL) and a core frequency of 48MHz.



PICBASIC and PICBASIC PRO are trademarks of Microchip Technology Inc. in
the U.S.A. and other countries.


microEngineering Labs, Inc.
Box 60039
Colorado Springs CO 80960
(719) 520-5323
(719) 520-1867 fax
http://www.melabs.com
email:support@melabs.com
