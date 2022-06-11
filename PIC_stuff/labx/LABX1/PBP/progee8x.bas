' PICBASIC PRO program to receive HEX file from PC and write 
' data to I2C memory. Writes data in page mode, 8 bytes at one
' time.  Memory device must be addressed with 8 bits and capable
' of receiving 8 bytes at once.

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Set receive register to receiver enabled
DEFINE HSER_RCSTA       90h
' Set transmit register to transmitter enabled
DEFINE HSER_TXSTA       20h
' Set baud rate
DEFINE HSER_BAUD        2400


scl     VAR     PORTC.3                 ' Clock pin
sda     VAR     PORTC.4                 ' Data pin
pinin   VAR	PORTC.7			' Serial receive pin
pinout  VAR	PORTC.6                 ' Serial transmit pin


addr    VAR	BYTE                     ' Memory Address
dta1    VAR	BYTE[9]                  ' Data array with location for checksum
bb      VAR	BYTE                     ' Byte count
tt	VAR	BYTE                     ' Record type
i	VAR	BYTE                     ' Loop counter
cs	VAR	BYTE                     ' Checksum
ln	VAR	BYTE                     ' Line count

	Clear                            ' Clear RAM data


        ADCON1 = 7                      ' Set PORTA and PORTE to digital
        
        ln = 0                          ' Clear line count
        
        For i = 0 To 255 Step 8         ' Store $00 to first 256 locations (for testing)
                
                I2CWrite sda,scl,$A0,i,[STR dta1\8]
                Pause 10
                
        Next i

        
        HSerout ["Ready",13,10]		' Notify: ready for file
        
mainloop:   cs = 0                          ' Reset checksum byte
        
        HSerin [WAIT(":"),HEX2 bb,HEX4 addr,HEX2 tt]    ' Receive line and parse
        
        cs = bb + addr + tt             ' Begin checksum calculation
        
        If (tt = 1) Then eof            ' Check for end of file
        
        If (bb>8) Then                  ' Write twice if more that 8 bytes of data on line
        
                For i = 0 To 7          ' Loop for first 8 bytes of data
                        HSerin [HEX2 dta1[i]]   ' Store each byte to location in array
                        cs = cs + dta1[i]	' Add each byte to checksum calculation
                Next i

                I2CWrite sda,scl,$A0,addr,[STR dta1\8]  ' Write 8 bytes of data to device
                        
                bb = bb - 8
                addr = addr + 8
        
                For i = 0 To (bb)	' Loop for remaining expected data-bytes and checksum
                        HSerin [HEX2 dta1[i]]   ' Store each byte to location in array
                        cs = cs + dta1[i]       ' Add each byte to checksum calculation
                Next i

                If (cs <> 0) Then sume  ' Check for checksum error

                I2CWrite sda,scl,$A0,addr,[STR dta1\bb] ' Write remaining data to device

	Else                    	' Write once if 8 or less bytes of data
       
                For i = 0 To bb         ' Loop for each expected data-byte and checksum
                        HSerin [HEX2 dta1[i]]   ' Store each byte to location in array
                        cs = cs + dta1[i]       ' Add each byte to checksum calculation
                Next i
        
                If (cs <> 0) Then sume  ' Check for checksum error

                I2CWrite sda,scl,$A0,addr,[STR dta1\bb] ' Write data to device
                
	EndIf
            
        ln = ln + 1                     ' Count line received
        Goto mainloop                       ' Go get another line
        

sume:   HSerout ["Checksum Error: line ",DEC ln,13,10]  ' Notify: checksum error

                
eof:    HSerout [DEC ln," lines received",13,10]	' Notify: Confirm line count


        For i = 0 To (ln*16)		' Loop 16 times for each line received

		I2CRead sda,scl,$A0,i,[cs]	' Read back each character
        	HSerout [HEX2 cs]       ' Send each character

	        If (i+1)//16 = 0 Then
        		HSerout [13,10]	' New line every 16 characters
               	EndIf                                   

        Next i

	HSerout [13,10,13,10]           ' New Lines

        End
