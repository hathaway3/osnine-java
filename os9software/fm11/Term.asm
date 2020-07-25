         nam   Term
         ttl   os9 device descriptor

 use defsfile

tylg     set   Devic+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $03 mode byte
         fcb   $0F extended controller address
         fdb   $FF00  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $00 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 case:0=up&lower,1=upper only
         fcb   $01 backspace:0=bsp,1=bsp then sp & bsp
         fcb   $00 delete:0=bsp over line,1=return
         fcb   $01 echo:0=no echo
         fcb   $01 auto line feed:0=off
         fcb   $00 end of line null count
         fcb   $01 pause:0=no end of page pause
         fcb   $18 lines per page
         fcb   $08 backspace character
         fcb   $18 delete line character
         fcb   $0D end of record character
         fcb   $1B end of file character
         fcb   $04 reprint line character
         fcb   $01 duplicate last line character
         fcb   $17 pause character
         fcb   $03 interrupt character
         fcb   $05 quit character
         fcb   $08 backspace echo character
         fcb   $07 line overflow character (bell)
         fcb   $07 init value for dev ctl reg
         fcb   $00 baud rate
         fdb   name copy of descriptor name address
         fcb   $00 acia xon char
         fcb   $00 acia xoff char
         fcb   $01 (szx) number of columns for display
         fcb   $50 (szy) number of rows for display
         fcb   $19 window number
initsize equ   *
name     equ   *
         fcs   /Term/
mgrnam   equ   *
         fcs   /SCF/
drvnam   equ   *
         fcs   /Vterm/
         emod
eom      equ   *
