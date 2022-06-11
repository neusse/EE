' PICBASIC PRO program to receive HEX file from PC and write 
' data to I2C memory. Writes data in page mode, 16 bytes at one
' time.  Memory device must be addressed with 16 bits and capable
' of receiving 16 bytes at once.

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
pinin   VAR	PORTC.7                 ' Serial receive pin
pinout  VAR     PORTC.6                 ' Serial transmit pin


addr    VAR     WORD                    ' Memory Address
dta1    VAR     BYTE[17]                ' Data array with location for checksum
bb      VAR     BYTE                    ' Byte count
tt      VAR     BYTE                    ' Record type
i       VAR     WORD                    ' Loop counter
cs      VAR     BYTE                    ' Checksum
ln      VAR     BYTE                    ' Line count

        Clear                           ' Clear RAM data



        ADCON1 = 7                      ' Set PORTA and PORTE to digital
        
        ln = 0                          ' Clear line count
        
        HSerout ["Erasing"]
        
        For i = 0 To 8192 Step 8        ' Store $00 to all locations (for testing)
                
                I2CWrite sda,scl,$A0,i,[STR dta1\8]
                If i//256 = 0 Then
                        HSerout ["."]           
                EndIf                                   
                Pause 6
                
	Next i

        
        HSerout [13,10,"Ready",13,10]	' Notify: ready for file
        
mainloop:   cs = 0                          ' Reset checksum byte
        
        HSerin [WAIT(":"),HEX2 bb,HEX4 addr,HEX2 tt]    ' Receive line and parse
        
        cs = bb + addr.lowbyte + addr.highbyte + tt	' Begin checksum calculation
        
        If (tt = 1) Then eof            ' Check for end of file
        
        For i = 0 To bb        	        ' Loop for each expected data-byte and checksum
                HSerin [HEX2 dta1[i]]   ' Store each byte to location in array
                cs = cs + dta1[i]       ' Add each byte to checksum calculation
        Next i

        ln = ln + 1                     ' Count line received
        
        If (cs <> 0) Then sume          ' Check for checksum error
        
	I2CWrite sda,scl,$A0,addr,[STR dta1\bb] ' Write data to device, checksum is dropped
             
        Goto mainloop			' Go get another line
        

sume:   HSerout ["Checksum Error: line ",DEC ln,13,10]  ' Notify: checksum error

                
eof:    HSerout [DEC ln," lines received",13,10]        ' Notify: Confirm line count


        For i = 0 To (ln*16)            ' Loop 16 times for each line received

                I2CRead sda,scl,$A0,i,[cs]	' Read back each character
                HSerout [HEX2 cs]	' Send each character

                If (i+1)//16 = 0 Then
                        HSerout [13,10]	' New line every 16 characters
                EndIf                                   

        Next i

        HSerout [13,10,13,10]           ' New Lines

        End

