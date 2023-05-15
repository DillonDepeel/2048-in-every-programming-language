PRINT "Game 2048"

 10  REM  ************
 20  REM  *   2024   *
 30  REM  ************
 40  HOME 
 100 W = 2: REM    **** W=0 FOR LOOSE W=1 FOR WIN W=2 FOR PLAYING ****  
 110  DIM MA(4,4)
 120 FC = 16: REM   FREECELLS 
 130 A$ = "":SC = 0:MT = 2
 140  GOSUB 1000: DRAW THESCREEN
 150  GOSUB 1500: REM  PRINT SCORE AND MAXTILE
 160  GOSUB 1700: REM  BREED
 170  GOSUB 2000: REM  PRINT SCORES IN THE MATRIX AND CALC FC AND MT
 200  REM  ******************
 210  REM  MAIN PROGRAM
 220  REM  ******************
 230  HTAB 38: VTAB 22
 235  IF W < 2 THEN  GOTO 950: REM  ******* END GAME ********
 240  WAIT  - 16384,128:A =  PEEK ( - 16384) - 128 - 68: POKE  - 16368,0
 250  ON A GOTO 999,900,900,900,300,350,400,900,450
 280  REM  ************************
 285  REM  FOLLOWING LINES HANDLE THE UP, LEFT, RIGHT, DOWN, NOP, EXIT
 290  REM  ************************  
 300  GOSUB 2500: GOSUB 3500: GOSUB 2500: GOSUB 1700: GOSUB 2000: GOSUB 1
     500
 310  GOTO 200
 350  GOSUB 2600: GOSUB 3600: GOSUB 2600: GOSUB 1700: GOSUB 2000: GOSUB 1
     500
 360  GOTO 200
 400  GOSUB 2700: GOSUB 3700: GOSUB 2700: GOSUB 1700: GOSUB 2000: GOSUB 1
     500
 410  GOTO 200
 450  GOSUB 2800: GOSUB 3800: GOSUB 2800: GOSUB 1700: GOSUB 2000: GOSUB 1
     500
 460  GOTO 200
 900  GOTO 200
 950  HOME : VTAB 10
 960  PRINT "          ********************"
 970  IF W = 1 THEN  PRINT "          *    YOU   WIN     *"
 980  IF W = 0 THEN  PRINT "          *    YOU   LOOSE   *"
 990  PRINT "          ********************"
 995  PRINT "               SCORE  =";SC
 996  PRINT "               MAXTILE=";MT
 999  END 
 1000  REM  DRAW FRAME + SCORE
 1010  FOR I = 1 TO 5
 1020  VTAB 1 + (I - 1) * 4: PRINT "---------------------"
 1030  NEXT I
 1040  FOR I = 1 TO 4
 1050  FOR J = 1 TO 3
 1060  VTAB 1 + (I - 1) * 4 + J: PRINT "|    |    |    |    |"
 1070  NEXT J
 1080  NEXT I
 1090  HTAB 30: VTAB 3: PRINT "I";
 1100  HTAB 30: VTAB 9: PRINT "M";
 1110  HTAB 25: VTAB 6: PRINT "J";
 1120  HTAB 35: VTAB 6: PRINT "K";
 1130  HTAB 25: VTAB 12: PRINT "E = END"
 1140  HTAB 25: VTAB 14: PRINT "SCORE:"
 1150  HTAB 25: VTAB 16: PRINT "MAXTILE:"
 1160  HTAB 1: VTAB 19: PRINT "YOU CAN SLIDE  THE NUMBERS IN THE MATRIX"
 1170  HTAB 1: VTAB 20: PRINT "BY PRESSING IJKM. WHEN MATCHING NUMBERS"
 1180  HTAB 1: VTAB 21: PRINT "MEET THEY COMBINE IN THE SUM"
 1190  HTAB 1: VTAB 22: PRINT "TO WIN YOU HAVE TO REACH THE SUM 2048"
 1200  RETURN 
 1500  REM  ***************
 1501  REM  PRINT SCORE + MAXTILE
 1502  REM  ***************
 1510  VTAB 14: HTAB 32:
 1520 SC$ =  STR$ (SC):LS =  LEN (SC$)
 1530  FOR I = 1 TO 7 - LS: PRINT " ";: NEXT I
 1540  PRINT SC$
 1550  VTAB 16: HTAB 34:
 1560 MT$ =  STR$ (MT):LS =  LEN (MT$)
 1570  FOR I = 1 TO 5 - LS: PRINT " ";: NEXT I
 1580  PRINT MT$
 1590  IF SC = 2048 THEN W = 1: REM  ******** YOU WIN ********  
 1690  RETURN 
 1700  REM  ****************
 1701  REM  PUT A "2" IN A RANDOM EMPTY CELL
 1702  REM  ****************
 1708  IF FC = 0 THEN W = 0: GOTO 1800: REM  ***** YOU LOOSE *****
 1710 K =  INT ( RND (1) * FC + 1)
 1720 N = 0
 1730  FOR I = 1 TO 4
 1740  FOR J = 1 TO 4
 1750  IF MA(I,J) = 0 THEN N = N + 1
 1760  IF N = K THEN MA(I,J) = 2:FC = FC - 1:I = 4:J = 4
 1780  NEXT J
 1790  NEXT I
 1800  RETURN 
 2000  REM  *************
 2001  REM  WRITE THE CELL CONTENT AND CALC. FREECELLS AND MAXTILE
 2002  REM  *************
 2005 FC = 0:MT = 0: REM   INITIALIZE FREECELLS AND MAXTILES  
 2010  FOR I = 1 TO 4
 2020  FOR J = 1 TO 4
 2030  HTAB 2 + (J - 1) * 5: VTAB 3 + (I - 1) * 4
 2040  PRINT "    ";: HTAB 2 + (J - 1) * 5
 2050  IF MA(I,J) = 0 THEN FC = FC + 1: GOTO 2060
 2055  PRINT MA(I,J);
 2060  IF MA(I,J) > MT THEN MT = MA(I,J)
 2090  NEXT J
 2100  NEXT I
 2190  RETURN 
 2500  REM  *****************
 2510  REM   COMPACT UP - KIND OF BUBBLE SORT
 2520  REM  *****************
 2530  FOR J = 1 TO 4
 2540  FOR K = 3 TO 1 STEP  - 1
 2550  FOR I = 1 TO K
 2560  IF MA(I,J) = 0 THEN MA(I,J) = MA(I + 1,J):MA(I + 1,J) = 0
 2570  NEXT : NEXT : NEXT 
 2590  RETURN 
 2600  REM  ************
 2610  REM  COMPACT LEFT
 2620  REM  ************
 2630  FOR I = 1 TO 4
 2640  FOR K = 3 TO 1 STEP  - 1
 2650  FOR J = 1 TO K
 2660  IF MA(I,J) = 0 THEN MA(I,J) = MA(I,J + 1):MA(I,J + 1) = 0
 2670  NEXT : NEXT : NEXT 
 2690  RETURN 
 2700  REM   ************
 2710  REM   COMPACT RIGHT
 2720  REM   ************
 2730  FOR I = 1 TO 4
 2740  FOR K = 2 TO 4
 2750  FOR J = 4 TO K STEP  - 1
 2760  IF MA(I,J) = 0 THEN MA(I,J) = MA(I,J - 1):MA(I,J - 1) = 0
 2770  NEXT : NEXT : NEXT 
 2790  RETURN 
 2800  REM   *****************  
 2810  REM    COMPACT DOWN
 2820  REM   *****************  
 2830  FOR J = 1 TO 4
 2840  FOR K = 2 TO 4
 2850  FOR I = 4 TO K STEP  - 1
 2860  IF MA(I,J) = 0 THEN MA(I,J) = MA(I - 1,J):MA(I - 1,J) = 0
 2870  NEXT : NEXT : NEXT 
 2890  RETURN 
 3500  REM  ***************
 3510  REM  ADD UP
 3520  REM  ***************
 3530  FOR J = 1 TO 4
 3540  FOR I = 1 TO 3
 3550  IF MA(I,J) = MA(I + 1,J) THEN MA(I,J) = MA(I,J) * 2:MA(I + 1,J) = 
     0:SC = SC + MA(I,J)
 3560  NEXT : NEXT 
 3590  RETURN 
 3600  REM  **************
 3610  REM  SUM LEFT
 3620  REM  **************
 3630  FOR I = 1 TO 4
 3640  FOR J = 1 TO 3
 3650  IF MA(I,J) = MA(I,J + 1) THEN MA(I,J) = MA(I,J) * 2:MA(I,J + 1) = 
     0:SC = SC + MA(I,J)
 3660  NEXT : NEXT 
 3690  RETURN 
 3700  REM  **************
 3710  REM  SUM RIGHT
 3720  REM  **************
 3730  FOR I = 1 TO 4
 3740  FOR J = 4 TO 2 STEP  - 1
 3750  IF MA(I,J) = MA(I,J - 1) THEN MA(I,J) = MA(I,J) * 2:MA(I,J - 1) = 
     0:SC = SC + MA(I,J)
 3760  NEXT : NEXT 
 3790  RETURN 
 3800  REM   *************** 
 3810  REM   ADD DOWN
 3820  REM   ***************  
 3830  FOR J = 1 TO 4
 3840  FOR I = 4 TO 2 STEP  - 1
 3850  IF MA(I,J) = MA(I - 1,J) THEN MA(I,J) = MA(I,J) * 2:MA(I - 1,J) = 
     0:SC = SC + MA(I,J)
 3860  NEXT : NEXT 
 3890  RETURN 

-----
it runs somehow slowly but still fun to play. The only non standard basic is the input routine which reads directly the memory location (line 240) instead of using "input" od "get" 

---------------------
|    |    |    |    |
|4   |    |    |2   |        I
|    |    |    |    |
---------------------
|    |    |    |    |   J         K
|4   |2   |    |    |
|    |    |    |    |
---------------------        M
|    |    |    |    |
|2   |16  |4   |    |
|    |    |    |    |   E = END
---------------------
|    |    |    |    |   SCORE:    4924
|128 |512 |    |    |
|    |    |    |    |   MAXTILE:   512
---------------------

YOU CAN SLIDE  THE NUMBERS IN THE MATRIX
BY PRESSING IJKM. WHEN MATCHING NUMBERS
MEET THEY COMBINE IN THE SUM
TO WIN YOU HAVE TO REACH THE SUM 2048
