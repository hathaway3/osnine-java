         nam   PipeMan
         ttl   os9 file manager     

         ifp1
         use   defsfile
         endc
tylg     set   FlMgr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .
name     equ   *
         fcs   /PipeMan/
         fcb   $02 
start    equ   *
         lbra  L0042
         lbra  L0042
         lbra  L003C
         lbra  L003C
         lbra  L003C
         lbra  L003C
         lbra  L00A9
         lbra  L00F7
         lbra  L00A3
         lbra  L00F0
         lbra  L0040
         lbra  L0040
         lbra  L0078
L003C    comb  
         ldb   #$D0
         rts   
L0040    clrb  
         rts   
L0042    ldu   $06,y
         ldx   $04,u
         pshs  y
         os9   F$PrsNam 
         bcs   L0073
         lda   -$01,y
         bmi   L0058
         leax  ,y
         os9   F$PrsNam 
         bcc   L0073
L0058    sty   $04,u
         puls  y
         ldd   #$0100
         os9   F$SRqMem 
         bcs   L0072
         stu   $08,y
         stu   <$14,y
         stu   <$16,y
         leau  d,u
         stu   <$12,y
L0072    rts   
L0073    comb  
         ldb   #$D7
         puls  pc,y
L0078    lda   $02,y
         bne   L0086
         ldu   $08,y
         ldd   #$0100
         os9   F$SRtMem 
         bra   L00A1
L0086    cmpa  $0B,y
         bne   L008E
         leax  $0A,y
         bra   L0094
L008E    cmpa  $0F,y
         bne   L00A1
         leax  $0E,y
L0094    lda   ,x
         beq   L00A1
         ldb   $02,x
         beq   L00A1
         clr   $02,x
         os9   F$Send   
L00A1    clrb  
         rts   
L00A3    ldb   #$0D
         stb   $0D,y
         bra   L00AB
L00A9    clr   $0D,y
L00AB    leax  $0A,y
         lbsr  L0140
         bcs   L00EB
         ldd   $06,u
         beq   L00EB
         ldx   $04,u
         addd  $04,u
         pshs  b,a
         bra   L00C9
L00BE    pshs  x
         leax  $0A,y
         lbsr  L016B
         puls  x
         bcs   L00DC
L00C9    lbsr  L01DD
         bcs   L00BE
         sta   ,x+
         tst   $0D,y
         beq   L00D8
         cmpa  $0D,y
         beq   L00DC
L00D8    cmpx  ,s
         bcs   L00C9
L00DC    tfr   x,d
         subd  ,s++
         addd  $06,u
         std   $06,u
         bne   L00EA
         ldb   #$D3
         bra   L00EB
L00EA    clrb  
L00EB    leax  $0A,y
         lbra  L019D
L00F0    ldb   #$0D
         stb   <$11,y
         bra   L00FA
L00F7    clr   <$11,y
L00FA    leax  $0E,y
         lbsr  L0140
         bcs   L013C
         ldd   $06,u
         beq   L013C
         ldx   $04,u
         addd  $04,u
         pshs  b,a
         bra   L0118
L010D    pshs  x
         leax  $0E,y
         lbsr  L016B
         puls  x
         bcs   L0130
L0118    lda   ,x
         lbsr  L01B7
         bcs   L010D
         leax  $01,x
         tst   <$11,y
         beq   L012B
         cmpa  <$11,y
         beq   L0130
L012B    cmpx  ,s
         bcs   L0118
         clrb  
L0130    pshs  b,cc
         tfr   x,d
         subd  $02,s
         addd  $06,u
         std   $06,u
         puls  x,b,cc
L013C    leax  $0E,y
         bra   L019D
L0140    lda   ,x
         beq   L0165
         cmpa  $05,y
         beq   L0169
         inc   $01,x
         ldb   $01,x
         cmpb  $02,y
         bne   L0153
         lbsr  L0094
L0153    os9   F$IOQu   
         dec   $01,x
         pshs  x
         ldx   D.Proc
         ldb   <$36,x
         puls  x
         beq   L0140
         coma  
         rts   
L0165    ldb   $05,y
         stb   ,x
L0169    clrb  
         rts   
L016B    ldb   $01,x
         incb  
         cmpb  $02,y
         beq   L0199
         stb   $01,x
         ldb   #$01
         stb   $02,x
         clr   $05,y
         pshs  x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  L0094
         ldx   #$0000
         os9   F$Sleep  
         ldx   D.Proc
         ldb   <$36,x
         puls  x
         dec   $01,x
         tstb  
         bne   L019B
         clrb  
         rts   
L0199    ldb   #$F5
L019B    coma  
         rts   
L019D    pshs  u,b,cc
         ldu   D.Proc
         lda   <$11,u
         bne   L01AA
         ldb   $01,x
         bne   L01B5
L01AA    sta   ,x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  L0094
L01B5    puls  pc,u,b,cc
L01B7    pshs  x,b
         ldx   <$14,y
         ldb   <$18,y
         beq   L01C9
         cmpx  <$16,y
         bne   L01CE
         comb  
         puls  pc,x,b
L01C9    ldb   #$01
         stb   <$18,y
L01CE    sta   ,x+
         cmpx  <$12,y
         bcs   L01D7
         ldx   $08,y
L01D7    stx   <$14,y
         clrb  
         puls  pc,x,b
L01DD    lda   <$18,y
         bne   L01E4
         comb  
         rts   
L01E4    pshs  x
         ldx   <$16,y
         lda   ,x+
         cmpx  <$12,y
         bcs   L01F2
         ldx   $08,y
L01F2    stx   <$16,y
         cmpx  <$14,y
         bne   L01FD
         clr   <$18,y
L01FD    andcc #$FE
         puls  pc,x
         emod
eom      equ   *
