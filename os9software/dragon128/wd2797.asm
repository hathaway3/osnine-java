 nam WD2797
 TTL Floppy disk driver with bootstrap

****************************************
*
* Floppy disc driver with bootstrap routine
* for the Western Digital 2797 disc controller.
*
* For the Dragon 128 computer.
*
* last mod 21/12/83
*
****************************************

****************************************
*
* The boot routine is an extension to
* OS-9 standard disc driver capabilities.
* The entry point is the 7th entry in the
* branch table, The bootstrap routine expects
* the Y register to contain the address of
* the Device Descriptor for the boot device.
*
* This driver can handle both mini and
* full-size drives, provided the appropiate
* bit is set in the Device Descriptor.
*
* This driver can handle discs formatted with
* 128 byte sectors. The first sector on each
* track must be sector 1. The Device
* Descriptor 'sectors per track' entries must
* contain the number of sectors per track
* divided by two, and bit 5 of the DD.TYP
* entry must be set, (this is an extension
* to the standard OS-9 definitions for this
* byte). Bit 6 should also be set, to indicate
* Non-OS9 Format.
*
*
* Written by Paul Dayan of Vivaway Ltd
*
* History:
* Written 3rd November 1983
*
****************************************
    
 use defsfile

 TTL Floppy disk driver with bootstrap

Drvcnt SET 4 Four Drives
FULLSIZE equ 1 include 8" drives
DDTRACK0 equ 1 single and double density on track 0
DBLTRACK equ 1 single and double track density
TRYBOTH equ 0 get track 0 density info from PD
EXTFMT equ 1 multiple formats
HLFSECT equ 1 256 and 128 byte sectors
DBLSIDE equ 1 single and double sided
STEPIN equ 1 step in before restore

 ifeq EXTFMT
 endc


 org 0
u0000    rmb   1
XV.Port    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   1
XV.Wake    rmb   1
u0006    rmb   2
u0008    rmb   1
u0009    rmb   1
u000A    rmb   2
u000C    rmb   1
u000D    rmb   1
u000E    rmb   1
XDrvbeg    rmb   1
u0010    rmb   1
u0011    rmb   1
u0012    rmb   2
u0014    rmb   2
u0016    rmb   1
u0017    rmb   1
u0018    rmb   1
u0019    rmb   1
u001A    rmb   2
u001C    rmb   1
u001D    rmb   24
u0035    rmb   2
u0037    rmb   2
u0039    rmb   23
u0050    rmb   48
u0080    rmb   38
u00A6    rmb   1

 ORG Drvbeg reserve RBF static storage
 RMB Drvmem*Drvcnt drive tables
V.Cdrv RMB 2 address of current drive table
V.Vbuff rmb   2
V.Wrtf    rmb   1
V.Wait    rmb   1
V.Active rmb   1
V.Status rmb   1
V.T0stk rmb   2
V.Stk rmb   2
u00B3  rmb   2
V.Lsn    rmb   2
V.Fmt    rmb   1
V.TwoStp rmb   1
V.Timer rmb 1
V.Cmd rmb 1
V.Sector rmb 1
V.CrTrk    rmb   1
V.Buff rmb 2
V.Bytc rmb 2
V.Step rmb   1
V.Track rmb   1
V.Select rmb 1
V.NewTrk rmb 1
 ifne DBLSIDE
V.Side rmb 1
 endc
V.Freeze    rmb   1
V.DDTr0    rmb   1

 ifne DDTRACK0
DDTr0 set 16
 endc
Dskmem equ .
Btmem equ Dskmem-V.Wrtf Memory for bootstrap
* Controller commands
*
F.WRIT equ $A8 write sector
F.READ equ $88 read sector
F.SEEK equ $18 seek
F.STPI equ $48 step in
F.REST equ $08 restore
F.WRTR equ $F0 write track
F.TERM equ $D0 forced terminate
*
* Controller registers
*
 org 0
STTREG equ . status register
CMDREG rmb 1 command register
TRKREG rmb 1 track register
SECREG rmb 1 sector register
DATREG rmb 1 data register
*
* PIA equates
*
SELREG equ A.DskSel select register
INTPIA equ DAT.Task interrupt port data reg

Type set drivr+objct
Revs set reent+1

 mod   Dkend,Dknam,Type,Revs,Dkent,Dskmem
 FCB $FF

Dknam fcs 'wd2797'
 fcb 1 Edition

*Entry Table
Dkent lbra Idisk
 lbra Read
 lbra Write
 lbra Gstat
 lbra Pstat
 lbra Term
 lbra Boot

Fdcpol   fcb  $00 no flip bits
         fcb  $80
         fcb  $80

Maxcyl equ 40
Scttrk equ 18
Trkcyl equ 1
Sctcyl equ Scttrk*Trkcyl
Maxsct equ (Maxcyl*Sctcyl)-1

* Initialise Controller And Storage
* Input: Y=Device Descriptor Pointer
*        U=Global Storage Pointer
Idisk   lda   #Drvcnt
         sta   V.Ndrv,u
         leax  Drvbeg,u
         stx   >V.Cdrv,u
 pshs U Save "u" we need it later
         leau  >V.Wrtf,u
         lbsr  Getdd
 ldd #256 "d" passes memory req size
         os9   F$SRqMem Request 1 pag of mem
         bcs   Ierr
         tfr   u,d
         puls  u
         std   >V.Vbuff,u
         ldd   #$FCC1
         leax  <Fdcpol,pcr
         leay  Fdcsrv,pcr
         os9   F$IRQ
         bcs   Init30
         inc   >V.Wait,u
         ldx   #INTPIA
         lda   ,x
         pshs  cc
         orcc #IntMasks
         lda   1,x
         ora   #3
         sta   $01,x
         puls  cc
         leax  >TimSrv,pcr
         os9   F$Timer
         bcs   Init30
         leax  Drvbeg,u
         ldb   #$04 #DriveCnt
         lda   #$FF
INILUP    sta   $01,x
         sta   <$15,x
 leax DRVMEM,X next
 decb
         bne   INILUP
         clrb
Init30 rts
Ierr    puls  pc,u

 pag
*************************************************************
*
* Read Sector Command
*
* Input: B = Msb Of Logical Sector Number
*        X = Lsb'S Of Logical Sector Number
*        Y = Ptr To Path Descriptor
*        U = Ptr To Global Storage
*
* Output: 256 Bytes Of Data Returned In Buffer
*
* Error: Cc=Set, B=Error Code
*
Read    bsr   Rngtst
         bcs   Init30
         ldx   V.Lsn,u
         bne   Read1
         bsr   Read1
         bcs   Init30
 ldx PD.BUF,Y Point to buffer
         pshs  y,x
         tst   >V.Freeze,u
         bne   Read2
         ldy   >V.Cdrv,u
         ldb   #$14
Copytb    lda   b,x
         sta   b,y
         decb
         bpl   Copytb
Read2    clr   >V.Freeze,u
         puls  pc,y,x
Read1    leax  >Rsect,pcr

* Fall Through To Call Controller Subroutine

* Call Controller Subroutine
* Get Controller Pointer, Adjust Static Storage
* Pointer, And Call Routine

* Input: U=Static Storage Pointer

Call pshs u,y
         ldy   V.Port,u
         leau  >V.Wrtf,u
         jsr   ,x
         puls  pc,u,y

Write    bsr   Rngtst
         bcs   Return
         leax  >Wsect,pcr
         bsr   Call
         bcs   Return
         lda   <$28,y
         bne   Return
         ldd   $08,y
         pshs  b,a
         ldd   >V.Vbuff,u
         std   $08,y
         bsr   Read
         puls  x
         stx   $08,y
         rts

 pag
**************************************************************
*
* Convert Logical Sector Number
* To Rngtstal Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number
*  Output: A = Rngtstal Track Number
*          Sector Reg = Rngtstal Sector Number
*  Error:  Carry Set & B = Error Code
*
Rngtst    tstb
         bne   Rngerr
         stx   V.Lsn,u
         bsr   Getdrv
         bitb  #$40 Non-Os9 Format?
         beq   Rng4
         anda  #$F8
         pshs  a
         lda   PD.SID,y
         deca
         puls  a
         beq   L010C
         ora   #$01
L010C    ldb   PD.DNS,y
         bitb  #$01
         beq   L0115
         ora   #$02
L0115    sta   >V.Fmt,u
         ldd   PD.SCT,y
         std   >V.Stk,u
         lda   PD.SID,y
         deca
         beq   L0127
         lslb
L0127    lda   <$26,y
         mul
         std   $01,x
         bra   Rng5
Rng4 equ *
 clra
         ldb   $03,x
         std   >V.Stk,u
Rng5    ldd   V.Lsn,u
         cmpd  $01,x
         bhi   Rngerr
         ldd   $08,y
         std   >V.Buff,u
         ldd   PD.T0S,y
         std   >V.T0stk,u
         clrb
         rts

Rngerr comb
 ldb #E$SECT Error: bad sector number
Return    rts
 pag
***************************************************************
*
* Getdrv Drive
*
*  Input: (U)= Pointer To Global Storage
*
* Output: Curtbl,U=Current Drive Tbl
*         Curdrv,U=Drive Number
*
Getdrv    ldx   >V.Cdrv,u
         beq   Get5
         lda   >V.CrTrk,u
         sta   <$15,x
Get5    lda   PD.DRV,y
         sta   >u00B3,u
 ldb #DRVMEM
         mul
         leax  Drvbeg,u
         leax  d,x
         stx   >V.Cdrv,u
         lda   <$15,x
         sta   >V.CrTrk,u
         lda   PD.STP,y
         anda  #$03
         sta   >V.Step,u
         ldb   PD.DNS,y
         andb  #$02
         stb   >V.TwoStp,u
         lda   <$10,x
         ldb   PD.TYP,y
         andb  #$20
         stb   >V.DDTr0,u
         ldb   PD.TYP,y
         bitb  #$40
         bne   L01A5
         bita  #$04
         beq   L01A5
         clr   >V.TwoStp,u
L01A5    bitb  #$01
         beq   L01AB
         ora   #$80
L01AB    bitb  #$08
         beq   L01B1
         ora   #$08
L01B1    sta   >V.Fmt,u
         rts

Gstat bra Pstat1

 pag
************************************************************
*
* Put Status Call
*
*
*
Pstat pshs U,Y
 ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore call?
 beq Rstor ..yes; do it.
 cmpb #SS.WTrk Write track call?
 beq Wtrk ..yes; do it.
 cmpb #SS.FRZ Freeze dd. info?
 beq SetFrz Yes; ....flag it.
 cmpb #SS.SPT Set sect/trk?
 beq SetSpt Yes; ....set it.
         puls  u,y
Pstat1    comb
         ldb   #$D0
         rts

SetFrz    ldb   #$01
         stb   >V.Freeze,u
         clrb
         puls  pc,u,y

SetSpt    ldx   $04,x
         pshs  x
         lbsr  Getdrv
         puls  b,a
         std   $03,x
         clrb
         puls  pc,u,y

Rstor    lbsr  Getdrv
         ldx   >V.Cdrv,u
         clr   <$15,x
         leax  >Brstor,pcr
         lbsr  Call
         puls  pc,u,y

*****************************************************************
*
* Write Full Track
*  Input: (A)=Track
*         (Y)=Path Descriptor
*         (U)=Global Storage
*
Wtrk lda R$Y+1,x
         ldb   $09,x
         pshs  b,a
         lbsr  Getdrv
         ldd   <$29,y
         std   >V.Stk,u
         ldd   <$2B,y
         std   >V.T0stk,u
         ldd   #$0000
         std   V.Lsn,u
         puls  b,a
         sta   <$10,x
         stb   >V.Track,u
         anda  #$01
         sta   >V.Side,u
         lbsr  Getdrv
         ldd   #41*256
         os9   F$SRqMem
         bcs   Wtrk8
         ldx   <u0050
         lda   $06,x
         ldb   D.SysTsk
         ldy   ,s
         ldx   $06,y
         ldx   $04,x
         ldy   #41*256
         os9   F$Move
         leax  ,u
         ldu   $02,s
         stx   >V.Buff,u
         leau  >V.Wrtf,u
         ldy   V.Port-V.Wrtf,u get port address
         lbsr  Select
         bcs   Wtrk8
         lbsr  Settrk
         ldd   #41*256
         std   <u0014,u
         lda   #$F0
         sta   Drvbeg,u
         lda   #$01
         sta   ,u
         lbsr  IssXfr
         pshs  b,cc
         ldu   <u0012,u
         ldd   #41*256
         os9   F$SRtMem
         puls  b,cc
Wtrk8    puls  pc,u,y

* Terminate Device Usage
*
* Input: U=Static Storage

Term    pshs  u
         ldu   >V.Vbuff,u
         ldd   #$0100
         os9   F$SRtMem
         puls  u
         ldx   #INTPIA
         lda   1,x
         anda  #$FE
         sta   $01,x
         ldx   #$0000
         os9   F$IRQ
         ldx   #0
         os9   F$Timer
         clrb
         rts




****************************************
*
* Bootstrap Routine, And Disk Controller
* Interface Routines
*
****************************************

Boot pshs  u,y,x,b,a
 leas -Btmem,s Get Global Storage
 ldd #256 Get A Page
 os9 F$SRqMem
 bcs Bterr2 Skip If None
 stu V.Buff-V.Wrtf,S Set Buffer Pointer
 leau ,S Set Storage Pointer
 clr V.Wait-V.Wrtf,u can't sleep
Boot40 clra
 clrb
 std V.Lsn-V.Wrtf,u Logical Sector 0
 ldy Btmem+4,S Get Device Descriptor Pointer
 bsr Getdd Grab parameters
 lda INTPIA+1 get control reg
 ora #1 enable disk controller interrupts
 sta INTPIA+1
 lbsr Brstor Restore Drive
 bcs Boot40 Skip If Error - Try Again
 lbsr Rsect Read Sector 0
 bcs Boot40 Try Again On Error
 ldx V.Buff-V.Wrtf,u Get Buffer Pointer
 ifne EXTFMT
 lda Dd.Fmt,X Get Disk Format
 ifne FULLSIZE
 ora V.Fmt-V.Wrtf,u Set Drive Type In Format
 sta V.Fmt-V.Wrtf,u Set It
 endc
 ifne DBLTRACK
 bita #4 double track disk?
 beq Boot20 ..no
 clr V.TwoStp-V.Wrtf,u can't need double stepping
Boot20 clra
 ldb Dd.Tks,x Get Sects/Trk
 std V.Stk-V.Wrtf,u Set It
 endc
 ldd Dd.Bsz,x Get Boot File Size
 std Btmem,u
 ldd #256 Return Page
 leau  ,x
 ldx DD.Bt+1,x Get Start Sector Number
 os9 F$SRtMem
 ldd Btmem,S was there a boot file?
 beq Noboot
 ifeq LEVEL-1
 os9 F$SRqMem Get memory for bootstrap
 else
 os9 F$BtMem Get memory for bootstrap
 endc
 bcs Bterr2 Skip If None
 stu Btmem+2,S Return Address To Caller
 stu V.Buff-V.Wrtf,s Set Buffer Pointer
 leau ,S Get Global Storage Pointer
Boot10 pshs x,a Save Pages And Sector Number
 stx V.Lsn-V.Wrtf,u Set Sector Number
 bsr Rsect Read Sector
 bcs Bterr1 Skip If Error
 puls x,a Retrieve Pages And Sector Number
 leax 1,x Next Sector
 inc V.Buff-V.Wrtf,u Move Buffer Pointer
 deca Done All Pages
 bne Boot10 Loop If Not
 leas Btmem,s Return Global Storage
 clrb No Error, Clear Carry
 puls pc,u,y,x,b,a Return, With Boot Address In D
Noboot comb Set Carry
 ldb #E$BTYP No Boot File
 bra Bterr2
Bterr1 leas 3,s Pitch Pages And Sector Number
Bterr2 leas Btmem+2,S Pitch Global And D
 puls pc,u,y,x

* Get Parameters From Device Descriptor
Getdd    leay $12,y
         lda   $01,y
         sta   u0008,u
         lda   $02,y
         anda  #$03
         sta   <u0016,u
 ifne EXTFMT
         lda   $03,y
         clrb
 ifne FULLSIZE
         bita  #1
         beq   Getdd1
         ldb   #$80
 endc

Getdd1 equ *
 ifne DBLTRACK
    lda   $04,y
         anda  #$02
         sta   u000D,u
 endc
 ifne DDTRACK0
 ifeq TRYBOTH
         lda   $03,y
         anda  #$20
         sta   <u001C,u
 endc
 endc
         stb  V.Fmt-V.Wrtf,u
         ldd   $0B,y
         std  V.T0stk-V.Wrtf,u
 endc
         ldy   -$03,y
         lda   ,y
         rts

* Read Sector Routine
*

Rsect    clr   V.Wrtf-V.Wrtf,u
         lda   #$88
         sta   V.Cmd-V.Wrtf,u

* Set up for Read/Write Transfer
Xfr    lda   #$DB
         pshs  a
         lda   u000C,u
         bita  #$08
         beq   Xfr1
         ldd   #$0080
         std   <u0014,u
         bsr   Xfr2
         bcs   Xfr70
         ldd  V.Buff-V.Wrtf,u
         leas  $01,s
         pshs  b,a
         addd  #$0080
         std   V.Buff-V.Wrtf,u
         lda   #$DB
         pshs  a
         bsr   Xfr2
         puls  x
         stx   V.Buff-V.Wrtf,u
         bra   Xfr70
Xfr1    ldd   #$100
         std  V.Bytc-V.Wrtf,u
Xfr2    ldd  V.Lsn-V.Wrtf,u
         bne   Xfr20
Xfr10    lbsr  Brstor
Xfr20    bsr   Select
         bcs   Xfr70
         clr   V.Track-V.Wrtf,u
         clr   V.Side-V.Wrtf,u
         ldd   V.Lsn-V.Wrtf,u
         cmpd  V.T0stk-V.Wrtf,u
         bcs   Xfr40
         subd  V.T0stk-V.Wrtf,u
Xfr30    inc   V.Track-V.Wrtf,u
 ifne EXTFMT
         subd  V.Stk-V.Wrtf,u
         bcc   Xfr30
         addd  V.Stk-V.Wrtf,u
 else
 endc
 ifne DBLSIDE
         lda   V.Fmt-V.Wrtf,u
         bita  #$01
         beq   Xfr40
         lsr   V.Track-V.Wrtf,u
         rol   V.Side-V.Wrtf,u
 endc
 ifne HLFSECT
Xfr40    lda   V.Fmt-V.Wrtf,u
         bita  #$08
         beq   Xfr90
         lslb
         decb
         bra   Xfr95
 endc
Xfr90 equ *
 ifne DDTRACK0
         tst  V.DDTr0-V.Wrtf,u
         beq   Xfr95
         incb
 endc
Xfr95    stb  V.Sector-V.Wrtf,u
Xfr50    lbsr  Settrk
         lda   V.Sector-V.Wrtf,u
* Extend to check of sector reg once written
* as recommended by Western Digital for the 2797
* sta SECREG,Y set it in fdc
         bsr   SetSect set sector number in FDC
         lbsr  IssXfr Do Transfer
         bcc   Xfr70 Skip If No Error
         cmpb  #E$NotRdy not ready?
         orcc  #$01
         beq   Xfr70
         lsr   ,s
         bcc   Xfr10
         bne   Xfr50
Xfr70    leas  $01,s
         rts

* Set the sector number in the WD2797
* wait for 32usec, then check it
* as recommended by Western Digital
SetSect    sta   $02,y
         ldb   #12
SetSect1 decb
         bne   SetSect1
         cmpa  $02,y
         bne   SetSect
         rts

* Write Sector Routine
*

Wsect    lda   #1
         sta   V.Wrtf-V.Wrtf,u
         lda   #$A8
         sta   V.Cmd-V.Wrtf,u
         lbra  Xfr

* Select Drive Routine
*
Select    lda   u0008,u
         cmpa  #$04
         bcs   L041D
         comb
         ldb   #E$Unit bad unit
         rts

L041D    coma
         ldb   #$01
         stb   u0002,u
         anda  #$6F
         ldb   u0008,u
         cmpb  u0009,u
         beq   L0456
         stb   u0009,u
         ldb   <u0018,u
         orb   #$04
         stb   >$FC24
         ldx   #$0014
L0437    leax  -$01,x
         bne   L0437
         sta   >$FC24
         tst   V.Port,u
         bne   L0450
         ldb   #$03
L0444    ldx   #25000 100ms
Sele8    leax  -1,x
         bne   Sele8
         decb
         bne   L0444
         bra   L0456
L0450    ldx   #$000F
         os9   F$Sleep
L0456    anda  #$FB
         ldb   <u0018,u
         sta   <u0018,u
         sta   >$FC24
         lda   #$FA
         sta   u000E,u
         bitb  #$10
         beq   Sele5
         ldb   V.Fmt-V.Wrtf,u
         bmi   Sele5
         tst   V.Port,u
         bne   L047F
         ldb   #$0C
Sele7    ldx   #$61A8
L0476    leax  -$01,x
         bne   L0476
         decb
         bne   Sele7
         bra   Sele5
L047F    ldx   #$003C
         os9   F$Sleep
Sele5    lda   ,y
         clrb
         bita  #$80
         beq   Sele4
         clr   V.Active-V.Wrtf,u
         comb
         ldb   #$F6
Sele4    rts

*
* Seek routine
*
Settrk lda V.CrTrk-V.Wrtf,u get current track
 clr V.NewTrk-V.Wrtf,u clear 'new track'
 ifne DBLTRACK
 tst V.TwoStp-V.Wrtf,u double stepping?
 beq Sett1 ..no
 lsla double the track
 endc
Sett1    sta   $01,y
         lda   <u0017,u
         ldb   u000C,u
         bmi   L04AA
         bitb  #$04
         beq   L04AE
L04AA    cmpa  #$28
         bra   L04B0
L04AE    cmpa  #$10
L04B0    bcs   L04BD
         ldb   <u0018,u
         andb  #$DF
         stb   <u0018,u
         stb   >$FC24
L04BD    cmpa  <u0011,u
         beq   Sett8
         sta   <u0011,u
         tst   u000D,u
         beq   L04CA
         lsla
L04CA    ldb   #$04
         stb   <u0019,u
         sta   $03,y
         lda   #$18
Sett3    ora   <u0016,u
         lbsr  Outcom
         bsr   Sett8
         ldb   u0003,u
         andb  #$90
         lbra  STCK

Sett8    lda   <u0011,u
         sta   $01,y
         rts


* Restore Drive Routine
*
*
*   INPUT: (Y)= POINTER TO PATH DECSRIPTOR
*          (U)= POINTER TO GLOBAL STORAGE
*
*   IF ERROR: (B)= ERROR CODE & CARRY IS SET
*
 ifne STEPIN
* NOTE:  WE ARE STEPPING IN SEVERAL TRACKS BEFORE
*        ISSUINT THE RESTORE AS SUGGESTED IN THE
*        FD 1973 APPLICATION NOTES.
 endc

Brstor    lbsr  SELECT
         clr  V.CrTrk-V.Wrtf,u
         ldb   #$05
RESTR2    lda   #$48
         ora  V.Step-V.Wrtf,u
         pshs  b
         bsr   Outcom
         puls  b
         decb
         bne   RESTR2
         lda   #$08
         bra   Sett3

* Execute Transfer Requiring DMA
*

IssXfr    clrb
         pshs  cc
         ldb   V.Cmd-V.Wrtf,u
         tst   V.Side-V.Wrtf,u
         beq   L0510
         orb   #2
         stb   Drvbeg,u
L0510    orcc #IntMasks
         ldx   D.DMport
         beq   IssXfr2
         ldx   #1
         os9   F$Sleep
         bra   L0510
IssXfr2    leax  $03,y
         stx   D.DMPort
         ldx   V.Buff-V.Wrtf,u
         stx   D.DMMem
         lda   V.Wrtf-V.Wrtf,u
         sta   <u0039

**********

         ldx   #DAT.Task
         lda   #$00
         sta   ,x
         ora   #$80
         sta   ,x

**********

 ifne EXTFMT
 ifne DDTRACK0
         tst   V.DDTr0-V.Wrtf,u
         bne   IssXfr4
 endc
         ldb   V.Fmt-V.Wrtf,u
         tst   V.Track-V.Wrtf,u
         bne   L0547
         tst  V.Side-V.Wrtf,u
         beq   IssXfr5
L0547    bitb  #$02
         beq   IssXfr5
 endc
IssXfr4    lda   V.Select-V.Wrtf,u
         anda  #$BF
         sta   >$FC24
         sta   V.Select-V.Wrtf,u
IssXfr5    lda   V.Cmd-V.Wrtf,u
         ora   V.NewTrk-V.Wrtf,u
         bsr   Outcom
         bsr   ChkErr
         ldx   #$0000
         stx   <u0035
         bcc   IssXfr3
         lda   ,s
         ora   #$01
         sta   ,s
IssXfr3    puls  pc,cc

Outcom    pshs  cc
         orcc #IntMasks
         ldb   #$FA
         stb  V.Timer-V.Wrtf,u
         stb  V.Active-V.Wrtf,u
         sta   ,y
         tst   V.Wait-V.Wrtf,u
         bne   Fdccmd

IssFdc    sync
         lda   >$FCC1
         bita  #$80
         beq   IssFdc
         lda   ,y
         sta   V.Status-V.Wrtf,u
         bra   L05B4

* Start FDC and Wait by Sleeping
Fdccmd    ldx   #$00C8
         lda   V.Busy-V.Wrtf,u
         sta   V.Wake-V.Wrtf,u
L0597    os9   F$Sleep
         orcc #IntMasks
         tst   V.Wake-V.Wrtf,u
         beq   L05B7
         leax  ,x
         bne   L0597
         clr   V.Wake-V.Wrtf,u
         lda   #$80
         sta   V.Status-V.Wrtf,u
         lda   #$D0
         sta   ,y
         bsr   STCK3
L05B4    lda   >INTPIA
L05B7    clr   V.Active-V.Wrtf,u
         puls  pc,cc
*
* Translate error status
*
ChkErr    ldb   V.Status-V.Wrtf,u

STCK    clra
         andb  #$FC
         beq   STCK3
SCK1    lslb
         inca
         bcc   SCK1
         deca
         leax  <ERTABLE,pcr
         ldb   a,x
         cmpb  #$F4
         bne   STCK2
         tst   V.Wrtf-V.Wrtf,u
         beq   STCK2
         ldb   #$F5
STCK2    coma
STCK3    rts

ERTABLE fcb E$NotRdy,E$WP,E$Read,E$Seek
 fcb E$Read,E$Read

* Interrupt Request Service For Fdc
*
* Input: U=Static Storage

Fdcsrv    ldy   V.Port,u
         ldb   ,y
         stb   >V.Status,u
         lda   >INTPIA
         lda   V.Wake,u
         beq   Fdcsrc2
         clr   V.Wake,u
 ldb #S$Wake
 os9 F$Send
Fdcsrc2    clrb
         rts

TimSrv tst V.Timer,u get counter
 beq TimSrv1 ..none
 tst V.Active,u command in progress?
 bne TimSrv1 ..yes
 dec V.Timer,u keep count
 bne TimSrv1 ..not yet
 lda #$FF-B.DPHalt turn everything off
 sta >SELREG
 sta V.Select,u
TimSrv1 rts

 EMOD

Dkend EQU *
