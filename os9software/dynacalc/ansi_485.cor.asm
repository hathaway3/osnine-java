* This file does not work on Tandy's version 4.8:5.
* It is a modified copy of tvi970_484, and the entry point
* from the dynacalc program is different.
* The TRM file was found in the OS-9 archive.

 ifp1
 use defsfile
DYNAVERS equ $0485
 endc
 opt m
 org 0


M0000 fcb 'I,$FD,'f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcc "DYNACALC, Version 4.8:5              "
      fcc "Copyright (C) 1982,1984 by Scott Schaeferle."
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00
M0088 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $1B,'[,'1,'m,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $1B,'[,'m,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$1B,'[,'K,$FF,$FF,$FF,$1B,'[
      fcb 'J,$FF,$FF,$FF,$1B,'[,'m,$FF,$FF,$FF,$FF,$FF,$1B,'[,'1,'m
      fcb $FF,$FF,$FF,$FF,$08,$20,$08,$FF,$FF,$FF,$08,$FF,$FF,$FF
M00DE fcc "ANSI            "
M00EE fcb $04,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,'O,$00,'9
M0100 fcb '{,'},'[,'],$14,'`,$07,$09,$03,$08,$20,$20,$00,$18,'O,$09
      fcb $00,$05,$00,$00,$00,$00,$00,'a,$F0,$00,'X,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb '[,'1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$92,$FF,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,'$,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$02,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$14,$00
      fcb $00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $0D,'_,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,'#,$14,$00,$00,$00,'Z,$80,$01,$F1,$03,$00,$00
      fcb $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0200 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$01,$00,$00,$01,$00,$00,$18,$08,$15,$0D,$00,$04,$01,$00
      fcb $00,$00,$08,$07,$93,$03,$00,'2,$11,$13,$00,$8E,'h,$07,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0300 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$01,$00,$00,$01,$00,$00,$18,$08,$18,$0D,$00,$04,$01
      fcb $00,$00,$00,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$01,$00,$01,$01,$00,$01,$18,$08,$18,$0D,$1B,$04,$01,$17
      fcb $03,$11,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00,$00
      fcb $80,$80,$80,$80,$80,$0D,$FF,'+,'-,'.,$FF,'/,'*,'^,'<,'>
      fcb '=,',,$FF,'(,'),$FF,'#,'@,$FF,'!,$FF,$FF,'",$FF,'+,'-
      fcb '(,'.,'@,'#,$FF,'>,$FF,'X,'!,$0D,$80,$FF,$80,$80,$80,$80
      fcb $FF,'/,$FF,$FF,$20,$20,'(,'X,'),$20,$00,'R,'e,'a,'d,'y
      fcb $00,'V,'a,'l,'u,'e,$00,'L,'a,'b,'e,'l,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0400 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0500 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00
M0562 fcb $20,$20,$20,$20,$20,'J,'u,'n,'e,$20,'2,'8,',,$20,'1,'9,'8,'4
      fcb $00

M0575 fcb $06,$00,'w,$B5,$D0,$E1,$20,$02,'j,'b,'9
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $08,$C8,$CA,'a,$10,$A7,$C3,$82,$9A,$CD,$07,'u,$87,$CB,$EC,$83
      fcb '",$AA,'6,$DB,$AD,$01,$02,$82,$08,$C8,$CA,'a,$10,$A7,$C3,$83
      fcb $DA,$EB,$E9,$14,$85,$BD,'h,$84,'f,$0A,$FB,$F5,$8B,$01,$CE,$82
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$01,$00
M0600 fcb $00,'$,$00,$00,$00,$00,$00,$00,$10,$8E,$00,'P,'0,$8D,$00,$19
      fcb $86,$02,$10,'?,$8A,'O,'0,$8D,$00,$0F,$10,$8E,$00,$01,$10,'?
      fcb $89,$EE,$8D,$FF,'P,'n,$C9,'<,$95,$0D,$0A,$0A,'O,'U,'T,$20
      fcb 'O,'F,$20,'M,'E,'M,'O,'R,'Y,'-,$20,'W,'o,'r,'k,'s
      fcb 'h,'e,'e,'t,$20,'n,'o,'t,$20,'c,'o,'m,'p,'l,'e,'t
      fcb 'e,'l,'y,$20,'l,'o,'a,'d,'e,'d,'.,$0D,$0A,'P,'r,'e
      fcb 's,'s,$20,'a,'n,'y,$20,'k,'e,'y,$20,'t,'o,$20,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'.
      fcb $0D,$0A,$00,$00,$00,$00,$00,$00,$00
M0680 fcb '/,'d,'d,'/,'l,'s,'t,'/,'d,'c,'.,'o,'u,'t,$20,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M06C0 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0700 fcb $1B,'.,$FF,'4,$20,$20,$20,$20,$20,$20,$20,$20,'(,'P,'r,'e
      fcb 's,'s,$20,'a,'n,'y,$20,'k,'e,'y,$20,'t,'o,$20,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'),$FF,'t,$20,$20,$20,$FF,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0800 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0900 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,'",'a,'6
      fcb $FA,'p,'a,'6,$FA,'U,$01,'",'a,'@,$FA,'p,'a,'@,$FA,'U
      fcb $D4,$00,$00,$00,$01,'",'a,'N,$FA,'p,'a,'N,$FA,'U,$D4,$00
      fcb $00,$00,$DF,$C0,$00,'C,'a,'c,$F2,$B3,$03,$DF,$C0,$FA,'p,'a
      fcb 'c,$FA,'U,$94,$03,$01,$00,$E3,$00,$B9,':,$B7,'#,$CC,$FC,$BF
      fcb $1C,$0A,$B9,':,$F9,$A5,$84,$00,$00,$00,$00,$00,$01,'",'a,$88
      fcb $FA,$A0,$FA,'p,'a,$88,$FA,'U,$D0,'a,$E2,$00,$00,'c,$DF,$C0
      fcb 'a,$A6,$F3,'=,$D0,'a,$E2,$00,$00,'b,$DF,$C0,'a,$A6,$F3,'=
      fcb $FA,'p,'a,$A6,$FA,'U,$84,$03,'d,$00,$00,'c,$E3,$00,$B7,$EA
      fcb $CF,'*,$CE,$D7,$CD,'>,$CB,$DB,$B7,'#,$06,$00,$01,'",$B8,$80
      fcb 'a,$E2,$CB,$04,'a,$00,'a,$E2,$C3,$DA,$B3,$00,'),$00,$CA,$FF
      fcb $C4,$C5,$C4,'x,$BE,'b,$B8,$00,$B8,$80,'a,$E2,$FA,'p,'a,$E2
      fcb $FA,'3,$80,$03,'?,'Y,'X,$00,'2,$00,$8B,'=,$8A,$E6,'d,$80
M09F0 nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop

M0A05    lbra  M0A27

* Entry point for start routine in dynacalc program
* X contains the program counter a few instructions before the jump.
M0A08    lbra  M0A21

         pshs  x,a
         tfr   pc,x
         leax  >-$5C0F,x
         stx   >M0575,pcr
         lda   #$FF
         sta   >$0143,u
         puls  x,a
         bra   M0A74

M0A21    cmpd  #$0485
         beq   M0A6A
M0A27    lda   #$02
         leax  >M0A38,pcr
         ldy   #$FFFF
         os9   I$WritLn
         clrb
         os9   F$Exit

M0A38    fcc   "DYNACALC and DYNACALC.TRM are different versions."
         fcb   $0D

M0A6A    leax  >-$0B34,x
         stx   >M0575,pcr
         puls  u,y,x,b,a
M0A74 fcb $ED,$C9,$01,$C1,$1F,$B8,'L,$1F,$8B,$9F,'A,$DF
      fcb $1A,'0,$C9,$02,$80,$9F,$E9,$8E,$07,$00,$9F,'D,$0F,$ED,$0F,$EE
      fcb $0F,$19,$0F,$A7,'o,$8D,$FC,'(,$DE,$1A,'0,$C9,$09,$F0,$9F,$17
      fcb $1F,$14,'0,$C9,$03,'1,$9F,'0,'0,$88,'/,'O,'_,$10,'?,$8D
      fcb '0,$8D,$FB,'L,'O,'_,$ED,$1E,$A7,$1C,'C,'S,$ED,$1A,'0,$8D
      fcb $FB,$BE,$86,$02,$10,'?,$84,'$,$13,'0,$8D,$FB,$B3,$86,$02,$C6
      fcb $1B,$10,'?,$83,'$,$06,'o,$8D,$FB,$A6,$20,'5,$97,$12,$9E,'0
      fcb '_,$10,'?,$8D,'%,$20,$9E,'0,'_,$A6,$84,'',$13,'J,'&,$16
      fcb $96,$12,$C6,$02,$10,'?,$8D,'%,$0D,$10,'?,$88,'%,$08,$C6,$FF
M0B00 fcb $D7,$13,'&,$0D,$20,$04,'o,$8D,$FB,'v,$96,$12,$10,'?,$8F,$0F
      fcb $12
M0B11    ldx   <$0030
         os9   F$Time

      fcb '1,$06,'3,$8D,$FA,'_,$C6,$04,$A6,'?
      fcb $88,'Z,'I,$A8,$A2,$A7,$C2,'Z,'&,$F8,'1,$8D,$FA,'4,$A6,$01
      fcb 'J,$81,$0B,'#,$01,'O,$C6,$09,'=,'3,$8D,$01,$D3,'3,$CB,$C6
      fcb $09,$A6,$C0,$A7,$A0,'Z,'&,$F9,$86,$20,$A7,$A0,$E6,$02,$8D,$14
      fcb $CC,',,$20,$ED,$A1,$CC,'1,'9,$ED,$A1,$9E,'0,$E6,$84,$8D,$04
      fcb 'o,$A4,$20,$1C,'O,$CE,$07,$00,$DF,'D,$EE,$8D,$FA,$07,$AD,$C9
      fcb 'I,'P,$CE,$07,$00,$DF,'D,$DC,$1A,'3,$CB,$EC,'C,$ED,$A1,'9
      fcb $10,$AE,$8D,$F9,$F0,$AD,$A9,$0F,$FF,$E6,$01,'&,$04,$E6,$8D,$F5
      fcb 'g,$E7,$8D,$F5,'e,'o,$0C,'o,$0F,'o,$88,$10,'o,$88,$11,'o
      fcb $88,$16,'o,$04,'o,$07,$AD,$A9,$10,$0A,$CE,$01,$F1,$DF,$EB,$0F
      fcb $E0,$0F,$E8,$0F,$C4,'m,$8D,$F4,$FF,'*,$02,$0A,$0E,'m,$8D,$F5
      fcb '6,'&,$06,$86,$04,$A7,$8D,$F5,'.,$86,$90,$10,$AE,$8D,$F9,$A5
      fcb $AD,$A9,$0F,$86,$86,$FF,$97,$F0,$AD,$A9,$0F,$00,$86,$0F,'3,$8D
      fcb $F4,$FC,'0,$8D,$02,$10,$E6,$C6,$E7,$86,'J,'*,$F9,$DC,$0D,$83
      fcb $0A,'&,'D,'T,$DD,$BD,$C6,$04,'3,$8D,$01,$80,$AD,$A9,$0F,$1B
M0C00 fcb $AD,$A9,$1C,$A4,$0C,$BD,$0C,$BD,'Z,'&,$F1,$AD,$A9,$0F,$1B,$DC
      fcb $C1,$10,$83,$00,$01,'#,'K,$10,$9E,'A,$A6,$A4,$81,'-,'','2
      fcb $C6,$11,$9E,$E9,$A6,$A0,$81,$20,'',$20,$81,$0D,'',$09,'\,$D7
      fcb $ED,$A7,$85,$C1,'/,'&,$ED,$0D,$ED,'','','3,$8D,$01,$ED,$10
      fcb $AE,$8D,$F9,'1,$AD,$A9,$1C,$A4,$20,'6,$A6,$A0,$81,$20,'',$FA
      fcb '1,'?,$E6,'!,$C4,'_,$10,$83,'-,'H,'&,$DB,$A7,$8D,$F4,$9B
      fcb $20,$D5,$10,$AE,$8D,$F9,$0E,$AD,$A9,$1C,$A4,$C6,$04,$D7,'%,$AD
      fcb $A9,$1C,$B0,'&,$04,$0A,'%,'&,$F6,$0D,'C,'',$03,$17,'%,$80
      fcb $C6,$08,'0,$8D,$F4,'z,'3,$8D,$00,'f,$10,$9E,$1A,$A6,$80,'4
      fcb $16,$EC,$C1,'0,$AB,$A6,$E4,$A7,$84,$EC,$C1,'0,$AB,'5,$02,$A7
      fcb $84,'5,$14,'Z,'&,$E7,$AE,$8D,$F8,$CB,'1,$A9,$0F,$00,$EC,'&
      fcb $97,$1D,$0F,'},'D,'V,$06,'},$DD,'l,$EC,'&,'3,$AB,$9E,'A
      fcb '0,$01,'4,$10,$9E,$1A,'m,$89,$00,$FB,'5,$10,'&,$0D,'0,$1E
      fcb $0F,$1D,$10,$AE,$8D,$F8,$9E,$AD,$A9,'<,$AA,$12,$1F,$10,$DD,$1E
      fcb $93,$17,'D,'V,$D3,$17,$DD,'#,$EE,$8D,$F8,$89,'n,$C9,'P,$BA
      fcb $03,$81,$03,$AC,$03,$82,$03,$AD,$03,$83,$03,$AE,$03,$84,$03,$AF
M0D00 fcb $03,$AA,$03,$AA,$03,$A7,$03,$A7,$03,$80,$03,$80,$03,$80,$03,$80

MONTHS   fcc   "  January"
         fcc   " February"
         fcc   "    March"
         fcc   "    April"
         fcc   "      May"
         fcc   "     June"
         fcc   "     July"
         fcc   "   August"
         fcc   "September"
         fcc   "  October"
         fcc   " November"
         fcc   " December"
BANNER   fcc   "          **** DYNACALC ****"
         fcb   0
         fcc   "        Version Number - 4.8:5"
         fcb   0
         fcc   "Copyright (C) 1984 by Scott Schaeferle"
         fcb   0
         fcc   "    Customized for the "
TRMBANNR fcc   "ADDS Viewpoint   "
         fcb   0
      fcc "        (Press any key to continue)"
         fcb   0
      fcc "                    Loading "

      fcb $00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

M0F00 fcb $16,$00,'v,$16,$00,$07,'",$E1,$83,$E1,$16,$01,'9,$DE,$1A,$10
      fcb $AE,$C9,$05,'u,'3,$8D,$00,'D,$AD,$A9,$1C,$A4,$AD,$A9,$0A,$BF
      fcb $81,'Y,'',$04,'n,$A9,$1C,$89,$DE,$1E,$9E,'A,'0,$01,$9F,$1E
      fcb '4,'P,$03,$1D,$DC,'A,$93,$17,'D,'V,$D3,$17,$AD,$A9,'P,$BD
      fcb $1F,'0,$93,$C5,$DD,'l,$DC,$1E,$93,'l,$DD,$C5,$DC,'l,$0F,'}
      fcb 'D,'V,$06,'},$DD,'l,'5,'P,'n,$A9,'<,$A1

      fcc "Delete helps: Are you sure? "
      fcb $00

      fcb '4,$20,$10,$9E,$1A,$10,$AE
      fcb $A9,$05,'u,$E6,$84,$C1,$88,'&,$08,$0D,$E1,'',$04,$C6,$9A,$0F
      fcb $E1,$D7,'%,$DE,$B1,$96,$B3,$D6,'u,'4,'F,$17,$00,$A4,$86,$0A
      fcb $AD,$A9,$0A,$F5,'0,$8D,'!,$95,$D6,'%,':,$EC,$84,'3,$8D,$00
      fcb $C0,'3,$CB,$A6,$C0,'','3,$81,$11,'&,'#,$AD,$A9,'<,$9E,$AD
      fcb $A9,$0A,$D1,$E6,$1F,'\,$A6,$85,'4,$02,'o,$85,$AD,$A9,$0A,$BF
      fcb '5,$02,$81,$1B,'','G,'4,'@,$8D,'h,'5,'@,$20,$08,$AD,$A9
      fcb $0A,$F5,$81,$0D,'&,$CD,$86,$0A,$20,$F4,$AD,$A9,'<,$9E,$AD,$A9
      fcb $0A,$D1,$96,'%,$81,$80,'&,'%,$E6,$1F,'\,$A6,$85,$81,'@,'&
M1000 fcb $04,$C6,$9C,$20,$06,$81,'>,'&,$0A,$C6,$9E,$D7,'%,$AD,$A9,$0A
      fcb $BF,$20,$88,$84,'_,$81,'G,'&,$04,$C6,$84,$20,$EE,$8D,'#,$0F
      fcb $AC,$AD,$A9,$1C,$BC,$10,$9E,$1A,$10,$AE,$A9,$05,'u,$8E,$02,$00
      fcb $AD,$A9,$0A,$89,$AD,$A9,'<,$9E,'5,'F,$97,$B3,$DF,$B1,$D7,'u
      fcb '5,$A0,'n,$A9,$0A,$EC,$DE,$1A,$10,$AE,$C9,$05,'u,$CC,',,$20
      fcb $AD,$A9,$1C,$8C,$D6,'%,'0,$8D,$20,$F5,$C0,$C8,$C1,'5,'#,$02
      fcb $C6,'6,'X,':,$EC,$84,'3,$8D,$1F,$04,'3,$CB,$AD,$A9,'A,'v
      fcb '9

* Texts are set for an 80-column display

HELPS fcc   "A  set Attributes        "
 fcc  "                 Hit @ for help with FUNCTIONS"
 fcb   $0D
 fcc   "B  Blank current cell    "
 fcc  "                     > for help with ERRORS"
 fcb   $0D
 fcc   "C  Clear entire worksheet"
 fcc  "                     G for general help"
 fcb   $0D
 fcc   "D  Delete current column or row"
 fcb   $0D
 fcc   "E  Edit contents of current cell"
 fcb   $0D
 fcc   "F  set Format of current cell"
 fcb   $0D
 fcc   "I  Insert new column or row at current position"
 fcb   $0D
 fcc   "K  enter Keysaver mode"
 fcb   $0D
 fcc   "L  Locate specified label "
 fcc   /(?="Wild card", @="Don't ignore case")/
 fcb   $0D
 fcc   "M  Move column or row to new position"
 fcb   $0D
 fcc   "P  Print all or portion of worksheet to"
 fcc   " system printer or textfile"
 fcb   $0D
 fcc   "Q  Quit DYNACALC and go to Sleep or to OS-9"
 fcb   $0D
 fcc   "R  Replicate cell or group of cells to new location"
 fcb   $0D
 fcc   "S  call System function"
 fcb   $0D
 fcc   "T  set column or row Titles"
 fcb   $0D
 fcc   "W  adjust display Window(s)"
 fcb   $0D
 fcb   $00
H.ATTRS fcc   "Set Attributes:"
 fcb   $0D
 fcb   $0A
 fcc   "B  toggles Bell on/off (default = on)"
 fcb   $0D
 fcc   "D  toggles Degree/radian mode (default = degrees)"
 fcb   $0D
 fcc   "G  allows changing Graph character (default = #)"
 fcb   $0D
 fcc   "H  deletes all Help messages & increases user space"
 fcb   $0D
 fcc   "L  toggles Label entry mode flag (default = off)"
 fcb   $0D
 fcc   "M  re-write (Modify) screen"
 fcb   $0D
 fcc   "O  toggles Column/Row calculation Order (default = C)"
 fcb   $0D
 fcc   "P  allows changing Printer/textfile parameters"
 fcb   $0D
 fcc   "R  toggles Auto/Manual Recalculate feature (default = A)"
 fcb   $0D
 fcc   "S  reports Size of worksheet"
 fcb   $0D
 fcc   "T  toggles the Type protection feature (default = off)"
 fcb   $0D

 fcc   "W  allows changing column Width(s)"
 fcb   $0D
 fcb   $00

H.DEL fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Delete column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  deletes current Column"
 fcb   $0D
 fcc   "R  deletes current Row"
 fcb   $0D
 fcb   $00

H.CFMT fcc   "Set Format of current cell:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Continuous - characters repeated throughout cell"
 fcb   $0D
 fcc   "D  Default - uses window format"
 fcb   $0D
 fcc   "G  General - free-format (labels left, numbers right)"
 fcb   $0D
 fcc   "I  Integer - rounds DISPLAY to nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number to left of cell"
 fcb   $0D
 fcc   "P  Plot - uses cell's integer value as number of"
 fcc   " graph chars. to print"
 fcb   $0D
 fcc   "R  Right justify - forces label to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to nearest cent"
 fcb   $0D
 fcb   $00

H.INS fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Insert new column or row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  inserts new blank Column at current position"
 fcb   $0D
 fcc   "R  inserts new blank Row at current position"
 fcb   $0D
 fcb   $00

H.QUIT fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Quit:"
 fcb   $0D
 fcb   $0A
 fcc   "O  leave DYNACALC and return to OS-9"
 fcb   $0D
 fcc   "S  puts computer to Sleep until any key is struck"
 fcb   $0D
 fcb   $00

H.SYSTM fcc   "System:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Change the current directory"
 fcb   $0D
 fcc   "L  Load worksheet from disk - overlays current sheet"
 fcb   $0D
 fcc   "S  Save current worksheet to disk"
 fcb   $0D
 fcc   "   Save and Load both default to .cal in current directory"
 fcb   $0D
 fcb   $0A
 fcc   "X  eXecute OS-9 command"
 fcb   $0D
 fcb   $0A
 fcc   "#  data file save/load - for data exchange"
 fcb   $0D
 fcc   "   both default to the current directory"
 fcb   $0D
 fcb   $00

H.SAVE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Save data:"
 fcb   $0D
 fcb   $0A
 fcc   "L  Load labels and CALCULATED Values from disk"
 fcb   $0D
 fcb   $0A
 fcc   "S  Save labels and CALCULATED Values to disk"
 fcb   $0D
 fcb   $00

H.TITLE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Titles:"
 fcb   $0D
 fcb   $0A
 fcc   "B  set up Both horizontal and vertical titles"
 fcb   $0D
 fcc   "H  set up row(s) above cursor as Horizontal title area"
 fcb   $0D
 fcc   "N  No titles"
 fcb   $0D
 fcc   "V  set up column(s) to left of cursor as Vertical title area"
 fcb   $0D
 fcb   $00

H.WINDOW fcc   "Windows:"
 fcb   $0D
 fcb   $0A
 fcc   "D  toggle value/formula Display flag (defaults to value)"
 fcb   $0D
 fcc   "F  sets default Format of all cells in current window"
 fcb   $0D
 fcc   "H  divides screen Horizontally into two windows at current location"
 fcb   $0D
 fcc   "N  No division - returns display to single window"
 fcb   $0D
 fcc   "S  Synchronizes motion of two windows"
 fcb   $0D
 fcc   "U  Unsynchronizes motion of two windows (default)"
 fcb   $0D
 fcc   "V  divides screen Vertically into two windows at current location"
 fcb   $0D
 fcb   $00

H.WFMT fcc   "Set default format of current window:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Continuous - characters repeated throughout cell"
 fcb   $0D
 fcc   "D  Default - general format (see)"
 fcb   $0D
 fcc   "G  General - free-format (labels left, numbers right)"
 fcb   $0D
 fcc   "I  Integer - rounds DISPLAY to nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number to left of cell"
 fcb   $0D
 fcc "P  Plot - uses cell's integer value as number of graph chars. to print"
 fcb   $0D
 fcc   "R  Right justify - forces label to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to nearest cent"
 fcb   $0D
 fcb   $00

H.PRINT fcc   "Printer attributes:"
 fcb   $0D
 fcb   $0A
 fcc   "B  toggles Border flag on/off (defaults to off)"
 fcb   $0D
 fcc   "C  Clears the printer file name"
 fcb   $0D
 fcc   "L  sets Length of page (defaults to 58 lines)"
 fcb   $0D
 fcc   "P  toggles Pagination flag on/off (defaults to on)"
 fcb   $0D
 fcc   "S  sets the Spaces between lines"
 fcb   $0D
 fcc   "W  sets Width of page (defaults to 80 characters)"
 fcb   $0D
 fcb   $0A
 fcc   "  All of these default values may be permanently"
 fcb   $0D
 fcc   '  modified by the user, using "Install.dc"'
 fcb   $0D
 fcb   $00

H.WIDTH fcb   $0A
 fcb   $0A
 fcc   "Width:"
 fcb   $0D
 fcb   $0A
 fcc   "C  allows changing width of current Column"
 fcb   $0D
 fcc   "   (defaults to Window value)"
 fcb   $0D
 fcb   $0A
 fcc "W  allows changing default width of all columns in current Window"
 fcb   $0D
 fcc   "   (defaults to 9 characters)"
 fcb   $0D
 fcb   $00

H.MOVE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Move column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "A  Sort columns/rows in the given range in Ascending order"
 fcb   $0D
 fcc   "D  Sort columns/rows in the given range in Descending order"
 fcb   $0D
 fcc   "M  Manually move column/row"
 fcb   $0D
 fcb   $00

H.ORDER fcb   $0A
 fcb   $0A
 fcc   "C  loads/saves data by Column"
 fcb   $0D
 fcb   $0A
 fcc   "D  loads/saves data by Default order"
 fcb   $0D
 fcb   $0A
 fcc   "R  loads/saves data by Rows"
 fcb   $0D
 fcb   $00

H.TRIG fcc   "Trigonometric:    @SIN      @ASIN       @PI (3.14...)"
 fcb   $0D
 fcc   "                  @COS      @ACOS "
 fcb   $0D
 fcc   "                  @TAN      @ATAN "
 fcb   $0D
 fcb   $0A
 fcc   "Logarithmic:      @LOG(x)      logarithm of x to base 10"
 fcb   $0D
 fcc "                  @LN(x)       logarithm of x to base e (2.718...)"
 fcb   $0D
 fcc   "                  @EXP(x)      e raised to x power"
 fcb   $0D
 fcc   "                  @SQRT(x)     square root x"
 fcb   $0D
 fcb   $0A
 fcc   "General:          @ABS(x)      absolute value of x"
 fcb   $0D
 fcc   "                  @INT(x)      integer part of x"
 fcb   $0D
 fcc   "                  @RND(x)      random number, 0 to x-1"
 fcb   $0D
 fcc   "                  @ROUND(d,x)  x rounded to nearest d"
 fcb   $0D
 fcc "                               (d must be even power of 10)"
 fcb $0D
 fcb $0A
 fcc "               Hit any key to see page 2"
 fcb $11
 fcc "Series:   @COUNT(x...y)    number of cells in range x...y"
 fcb $0D
 fcc "          @SUM(x...y)      sum of values of cells in range x...y"
 fcb $0D
 fcc "          @AVERAGE(x...y)  average value of cells in range x...y"
 fcb   $0D
 fcc "          @STDDEV(m,x...y) standard deviation of cells in range x...y,"
 fcb   $0D
 fcc   "                           m sets method:  <0 = population;"
 fcc   "  >=0 = sample"
 fcb   $0D
 fcc   "          @MIN(x...y)      least value of cells in range x...y"
 fcb   $0D
 fcc   "          @MAX(x...y)      greatest value of cells in range x...y"
 fcb   $0D
 fcc   "          @NPV(r,x...y)    Net Present Value of cells"
 fcc   " in range x...y at rate r"
 fcb   $0D
 fcc   "Indexing: @CHOOSE(n,x...y) value of nth cell in range x...y"
 fcb   $0D
 fcc   "          @LOOKUP(n,x...y,z) '>' search - z optional - see manual"
 fcb   $0D
 fcc   "          @INDEX(n,x...y,z)  '=' search - z optional - see manual"
 fcb   $0D
 fcc   "Error:    @ERROR           causes >ER< message (general use)"
 fcb   $0D
 fcc   "          @NA              causes >NA< message (not available)"
 fcb   $0D
 fcb   $0A
 fcc "               Hit any key to see page 3"
 fcb $11
 fcc "Logical:  @NOT(x)       complement of x"
 fcb   $0D
 fcc "          @AND(x...y)   true if all cells in range x...y true"
 fcb   $0D
 fcc "          @OR(x...y)    true if any cells in range x...y true"
 fcb   $0D
 fcc "          @EOR(x,y)     true if x & y are different"
 fcb   $0D
 fcb   $0A
 fcc "          @IF(c,t,f)    if c=true, return t; else f"
 fcb   $0D
 fcc "            @IF can return values,labels, or logical"
 fcb $0D,$0A
 fcc "          @ISNA(X)      true if cell x is >NA<"
 fcb   $0D
 fcc "          @ISERROR(x)   true if cell x has any error"
 fcb $0D,$0A
 fcc "          @TRUE         returns logical true"
 fcb   $0D
 fcc "          @FALSE        returns logical false"
 fcb $0D,$0A
 fcc   "                   Hit any key to exit Help"
 fcb $00

H.ARIT fcc   "Arithmetic operators: x+y  adds x and y"
 fcb   $0D
 fcc   "                      x-y  subtracts y from x"
 fcc   "  (use 0-x for monadic minus)"
 fcb   $0D
 fcc   "                      x*y  multiplies x by y"
 fcb   $0D
 fcc   "                      x/y  divides x by y"
 fcb   $0D
 fcc   "                      x^y  raises x to y power"
 fcb   $0D
 fcb   $0A
 fcc   "Logical operators:    x=y  true if x equals y"
 fcb $0D
 fcc   "                      x<>y true if x doesn't equal y"
 fcb $0D
 fcc   "                      x>y  true if x is greater than y"
 fcb $0D
* Incorrect in original
 fcc   "                      y<x  true if x is less than y"
 fcb $0D
 fcc   "                      x>=y,x=>y true if x is greater than or equal to y"
 fcb $0D
 fcc   "                      x<=y,x=<y true if x is less than or equal to y"
 fcb $0D,$0A
 fcc "               Hit any key to see page 2"

 fcb $11
 fcc "Arithmetic operators operate on and return numbers only."
 fcb $0D
 fcc "Logical operators operate on numbers or labels and return"
 fcb $0D
 fcc "logical (True/False) values only."
 fcb $0D,$0A
 fcc   "Maximum number of terms (pending additions) is 11"
 fcb   $0D
 fcb   $0A
 fcc   "Parentheses within terms may be nested to any depth"
 fcb   $0D
 fcb   $0A
 fcc   "To enter expression, first character must not be alphabetic"
 fcb   $0D
 fcc   "   For example, to enter A1+A2, type '+A1+A2'"
 fcb   $0D
 fcb   $0A
 fcc   "To enter numeric as a label, use leading single-quote (')"
 fcb   $0D
 fcb   $0A
 fcc   "                  Hit any key to exit Help"
 fcb   $00
H.ERRMSG fcc   "       DYNACALC Error Messages"
 fcb   $0D
 fcb   $0A
 fcc   "    >AE<  Bad argument error"
 fcb   $0D
 fcc   "    >D0<  Divide by zero attempted"
 fcb   $0D
 fcc   "    >ER<  General purpose error"
 fcb   $0D
 fcc   "    >EX<  Exponent too large"
 fcb   $0D
 fcc   "    >HO<  Holder overflow error"
 fcb   $0D
 fcc   "    >LG<  Logical error"
 fcb   $0D
 fcc   "    >LN<  Negative or zero logarithm attempted"
 fcb   $0D
 fcc   "    >NA<  Not available"
 fcb   $0D
 fcc   "    >NR<  Negative root attempted"
 fcb   $0D
 fcc   "    >OV<  Arithmetic overflow error"
 fcb   $0D
 fcc   "    >RE<  Reference error"
 fcb   $0D
 fcc   "    >RN<  Range error"
 fcb   $0D
 fcc   "    >SN<  Syntax error"
 fcb   $0D
 fcb   $0A
 fcc   "      Hit any key to exit Help"
 fcb   $0D
 fcb   $00


ERRMSGS equ *
ERROR01  fcc   "Path table full."
 fcb   $00
ERROR02  fcc   "Illegal path number."
 fcb   $00

ERRORXX equ *
  fcc "See description."
 fcb   $00

ERROR07  fcc   "Module directory full."
 fcb   $00
ERROR08  fcc   "Memory full."
 fcb   $00
ERROR10  fcc   "Module busy."
 fcb   $00
ERROR12  fcc   "End of file."
 fcb   $00
ERROR15  fcc   "No permission- access denied."
 fcb   $00
ERROR16  fcc   "Bad path name."
 fcb   $00
ERROR17  fcc   "The file/device cannot be found."
 fcb   $00
ERROR22  fcc   "Link to a non-existing module."
 fcb   $00
ERROR23  fcc   "Sector number out of range."
 fcb   $00
ERROR30  fcc   "Process table full."
 fcb   $00
ERROR35  fcc   "Non-executable module."
 fcb   $00
ERROR38  fcc   "Write protect."
 fcb   $00
ERROR39  fcc   "Checksum error."
 fcb   $00
ERROR40  fcc   "Read error."
 fcb   $00
ERROR41  fcc   "Write error."
 fcb   $00
ERROR42  fcc   "Device not ready."
 fcb   $00
ERROR43  fcc   "Seek error."
 fcb   $00
ERROR44  fcc   "Media full."
 fcb   $00
ERROR45  fcc   "Device/media type mismatch."
 fcb   $00
ERROR46  fcc   "Device busy."
 fcb   $00
ERROR47  fcc   "Device/media ID changed."
 fcb   $00
ERROR50  fcc   "Unknown error code."
 fcb   $00

* Offsets to error codes
ERRTBL   fdb   ERROR01-ERRMSGS
 fdb   ERROR02-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR07-ERRMSGS
 fdb   ERROR08-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR10-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR12-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR15-ERRMSGS
 fdb   ERROR16-ERRMSGS
 fdb   ERROR17-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR22-ERRMSGS
 fdb   ERROR23-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR30-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR35-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR23-ERRMSGS
 fdb   ERROR38-ERRMSGS
 fdb   ERROR39-ERRMSGS
 fdb   ERROR40-ERRMSGS
 fdb   ERROR41-ERRMSGS
 fdb   ERROR42-ERRMSGS
 fdb   ERROR43-ERRMSGS
 fdb   ERROR44-ERRMSGS
 fdb   ERROR45-ERRMSGS
 fdb   ERROR46-ERRMSGS
 fdb   ERROR47-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR50-ERRMSGS

HELPTBL  fdb   $0000
 fdb   H.ATTRS-HELPS
 fdb   H.ARIT-HELPS
 fdb   H.SAVE-HELPS
 fdb   H.CFMT-HELPS
 fdb   H.WINDOW-HELPS
 fdb   H.TITLE-HELPS
 fdb   H.SYSTM-HELPS
 fdb   H.WIDTH-HELPS
 fdb   H.QUIT-HELPS
 fdb   H.PRINT-HELPS
 fdb   H.DEL-HELPS
 fdb   H.INS-HELPS
 fdb   H.WFMT-HELPS
 fdb   H.TRIG-HELPS
 fdb   H.ERRMSG-HELPS
 fdb   H.MOVE-HELPS
 fdb   H.ORDER-HELPS
ENDHELP equ *
 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
