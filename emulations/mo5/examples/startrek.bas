10 REM SUPER STARTREK - MAY 16,1978 - REQUIRES 24K MEMORY
30 REM
40 REM ****        **** STAR TREK ****        ****
50 REM **** SIMULATION OF A MISSION OF THE STARSHIP ENTERPRISE,
60 REM **** AS SEEN ON THE STAR TREK TV SHOW.
70 REM **** ORIGIONAL PROGRAM BY MIKE MAYFIELD, MODIFIED VERSION
80 REM **** PUBLISHED IN DEC'S "101 BASIC GAMES", BY DAVE AHL.
90 REM **** MODIFICATIONS TO THE LATTER (PLUS DEBUGGING) BY BOB
100 REM *** LEEDOM - APRIL & DECEMBER 1974,
110 REM *** WITH A LITTLE HELP FROM HIS FRIENDS . . .
120 REM *** COMMENTS, EPITHETS, AND SUGGESTIONS SOLICITED --
130 REM *** SEND TO:  R. C. LEEDOM
140 REM ***           WESTINGHOUSE DEFENSE & ELECTRONICS SYSTEMS CNTR.
150 REM ***           BOX 746, M.S. 338
160 REM ***           BALTIMORE, MD  21203
200 DEFINT C,E,G,I,J,P,Z
220 CLS
221 PRINT"                     ,------*------,"
222 PRINT"      ,-------------   '---  ------'"
223 PRINT"      '-------- --'      / /"
224 PRINT"          ,---' '-------/ /--,"
225 PRINT"           '----------------'":PRINT
226 PRINT"    THE USS ENTERPRISE --- NCC-1701"
227 PRINT:PRINT:PRINT:PRINT:PRINT
260 CLEAR 600
270 Z$="                         "
280 PRINT:PRINT"HIT ANY KEY WHEN READY TO ACCEPT COMMAND"
300 I=RND(1): IF INKEY$="" THEN 300
330 DIM G(8,8),C(9,2),K(3,3),N(3),Z(8,8),D(8)
370 T=INT(RND(1)*20+20)*100
380 T0=T
390 T9=25+INT(RND(1)*10)
400 D0=0
410 E=3000
420 E0=E
440 P=10:P0=P:S9=200:S=0:B9=2:K9=0:X$="":X0$=" IS "

480 REM INITIALIZE ENTERPRISE'S POSITION
490 Q1=INT(RND(1)*7.98+1.01)
500 Q2=INT(RND(1)*7.98+1.01)
510 S1=INT(RND(1)*7.98+1.01)
520 S2=INT(RND(1)*7.98+1.01)
530 FOR I=1 TO 9:C(I,1)=0:C(I,2)=0:NEXT I
540 C(3,1)=-1:C(2,1)=-1:C(4,1)=-1:C(4,2)=-1:C(5,2)=-1:C(6,2)=-1
600 C(1,2)=1:C(2,2)=1:C(6,1)=1:C(7,1)=1:C(8,1)=1:C(8,2)=1:C(9,2)=1
670 FOR I=1 TO 8:D(I)=0:NEXT I
710 A1$="NAVSRSLRSPHATORSHEDAMCOMXXX"
810 REM SETUP WHAT EXISTS IN GALAXY ...
815 REM K3= # KLINGONS  B3= # STARBASES  S3 = # STARS
820 FOR I=1 TO 8:FOR J=1 TO 8:K3=0:Z(I,J)=0:R1=RND(1)
850 IF R1>.98 THEN K3=3:K9=K9+3:GOTO 980
860 IF R1>.95 THEN K3=2:K9=K9+2:GOTO 980
870 IF R1>.80 THEN K3=1:K9=K9+1
980 B3=0:IF RND(1)>.96 THEN B3=1:B9=B9+1
1040 G(I,J)=K3*100+B3*10+INT(RND(1)*7.98+1.01)
1080 NEXT J
1090 NEXT I:IF K9>T9 THEN T9=K9+1
1100 IF B9<>0 THEN 1200
1150 IF G(Q1,Q2)<200 THEN G(Q1,Q2)=G(Q1,Q2)+100:K9=K9+1
1160 B9=1:G(Q1,Q2)=G(Q1,Q2)+10
1170 Q1=INT(RND(1)*7.98+1.01)
1180 Q2=INT(RND(1)*7.98+1.01)
1200 K7=K9:IF B9<>1 THEN X$="S":X0$=" ARE "
1230 PRINT"YOUR ORDERS ARE AS FOLLOWS:"
1240 PRINT:PRINT"DESTROY THE";K9;"KLINGON WARSHIPS WHICH"
1250 PRINT"HAVE INVADED THE GALAXY BEFORE THEY CAN"
1255 PRINT"ATTACK FEDERATION HEADQUARTERS ON"
1260 PRINT"STARDATE";T0+T9;". THIS GIVES YOU";T9;"DAYS."
1265 PRINT"THERE";X0$;B9;"STARBASE";X$;" IN THE"
1270 PRINT"GALAXY FOR RESUPPLYING YOUR SHIP"
1280 PRINT:PRINT"HIT ANY KEY"
1300 I=RND(1): IF INKEY$="" THEN 1300

1310 REM HERE ANY TIME NEW QUADRANT ENTERED
1320 Z4=Q1:Z5=Q2:K3=0:B3=0:S3=0:G5=0:D4=.5*RND(1):Z(Q1,Q2)=G(Q1,Q2)
1390 IF Q1<1 OR Q1>8 OR Q2<1 OR Q2>8 THEN 1600
1430 GOSUB 9030:PRINT:IF T0<>T THEN 1490
1460 PRINT"YOUR MISSION BEGINS WITH YOUR STARSHIP"
1470 PRINT"LOCATED IN THE GALACTIC QUADRANT,"
1480 PRINT"     '";G2$;"'.":GOTO 1500
1490 PRINT"NOW ENTERING ";G2$;" QUADRANT..."
1500 PRINT:K3=INT(G(Q1,Q2)*.01):B3=INT(G(Q1,Q2)*.1)-10*K3
1540 S3=G(Q1,Q2)-100*K3-10*B3:IF K3=0 THEN 1590
1560 PRINT"COMBAT AREA      CONDITION RED":IF S>200 THEN 1590
1580 PRINT"   SHIELDS DANGEROUSLY LOW"
1590 FOR I=1 TO 3:K(I,1)=0:K(I,2)=0:NEXT I
1600 FOR I=1 TO 3:K(I,3)=0:NEXT I:Q$=Z$+Z$+Z$+Z$+Z$+Z$+Z$+LEFT$(Z$,17)

1660 REM POSITION ENTERPRISE IN QUADRANT, THEN PLACE "K3" KLINGONS, &
1670 REM "B3" STARBASES, & "S3" STARS ELSEWHERE.
1680 A$="<*>"
1690 Z1=S1
1700 Z2=S2
1710 GOSUB 8670:IF K3<1 THEN 1820
1720 FOR I=1 TO K3:GOSUB 8590:A$="+K+":Z1=R1:Z2=R2
1780 GOSUB 8670:K(I,1)=R1:K(I,2)=R2:K(I,3)=S9*(0.5+RND(1))
1810 NEXT I
1820 IF B3<1 THEN 1910
1880 GOSUB 8590:A$=">!<":Z1=R1:B4=R1:Z2=R2:B5=R2:GOSUB 8670
1910 FOR I=1 TO S3
1920 GOSUB 8590:A$=" * ":Z1=R1:Z2=R2:GOSUB 8670
1970 NEXT I
1980 GOSUB 6430
1990 IF S+E>10 THEN IF E>10 OR D(7)=0 THEN 2060
2010 PRINT:PRINT"** FATAL ERROR **"
2020 PRINT"YOU'VE JUST STRANDED YOUR SHIP IN SPACE.";
2030 PRINT"YOU HAVE INSUFFICIENT MANEUVERING ENERGY";
2040 PRINT"AND SHIELD CONTROL IS PRESENTLY INCAPAB-";
2050 PRINT"LE OF CROSS-CIRCUITING TO ENGINE ROOM!!":GOTO 6220
2060 INPUT"COMMAND";A$
2080 FOR I=1 TO 9
2090 IF LEFT$(A$,3)<>MID$(A1$,3*I-2,3) THEN 2160
2140 ON I GOTO 2300,1980,4000,4260,4700,5530,5690,7290,6270
2160 NEXT I
2170 PRINT"ENTER ONE OF THE FOLLOWING:"
2180 PRINT"  NAV  (TO SET COURSE)"
2190 PRINT"  SRS  (FOR SHORT RANGE SENSOR SCAN)"
2200 PRINT"  LRS  (FOR LONG RANGE SENSOR SCAN)"
2210 PRINT"  PHA  (TO FIRE PHASERS)"
2220 PRINT"  TOR  (TO FIRE PHOTON TORPEDOES)"
2230 PRINT"  SHE  (TO RAISE OR LOWER SHIELDS)"
2240 PRINT"  DAM  (FOR DAMAGE CONTROL REPORTS)"
2250 PRINT"  COM  (TO CALL ON LIBRARY-COMPUTER)"
2260 PRINT"  XXX  (TO RESIGN YOUR COMMAND)":PRINT:GOTO 1990

2290 REM COURSE CONTROL BEGINS HERE
2300 INPUT"COURSE (1-9)";C1:IF C1=9 THEN C1=1
2310 IF C1>=1 AND C1<9 THEN 2350
2330 PRINT"   LT. SULU REPORTS,":PRINT"'INCORRECT COURSE DATA, SIR!'"
2340 GOTO 1990
2350 X$="8":IF D(1)<0 THEN X$="0.2"
2360 PRINT"WARP FACTOR (0-";X$;")";:INPUT W1:IF D(1)<0 AND W1>.2 THEN 2470
2380 IF W1>0 AND W1<=8 THEN 2490
2390 IF W1=0 THEN 1990
2420 PRINT"   CHIEF ENGINEER SCOTT REPORTS,"
2430 PRINT"'THE ENGINES WON'T TAKE WARP ";W1;"!'":GOTO 1990
2470 PRINT"WARP ENGINES ARE DAMAGED.":PRINT"  MAXIUM SPEED = WARP 0.2":GOTO 1990
2490 N=INT(W1*8+.5):IF E-N>=0 THEN 2590
2500 PRINT"   ENGINEERING REPORTS,"
2510 PRINT"'INSUFFICIENT ENERGY AVAILABLE":PRINT "FOR MANEUVERING AT WARP";W1;"!'"
2530 IF S<N-E OR D(7)<0 THEN 1990
2550 PRINT"DEFLECTOR CONTROL ROOM ACKNOWLEDGES,"
2560 PRINT S;"UNITS OF ENERGY PRESENTLY":PRINT"DEPLOYED TO SHIELDS."
2570 GOTO 1990

2580 REM KLINGONS MOVE/FIRE ON MOVING STARSHIP . . .
2590 FOR I=1 TO K3:IF K(I,3)=0 THEN 2700
2610 A$="   ":Z1=K(I,1):Z2=K(I,2):GOSUB 8670:GOSUB 8590
2660 K(I,1)=Z1:K(I,2)=Z2:A$="+K+":GOSUB 8670
2700 NEXT I
2710 GOSUB 6000
2720 D1=0
2730 D6=W1:IF W1>=1 THEN D6=1
2770 FOR I=1 TO 8:IF D(I)>=0 THEN 2880
2790 D(I)=D(I)+D6:IF D(I)>-.1 AND D(I)<0 THEN D(I)=-.1:GOTO 2880
2800 IF D(I)<0 THEN 2880
2810 IF D1<>1 THEN D1=1:PRINT"DAMAGE CONTROL REPORT:  ";
2840 R1=I:GOSUB 8790:PRINT G2$;" REPAIR COMPLETED."
2880 NEXT I:IF RND(1)>.2 THEN 3070
2910 R1=INT(RND(1)*7.98+1.01):IF RND(1)>=.6 THEN 3000
2930 D(R1)=D(R1)-(RND(1)*5+1):PRINT"DAMAGE CONTROL REPORT:  ";
2960 GOSUB 8790:PRINT G2$;" DAMAGED":PRINT:GOTO 3070
3000 D(R1)=D(R1)+RND(1)*3+1:PRINT"DAMAGE CONTROL REPORT:  ";
3030 GOSUB 8790:PRINT G2$;" STATE OF REPAIR IMPROVED":PRINT

3060 REM BEGIN MOVING STARSHIP
3070 A$="   ":Z1=INT(S1):Z2=INT(S2):GOSUB 8670
3080 C1%=INT(C1)
3110 X1=C(C1%,1)+(C(C1%+1,1)-C(C1%,1))*(C1-C1%):X=S1:Y=S2
3140 X2=C(C1%,2)+(C(C1%+1,2)-C(C1%,2))*(C1-C1%):Q4=Q1:Q5=Q2
3170 FOR I=1 TO N:S1=S1+X1:S2=S2+X2:IF S1<1 OR S1>=9 OR S2<1 OR S2>=9 THEN 3500
3240 S8=INT(S1)*24+INT(S2)*3-26:IF MID$(Q$,S8,2)="  " THEN 3360
3320 S1=INT(S1-X1):S2=INT(S2-X2)
3340 PRINT USING "WARP ENGINES SHUT DOWN AT SECTOR #,#";S1,S2
3350 PRINT"DUE TO BAD NAVIGATION":GOTO 3370
3360 NEXT I:S1=INT(S1):S2=INT(S2)
3370 A$="<*>":Z1=INT(S1):Z2=INT(S2):GOSUB 8670:GOSUB 3910:T8=1
3430 IF W1<1 THEN T8=.1*INT(10*W1)
3450 T=T+T8:IF T>T0+T9 THEN 6220
3470 REM SEE IF DOCKED, THEN GET COMMAND
3480 GOTO 1980

3490 REM EXCEEDED QUADRANT LIMITS
3500 X=8*Q1+X+N*X1:Y=8*Q2+Y+N*X2:Q1=INT(X/8):Q2=INT(Y/8):S1=INT(X-Q1*8)
3550 S2=INT(Y-Q2*8):IF S1=0 THEN Q1=Q1-1:S1=8
3590 IF S2=0 THEN Q2=Q2-1:S2=8
3620 X5=0:IF Q1<1 THEN X5=1:Q1=1:S1=1
3670 IF Q1>8 THEN X5=1:Q1=8:S1=8
3710 IF Q2<1 THEN X5=1:Q2=1:S2=1
3750 IF Q2>8 THEN X5=1:Q2=8:S2=8
3790 IF X5=0 THEN 3860
3800 PRINT"LT. UHURA REPORTS MESSAGE FROM STARFLEETCOMMAND:"
3810 PRINT"  'PERMISSION TO ATTEMPT CROSSING OF"
3815 PRINT"GALACTIC PERIMETER IS HEREBY *DENIED*."
3820 PRINT"  SHUT DOWN YOUR ENGINES.'"
3830 PRINT"   CHIEF ENGINEER SCOTT REPORTS,"
3835 PRINT"'WARP ENGINES SHUT DOWN AT"
3840 PRINT USING "SECTOR #,# OF QUADRANT #,#.'";S1,S2,Q1,Q2
3850 IF T>T0+T9 THEN 6220
3860 IF 8*Q1+Q2=8*Q4+Q5 THEN 3370
3870 T=T+1:GOSUB 3910:GOTO 1320
3900 REM MANEUVER ENERGY S/R **
3910 E=E-N-10:IF E>=0 THEN RETURN
3930 PRINT"SHIELD CONTROL SUPPLIES ENERGY TO":PRINT"COMPLETE THE MANEUVER."
3940 S=S+E:E=0:IF S<=0 THEN S=0
3980 RETURN

3990 REM LONG RANGE SENSOR SCAN CODE
4000 IF D(3)<0 THEN PRINT"LONG RANGE SENSORS ARE INOPERABLE":GOTO 1990
4030 PRINT USING "LONG RANGE SCAN FOR QUADRANT #,#";Q1,Q2
4040 O1$="-------------------":PRINT O1$
4060 FOR I=Q1-1 TO Q1+1:N(1)=-1:N(2)=-2:N(3)=-3:FOR J=Q2-1 TO Q2+1
4120 IF I>0 AND I<9 AND J>0 AND J<9 THEN N(J-Q2+2)=G(I,J):Z(I,J)=G(I,J)
4180 NEXT J:FOR L=1 TO 3:PRINT": ";
4190 IF N(L)<0 THEN PRINT"*** "; ELSE PRINT RIGHT$(STR$(N(L)+1000),3);" ";
4230 NEXT L:PRINT":":PRINT O1$:NEXT I:GOTO 1990

4250 REM PHASER CONTROL CODE BEGINS HERE
4260 IF D(4)<0 THEN PRINT"PHASERS INOPERATIVE":GOTO 1990
4265 IF K3>0 THEN 4330
4270 PRINT"   SCIENCE OFFICER SPOCK REPORTS,"
4280 PRINT"'SENSORS SHOW NO ENEMY SHIPS":PRINT"IN THIS QUADRANT'":GOTO 1990
4330 IF D(8)<0 THEN PRINT"COMPUTER FAILURE HAMPERS ACCURACY"
4350 PRINT"PHASERS LOCKED ON TARGET;"
4360 PRINT"ENERGY AVAILABLE =";E;"UNITS"
4370 INPUT"NUMBER OF UNITS TO FIRE";X:IF X<=0 THEN 1990
4400 IF E-X<0 THEN 4360
4410 E=E-X:IF D(7)<0 THEN X=X*RND(1)
4450 H1=INT(X/K3):FOR I=1 TO 3:IF K(I,3)<=0 THEN 4670
4480 H=INT((H1/(SQR((K(I,1)-S1)^2+(K(I,2)-S2)^2)))*(RND(1)+2)):IF H>.15*K(I,3) THEN 4530
4500 PRINT USING "SENSORS SHOW NO DAMAGE TO ENEMY AT #,#";K(I,1),K(I,2):GOTO 4670
4530 K(I,3)=K(I,3)-H
4540 PRINT USING "### UNIT HIT ON KLINGON AT SECTOR #,#";H,K(I,1),K(I,2)
4550 IF K(I,3)<=0 THEN PRINT"*** KLINGON DESTROYED ***":GOTO 4580
4560 PRINT"   (SENSORS SHOW";K(I,3);"UNITS REMAINING)":GOTO 4670
4580 K3=K3-1:K9=K9-1:Z1=K(I,1):Z2=K(I,2):A$="   ":GOSUB 8670
4650 K(I,3)=0:G(Q1,Q2)=G(Q1,Q2)-100:Z(Q1,Q2)=G(Q1,Q2):IF K9<=0 THEN 6370
4670 NEXT I:GOSUB 6000:GOTO 1990

4690 REM PHOTON TORPEDO CODE BEGINS HERE
4700 IF P<=0 THEN PRINT"ALL PHOTON TORPEDOES EXPENDED":GOTO 1990
4730 IF D(5)<0 THEN PRINT"PHOTON TUBES ARE NOT OPERATIONAL":GOTO 1990
4760 INPUT"PHOTON TORPEDO COURSE (1-9)";C1:IF C1=9 THEN C1=1
4780 IF C1>=1 AND C1<9 THEN 4840
4790 PRINT"   ENSIGN CHEKOV REPORTS,":PRINT"'INCORRECT COURSE DATA, SIR!'"
4800 GOTO 1990
4840 J%=INT(C1)
4850 X1=C(J%,1)+(C(J%+1,1)-C(J%,1))*(C1-J%):E=E-2:P=P-1
4860 X2=C(J%,2)+(C(J%+1,2)-C(J%,2))*(C1-J%):X=S1:Y=S2
4910 PRINT"TORPEDO TRACK:"
4920 X=X+X1:Y=Y+X2:X3=INT(X+.5):Y3=INT(Y+.5)
4960 IF X3<1 OR X3>8 OR Y3<1 OR Y3>8 THEN 5490
5000 PRINT USING "               #,#";X3,Y3:A$="   ":Z1=X:Z2=Y:GOSUB 8830
5050 IF Z3<>0 THEN 4920
5060 A$="+K+":Z1=X:Z2=Y:GOSUB 8830:IF Z3=0 THEN 5210
5110 PRINT"*** KLINGON DESTROYED ***":K3=K3-1:K9=K9-1:IF K9<=0 THEN 6370
5150 FOR I=1 TO 3:IF X3=K(I,1) AND Y3=K(I,2) THEN 5190
5180 NEXT I:I=3
5190 K(I,3)=0:GOTO 5430
5210 A$=" * ":Z1=X:Z2=Y:GOSUB 8830:IF Z3=0 THEN 5280
5260 PRINT USING "STAR AT #,# ABSORBED TORPEDO ENERGY.";X3,Y3:GOSUB 6000:GOTO 1990
5280 A$=">!<":Z1=X:Z2=Y:GOSUB 8830:IF Z3=0 THEN 4760
5330 PRINT"*** STARBASE DESTROYED ***":B3=B3-1:B9=B9-1
5360 IF B9>0 OR K9>T-T0-T9 THEN 5400
5370 PRINT"THAT DOES IT, CAPTAIN!!  YOU ARE HEREBY"
5380 PRINT"RELIEVED OF COMMAND AND SENTENCED TO 99"
5390 PRINT"STARDATES AT HARD LABOR ON CYGNUS 12!!":GOTO 6270
5400 PRINT"STARFLEET COMMAND REVIEWING YOUR RECORD TO CONSIDER"
5410 PRINT"COURT MARTIAL!":D0=0
5430 Z1=X:Z2=Y:A$="   ":GOSUB 8670
5470 G(Q1,Q2)=K3*100+B3*10+S3:Z(Q1,Q2)=G(Q1,Q2):GOSUB 6000:GOTO 1990
5490 PRINT"TORPEDO MISSED":GOSUB 6000:GOTO 1990

5520 REM SHIELD CONTROL
5530 IF D(7)<0 THEN PRINT"SHIELD CONTROL INOPERABLE":GOTO 1990
5560 PRINT"ENERGY AVAILABLE =";E+S:INPUT"NUMBER OF UNITS TO SHIELDS";X
5580 IF X<0 OR S=X THEN PRINT"<SHIELDS UNCHANGED>":GOTO 1990
5590 IF X<=E+S THEN 5630
5600 PRINT"SHIELD CONTROL REPORTS":PRINT"  'THIS IS NOT THE FEDERATION TREASURY.'"
5610 PRINT"<SHIELDS UNCHANGED>":GOTO 1990
5630 E=E+S-X:S=X:PRINT"DEFLECTOR CONTROL ROOM REPORT:"
5660 PRINT"  'SHIELDS NOW AT";INT(S);"UNITS.'":GOTO 1990

5680 REM DAMAGE CONTROL
5690 IF D(6)>=0 THEN 5910
5700 PRINT"DAMAGE CONTROL REPORT NOT AVAILABLE":IF D0=0 THEN 1990
5720 D3=0:FOR I=1 TO 8:IF D(I)<0 THEN D3=D3+.1
5760 NEXT I:IF D3=0 THEN 1990
5780 PRINT:D3=D3+D4:IF D3>=1 THEN D3=.9
5810 PRINT"TECHNICIANS STANDING BY TO EFFECT":PRINT"REPAIRS TO YOUR SHIP."
5820 PRINT USING "ESTIMATED TIME TO REPAIR: #.## STARDATES";D3
5840 INPUT "WILL YOU AUTHORIZE THE REPAIR ORDER Y/N ";A$
5860 IF A$<>"Y" THEN 1990
5870 FOR I=1 TO 8:IF D(I)<0 THEN D(I)=0
5890 NEXT I:T=T+D3+.1
5910 PRINT:PRINT"DEVICE             STATE OF REPAIR":FOR R1=1 TO 8
5920 GOSUB 8790:PRINT G2$;LEFT$(Z$,25-LEN(G2$));:PRINT USING "##.##";D(R1)
5950 NEXT R1:PRINT:IF D0<>0 THEN 5720
5980 GOTO 1990

5990 REM KLINGONS SHOOTING
6000 IF K3<=0 THEN RETURN
6010 IF D0<>0 THEN PRINT"STARBASE SHIELDS PROTECT THE ENTERPRISE":RETURN
6040 FOR I=1 TO 3:IF K(I,3)<=0 THEN 6200
6060 H=INT((K(I,3)/(SQR((K(I,1)-S1)^2+(K(I,2)-S2)^2)))*(2+RND(1)))
6070 S=S-H:K(I,3)=K(I,3)/(3+RND(0))
                  
6080 PRINT USING "### UNIT HIT ON ENTERPRISE FROM         SECTOR #,#";H,K(I,1),K(I,2)
6090 IF S<=0 THEN 6240
6100 PRINT"      <SHIELDS DOWN TO";S;"UNITS>":IF H<20 THEN 6200
6120 IF RND(1)>.6 OR H/S<=.02 THEN 6200
6140 R1=INT(RND(1)*7.98+1.01):D(R1)=D(R1)-H/S-.5*RND(1):GOSUB 8790
6170 PRINT"DAMAGE CONTROL REPORTS '";G2$;" DAMAGED BY THE HIT'"
6200 NEXT I:RETURN

6210 REM END OF GAME
6220 PRINT"IT IS STARDATE";T:GOTO 6270
6240 PRINT:PRINT"THE ENTERPRISE HAS BEEN DESTROYED."
6250 PRINT"  THEN FEDERATION WILL BE CONQUERED.":GOTO 6220
6270 PRINT"THERE WERE";K9;"KLINGON BATTLE CRUISERS"
6280 PRINT"LEFT AT THE END OF YOUR MISSION."
6290 PRINT:PRINT:IF B9=0 THEN 6360
6300 PRINT"THE FEDERATION IS IN NEED OF A NEW"
6310 PRINT"STARSHIP COMMANDER FOR A SIMILAR MISSION";
6320 PRINT" -- IF THERE IS A VOLUNTEER, LET HIM"
6330 INPUT"STEP FORWARD AND ENTER 'AYE'";A$:IF A$="AYE" THEN 10
6360 END
6370 PRINT"CONGRATULATION, CAPTAIN!  THE LAST"
6380 PRINT"KLINGO BATTLE CRUISER MENACING THE"
6390 PRINT"FEDERATION HAS BEEN DESTROYED.":PRINT
6400 PRINT"YOUR EFFICIENCY RATING IS";1000*(K7/(T-T0))^2:GOTO 6290

6420 REM SHORT RANGE SENSOR SCAN & STARTUP SUBROUTINE
6430 FOR I=S1-1 TO S1+1
6440 FOR J=S2-1 TO S2+1
6450 IF INT(I+.5)<1 OR INT(I+.5)>8 OR INT(J+.5)<1 OR INT(J+.5)>8 THEN 6540
6490 A$=">!<":Z1=I:Z2=J:GOSUB 8830:IF Z3=1 THEN 6580
6540 NEXT J
6550 NEXT I:D0=0:GOTO 6650
6580 D0=1:C$="DOCKED":E=E0:P=P0
6620 PRINT"SHIELDS DROPPED FOR DOCKING PURPOSES":S=0:GOTO 6720
6650 IF K3>0 THEN C$="*RED*":GOTO 6720
6660 C$="GREEN":IF E<E0*.1 THEN C$="YELLOW"
6720 IF D(2)>=0 THEN 6770
6730 PRINT:PRINT"*** SHORT RANGE SENSORS ARE OUT ***":PRINT:RETURN
6770 O1$="---------------------------------":PRINT O1$
6810 FOR I=1 TO 8
6820 FOR J=(I-1)*24+1 TO (I-1)*24+22 STEP 3:PRINT" ";MID$(Q$,J,3);:NEXT J
6825 ON I GOSUB 6850,6900,6960,7020,7070,7120,7180,7240
6830 NEXT I
6840 PRINT O1$:RETURN
6850 PRINT USING " ####.#";T:RETURN
6900 PRINT " ";C$:RETURN
6960 PRINT USING " Q:#,#";Q1,Q2:RETURN
7020 PRINT USING " S:#,#";S1,S2:RETURN
7070 PRINT USING " T:##";P:RETURN
7120 PRINT USING " E:####";E+S:RETURN
7180 PRINT USING " S:####";S:RETURN
7240 PRINT USING " K:##";K9:RETURN

7280 REM LIBRARY COMPUTER CODE
7290 IF D(8)<0 THEN PRINT"COMPUTER DISABLED":GOTO 1990
7320 INPUT"COMPUTER ACTIVE AND AWAITING COMMAND";A:IF A<0 THEN 1990
7350 PRINT:H8=1:ON A+1 GOTO 7530,7900,8070,8500,8150,7400
7360 PRINT"FUNCTIONS AVAILABLE FROM LIBRARY-COMPUTER:"
7370 PRINT"   0 = CUMULATIVE GALACTIC RECORD"
7372 PRINT"   1 = STATUS REPORT"
7374 PRINT"   2 = PHOTON TORPEDO DATA"
7376 PRINT"   3 = STARBASE NAV DATA"
7378 PRINT"   4 = DIRECTION/DISTANCE CALCULATOR"
7380 PRINT"   5 = GALAXY 'REGION NAME' MAP":PRINT:GOTO 7320
7390 REM SETUP TO CHANGE CUM GAL RECORD TO GALAXY MAP
7400 H8=0:G5=1:PRINT"               THE GALAXY":GOTO 7550

7530 REM CUM GALACTIC RECORD
7543 PRINT
7544 PRINT "COMPUTER RECORD OF GALAXY":PRINT USING "FOR QUADRANT #,#";Q1,Q2
7546 PRINT
7550 PRINT"     1   2   3   4   5   6   7   8"
7560 O1$="    --- --- --- --- --- --- --- ---"
7570 PRINT O1$:FOR I=1 TO 8:PRINT I;
7620 IF H8=0 THEN 7740
7630 FOR J=1 TO 8
7640 PRINT" ";
7650 IF Z(I,J)=0 THEN PRINT"***"; ELSE PRINT RIGHT$(STR$(Z(I,J)+1000),3);
7720 NEXT J
7730 PRINT:GOTO 7850
7740 Z4=I:Z5=1:GOSUB 9030:J0=INT(12-.5*LEN(G2$)):PRINT TAB(J0);G2$;
7800 Z5=5:GOSUB 9030:J0=INT(28-.5*LEN(G2$)):PRINT TAB(J0);G2$
7850 PRINT O1$:NEXT I:PRINT:GOTO 1990

7890 REM STATUS REPORT
7900 PRINT "   STATUS REPORT:":X$="":IF K9>1 THEN X$="S"
7940 PRINT"KLINGON";X$;" LEFT:";K9
7960 PRINT"MISSION MUST BE COMPLETED IN":PRINT USING "        ##.# STARDATES";T0+T9-T
7970 X$="S":IF B9<2 THEN X$="":IF B9<1 THEN 8010
7980 PRINT"THE FEDERATION IS MAINTAINING":PRINT TAB(8);B9;"STARBASE";X$;" IN THE GALAXY"
7990 GOTO 5690
8010 PRINT"YOUR STUPIDITY HAS LEFT YOU ON YOUR OWN"
8020 PRINT"IN THE GALAXY":PRINT" -- YOU HAVE NO STARBASES LEFT!":GOTO 5690

8060 REM TORPEDO, BASE NAV, D/D CALCULATOR
8070 IF K3<=0 THEN 4270
8080 X$="":IF K3>1 THEN X$="S"
8090 PRINT"FROM ENTERPRISE TO KLINGON BATTLE CRUSER";X$
8100 H8=0:FOR I=1 TO 3:IF K(I,3)<=0 THEN 8480
8110 W1=K(I,1):X=K(I,2)
8120 C1=S1:A=S2:GOTO 8220
8150 PRINT"DIRECTION/DISTANCE CALCULATOR:"
8160 PRINT USING "YOU ARE AT QUADRANT #,# SECTOR #,#";Q1,Q2,S1,S2
8170 PRINT"PLEASE ENTER":INPUT"  INITIAL COORDINATES (X,Y)";C1,A
8200 INPUT"  FINAL COORDINATES (X,Y)";W1,X
8220 X=X-A:A=C1-W1:IF X<0 THEN 8350
8250 IF A<0 THEN 8410
8260 IF X>0 THEN 8280
8270 IF A=0 THEN C1=5:GOTO 8290
8280 C1=1
8290 IF ABS(A)<=ABS(X) THEN 8330
8310 PRINT"DIRECTION =";C1+(((ABS(A)-ABS(X))+ABS(A))/ABS(A)):GOTO 8460
8330 PRINT"DIRECTION =";C1+(ABS(A)/ABS(X)):GOTO 8460
8350 IF A>0 THEN C1=3:GOTO 8420
8360 IF X<>0 THEN C1=5:GOTO 8290
8410 C1=7
8420 PRINT"DIRECTION =";:IF ABS(A)>=ABS(X) THEN PRINT C1+(ABS(X)/ABS(A)) ELSE PRINT C1+(((ABS(X)-ABS(A))+ABS(X))/ABS(X))
8460 PRINT"DISTANCE =";SQR(X^2+A^2):IF H8=1 THEN 1990
8480 NEXT I
8490 GOTO 1990
8500 IF B3<>0 THEN PRINT"FROM ENTERPRISE TO STARBASE:":W1=B4:X=B5:GOTO 8120
8510 PRINT"MR. SPOCK REPORTS,  'SENSORS SHOW NO STARBASES IN THIS";
8520 PRINT" QUADRANT.'":GOTO 1990

8580 REM FIND EMPTY PLACE IN QUADRANT (FOR THINGS)
8590 R1=INT(RND(1)*7.98+1.01):R2=INT(RND(1)*7.98+1.01):A$="   ":Z1=R1:Z2=R2:GOSUB 8830:IF Z3=0 THEN 8590
8600 RETURN
8660 REM INSERT IN STRING ARRAY FOR QUADRANT
8670 S8=INT(Z2-.5)*3+INT(Z1-.5)*24+1
8675 IF LEN(A$)<>3 THEN PRINT"ERROR":STOP
8680 IF S8=1 THEN Q$=A$+RIGHT$(Q$,189):RETURN
8690 IF S8=190 THEN Q$=LEFT$(Q$,189)+A$:RETURN
8700 Q$=LEFT$(Q$,S8-1)+A$+RIGHT$(Q$,190-S8):RETURN

8780 REM PRINTS DEVICE NAME
8790 ON R1 GOTO 8792,8794,8796,8798,8800,8802,8804,8806
8792 G2$="WARP ENGINES":RETURN
8794 G2$="SHORT RANGE SENSORS":RETURN
8796 G2$="LONG RANGE SENSORS":RETURN
8798 G2$="PHASER CONTROL":RETURN
8800 G2$="PHOTON TUBES":RETURN
8802 G2$="DAMAGE CONTROL":RETURN
8804 G2$="SHIELD CONTROL":RETURN
8806 G2$="LIBRARY-COMPUTER":RETURN

8820 REM STRING COMPARISON IN QUADRANT ARRAY
8830 Z1=INT(Z1+.5):Z2=INT(Z2+.5):S8=(Z2-1)*3+(Z1-1)*24+1:Z3=0
8890 IF MID$(Q$,S8,3)<>A$ THEN RETURN
8900 Z3=1:RETURN

9010 REM QUADRANT NAME IN G2$ FROM Z4,Z5 (=Q1,Q2)
9020 REM CALL WITH G5=1 TO GET REGION NAME ONLY
9030 IF Z5<=4 THEN ON Z4 GOTO 9040,9050,9060,9070,9080,9090,9100,9110
9035 GOTO 9120
9040 G2$="ANTARES":GOTO 9210
9050 G2$="RIGEL":GOTO 9210
9060 G2$="PROCYON":GOTO 9210
9070 G2$="VEGA":GOTO 9210
9080 G2$="CANOPUS":GOTO 9210
9090 G2$="ALTAIR":GOTO 9210
9100 G2$="SAGITTARIUS":GOTO 9210
9110 G2$="POLLUX":GOTO 9210
9120 ON Z4 GOTO 9130,9140,9150,9160,9170,9180,9190,9200
9130 G2$="SIRIUS":GOTO 9210
9140 G2$="DENEB":GOTO 9210
9150 G2$="CAPELLA":GOTO 9210
9160 G2$="BETELGEUSE":GOTO 9210
9170 G2$="ALDEBARAN":GOTO 9210
9180 G2$="REGULUS":GOTO 9210
9190 G2$="ARCTURUS":GOTO 9210
9200 G2$="SPICA"
9210 IF G5<>1 THEN ON Z5 GOTO 9230,9240,9250,9260,9230,9240,9250,9260
9220 RETURN
9230 G2$=G2$+" I":RETURN
9240 G2$=G2$+" II":RETURN
9250 G2$=G2$+" III":RETURN
9260 G2$=G2$+" IV":RETURN
