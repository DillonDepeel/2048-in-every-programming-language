.MODEL SMALL
.STACK 100H
NEW_LINE MACRO
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
ENDM

CLRSCR MACRO
    MOV AH, 6
    XOR AL, AL
    XOR CX, CX
    MOV DX, 184FH
    MOV BH, 7
    INT 10H
ENDM

MOVCURSOR_R MACRO
    MOV AH, 3
    XOR BH, BH
    INT 10H

    MOV AH, 2
    INC DL
    INT 10H
ENDM

MOVCURSOR_L MACRO
    MOV AH, 3
    XOR BH, BH
    INT 10H

    MOV AH, 2
    DEC DL
    INT 10H

ENDM

SETCURSOR MACRO R, C
    MOV AH, 2
    XOR BH, BH
    MOV DH, R
    MOV DL, C
    INT 10H
ENDM

NUMS MACRO LP1, LP2, LP3, LP4, CNT, OUTS, VAL
    CMP CHOISE, 1
    JE NUMBERS

ALPHABETS:
    MOV AL, VAL
    MOV AH, 9
    XOR BH, BH
    MOV CX, 1
    MOV BL, 34H
    INT 10H
    JMP OUTS

NUMBERS:
    MOV CX, 4
    MOV DL, VAL
    CMP DL, 0
    JE LP4:

    MOV AX, 1
    MOV CX, 0
    MOV CL, DL
    SUB CL, 'A'
    ADD CL, 1
    SAL AX, CL

    MOV LEN, 0
    MOV BL, 10
LP1:
	DIV BL

	MOV CX, 0
	MOV CL, AH
	ADD CL, 48
	PUSH CX
	ADD LEN, 1
	MOV AH, 0
	CMP AL, 0
	JNE LP1


	MOV AL, 4
	SUB AL, LEN
	CMP AL, 0
	JE CNT

	MOV CX, 0
	MOV CL, AL
	MOV AH, 2
	MOV DL, ' '
LP2:
    INT 21H
    LOOP LP2

CNT:
LP3:
	SUB LEN, 1
	POP AX
	MOV AH, 9
	XOR BH, BH
	MOV CX, 1
	MOV BL, 34H
	INT 10H
	MOVCURSOR_R
	CMP LEN, 0
	JNE LP3

	MOV DL, ' '
	INT 21H
	JMP OUTS

	MOV CX, 4

LP4:
	MOV AH, 2
	MOV DL, ' '
	INT 21H
	LOOP LP4
    INT 21H
OUTS:
ENDM

MACRO C_SCORE

   MOV AX, SCORE
   MOV DX, 0
   MOV BX, 10

   MOV LEN, 0

L1:
    MOV DX, 0
    DIV BX
    PUSH DX
    ADD LEN, 1
    CMP AX, 0
    JNE L1

	SETCURSOR 23, 25
	MOV AH, 9
	LEA DX, STR7
	INT 21H

L2:
    POP DX
    ADD DL, 48
    SUB LEN, 1
    MOV AH, 2
    INT 21H
    CMP LEN, 0
    JNE L2

ENDM

MACRO UNDERLINE
    MOV LEN, 10
UND:
	SUB LEN, 1
	MOV AH, 2
	MOV DL, '_'
	INT 21H
	CMP LEN, 0
	JNE UND
ENDM


MACRO UNUNDERLINE UNUND
    MOV LEN, 10
UNUND:
	SUB LEN, 1
	MOV AH, 2
	MOV DL, ' '
	INT 21H
	CMP LEN, 0
	JNE UNUND
ENDM

MACRO COOL G1, G2, G3, E1, STR

    LEA SI, STR
G1:
	MOV DL, [SI]
	CMP DL, '$'
	JE E1
	MOV TMP1,DL
	MOV TMP2, DL
	MOV LEN, 12
	MOV DL, TMP1
G2:
	DEC LEN
	INC TMP1
	MOV AL, TMP1
	MOV CX, 1
	MOV AH, 9H
	INT 10H
	MOV CX, 30000
G3:
	LOOP G3
	CMP LEN, 0
	JNE G2

	MOV AL, TMP2
	MOV CX, 1
	MOV AH, 9H
	INT 10H
	MOVCURSOR_R
	INC SI
	JMP G1
E1:
ENDM

.DATA
ARR DB 17 DUP(0)
BEG DB 0
SCORE DW 0
TSC DW 1
CALC DB 0
USERIN DB ?
CSR DB 0		;CURSOR ROW POSITION
CSC DB 0 		;CURSOR COLUMN POSITION
LEN DB 0
TMP DW ?
TMP1 DB ?
TMP2 DB ?
TMP3 DB ?
FLAG DB 'A'
FLAG2 DB 0
DONE DB 0
CHOISE DB 0		;FOR GAME MODE
MODE DB 0
STR1 DB "YOU LOSE...$"
STR2 DB "YOU ARE A WINNER!$"
STR3 DB "L = LEFT, R = RIGHT, U = UP, D = DOWN"
STR4 DB "2048 GAME $"
STR5 DB "GAME ENDED... PRESS Esc$"
STR6 DB "PRESS Esc FOR MENU$"
STR7 DB "SCORE: $"
STR8 DB "** 2048 **$"
STR9 DB "1. ADVANCED MODE$"
STR10 DB "2. KID MODE$"
STR11 DB "EXIT$"
STRZ DB 2 DUP("$")
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

SETWINDOW:				;SET WINDOW SIZE TO 40*25
	MOV AH, 0
	MOV AL, 1
	INT 10H

INITIALIZE:				;PRINT HOME PAGE
	MOV SCORE, 0 
    MOV AH, 9
	MOV AL, ' '
	XOR BH, BH 			;SET TEXT COLOUR FOR STR8
	MOV BL, 10
	MOV CX, 200
	INT 10H

    SETCURSOR 4, 14
    COOL PP1, PP2, PP3, PP4, STR8
    SETCURSOR 8, 10

    MOV AH, 9
	MOV AL, ' '
	XOR BH, BH 			;SET TEXT COLOUR FOR STR9 AND STR10
	MOV BL, 15
	MOV CX, 251
	INT 10H

    MOV AH, 9
    LEA DX, STR9
    INT 21H

    SETCURSOR 12, 10
    MOV AH, 9
    LEA DX, STR10
    INT 21H

    SETCURSOR 16, 10

    MOV AH,9
	MOV AL, ' '
	XOR BH, BH
	MOV BL, 12
	MOV CX, 100			;SET TEXT COLOUR FOR STR11
	INT 10H
    MOV AH, 9
    LEA DX, STR11
    INT 21H

    MOV CSR, 9
    SETCURSOR CSR, 10
    MOV CHOISE, 1

MENU:					;CREATE THE MENU
	SETCURSOR CSR, 10
	UNDERLINE			;UNDERLINE CURRENT SELECTION
	MOV AH, 0
	INT 16H

	CMP AH, 50H 		;DOWN
	JE LOWER
	CMP AH, 48H 		;UP
	JE UPPER
	CMP AH, 1CH
	JE BACKGROUND
	JMP MENU

LOWER:					;MOVES UNDERLINE LOWER IF POSSIBLE
	CMP CSR, 17
	JE MENU
	SETCURSOR CSR, 10
	UNUNDERLINE T1
	ADD CSR, 4
	ADD CHOISE, 1 		;DETERMINES THE SELECTION
	SETCURSOR CSR, 10
	JMP MENU
UPPER:					;MOVES UNDRLINE UPPER IF POSSIBLE
	CMP CSR, 9
	JE MENU
	SETCURSOR CSR, 10
	UNUNDERLINE T2
	SUB CSR, 4
	SUB CHOISE, 1 		;DETERMINES THE SELECTION
	SETCURSOR CSR, 10
	JMP MENU

BACKGROUND:				;SET BACKGROUND
	CMP CHOISE, 3
	JE EXIT

    MOV AH, 6
    MOV CX, 0
    MOV DH, 24
    MOV DL, 39
    MOV BH, 30H
    MOV AL, 0
    INT 10H

    LEA SI, ARR
    MOV CX, 17
SET_0:					;RESET ARRAY TO ZERO
	MOV [SI], 0
	INC SI
	LOOP SET_0

BEGIN:					;GAME BEGINS

	MOV AH, 2CH			;GET THE TIME
	INT 21H

RANDOMIZE:				;SELECTS RANDOM POSITION AND VALUE
	MOV AX, 0
	MOV AL, DL			;AX HAS MILISECONDS
	MOV DL, 16
	DIV DL				;THIS CUASES REMAINDER TO BE WITHIN 0 OT 15
	MOV BEG, AH			;BEG HAS THE REMAINDER

	SHR AH, 1 			;IF REMAINDER IS ODD 2 WILL APPEAR ELSE 4 WILL APPEAR
	JC FOUR

	MOV FLAG, 'A'
	JMP SEARCHING

FOUR:
	MOV FLAG, 'B'

SEARCHING:				;SEARCHING FOR EMPTY POSITION
	LEA SI, ARR			;STARTING FROM THE POSITION
	MOV AX, 0			;REPRESENTED BY BEG
	MOV AL, BEG
	ADD AX, 1			;ADDING 1 SO POSITION WILL BE IN 1 TO 16
	ADD SI, AX

	MOV CX, 16
ROUND:
	CMP [SI], 0
	JE PLACEVAL

	CMP SI, 16
	JNE NORESET
RESET:
	LEA SI, ARR
	INC SI
	JMP LAST

NORESET:
    INC SI
LAST:
    LOOP ROUND
    JMP NEXT

PLACEVAL:				;PLACES VALUE IN [SI]
	MOV DL, FLAG
	MOV [SI], DL
	JMP NEXT

NEXT:
GRID:					;PRINTS THE GRID
	MOV TMP1, 5
	MOV CSR, 0
GROW:
	SUB TMP1, 1
	SETCURSOR CSR, 0
	MOV CX, 39
GCOL:
	MOV AH, 2
	MOV DL, 220;;
	INT 21H
	LOOP GCOL
	ADD CSR, 5
	CMP TMP1, 0
	JNE GROW

	MOV TMP1, 5
	MOV CSC, 1
GCOL2:
	SUB TMP1, 1
	MOV CSR, 0
	SETCURSOR CSR, CSC
	MOV CX, 22
GROW2:
	MOV AH, 2
	MOV DL, 221;;
	INT 21H
	ADD CSR, 1
	SETCURSOR CSR, CSC
	LOOP GROW2
	ADD CSC, 9
	CMP TMP1, 0
	JNE GCOL2

PRINT:					;PRINTS THE NUMBERS IN THE GRID
    LEA SI, ARR
    INC SI
    MOV TMP2, 4
    MOV AH, 2
    MOV TMP1, 0
    MOV FLAG, 0
    MOV CSR, 3
ROWP:
	SUB TMP2, 1
	MOV TMP3, 4
	MOV CSC, 4

COLUMN:
	SUB TMP3, 1
	MOV DL, [SI]
	MOV DONE, DL
	CMP DL, 0
	JNE CONT1
	MOV FLAG, 1				;CHECKS FOR EMPTY POSITION

CONT1:
	CMP DL, 'K'				;WINNING CONDITION
	JNE CONT2
	MOV TMP1, 'K'

CONT2:
	SETCURSOR CSR, CSC
	NUMS P1, P2, P3, P4, C1, O2, DONE
	INC SI
	ADD CSC, 9
	CMP TMP3, 0
	JNE COLUMN
	NEW_LINE
	ADD CSR, 5
	CMP TMP2, 0
	JNE ROWP
    NEW_LINE
    C_SCORE					;PRINT SCORE

    CMP TMP1, 'K'			;CHECKS WINNING CONDITION
    JE WIN

    MOV AH, FLAG			;CHECKS LOSING CONDITION
    CMP AH, 1
    JNE LOSE

INPUT:						;TAKES USER INPUT
    SETCURSOR 23, 0
    MOV DONE, 0
    MOV AH, 0
    INT 16H
    MOV USERIN, AH

    CMP USERIN, 4BH			;LEFT
    JNE NEXT1

LEFT:
	MOV CX, 4
	MOV BX, 1
ROWSL:
	LEA SI, ARR
	ADD SI, BX
	ADD BX, 4

	MOV DI, SI
	INC DI

	MOV DL, 3
WHILEL:
	MOV AL, [SI]
	MOV AH, [DI]
	CMP SI, DI
	JE NOWORKL
	CMP AH, 0
	JNE WORKL
NOWORKL:
	INC DI
	DEC DL
	JMP END_WORKL

WORKL:
	CMP AL, 0
	JE REPLACEL

	NOREPLACEL:
	CMP AL, AH
	JE MERGEL
NOMERGEL:
	INC SI
	JMP END_WORKL

MERGEL:
	MOV DONE, 1

	MOV TMP1, AL
	MOV TSC, 1
	MOV CALC, AL
	SUB CALC, 'A'
	ADD CALC, 1
SHIFTL:
	DEC CALC
	SHL TSC, 1
	CMP CALC, 0
	JNE SHIFTL
	MOV AX, TSC
	ADD SCORE, AX
	ADD SCORE, AX

	MOV AL, TMP1
	INC AL
	MOV [SI], AL
	MOV [DI], 0
	INC SI
	INC DI
	DEC DL
	JMP END_WORKL

REPLACEL:
	MOV DONE, 1
	MOV [SI], AH
	MOV [DI], 0

END_WORKL:

	CMP DL, 0
	JE END_WHILEL
	JMP WHILEL ;LOOP
END_WHILEL:
    LOOP ROWSL
    CMP DONE, 0
    JE PRINT
    JMP BEGIN

NEXT1:
    CMP USERIN, 4DH         ;RIGHT
    JNE NEXT2
RIGHT:
	MOV CX, 4
	MOV BX, 4
ROWSR:

	LEA SI, ARR
	ADD SI, BX
	ADD BX, 4

	MOV DI, SI
	DEC DI

	MOV DL, 3
WHILER:
	MOV AL, [SI]
	MOV AH, [DI]
	CMP SI, DI
	JE NOWORKR
	CMP AH, 0
	JNE WORKR

NOWORKR:
	DEC DI
	DEC DL
	JMP END_WORKR
WORKR:
	CMP AL, 0
	JE REPLACER

NOREPLACER:
	CMP AL, AH
	JE MERGER

NOMERGER:
	DEC SI
	JMP END_WORKR

MERGER:
	MOV DONE, 1

	MOV TMP1, AL
	MOV TSC, 1
	MOV CALC, AL
	SUB CALC, 'A'
	ADD CALC, 1
SHIFTR:
	DEC CALC
	SHL TSC, 1
	CMP CALC, 0
	JNE SHIFTR
	MOV AX, TSC
	ADD SCORE, AX
	ADD SCORE, AX

	MOV AL, TMP1

	INC AL
	MOV [SI], AL
	MOV [DI], 0
	DEC SI
	DEC DI
	DEC DL
	JMP END_WORKR

REPLACER:
	MOV DONE, 1
	MOV [SI], AH
	MOV [DI], 0

	END_WORKR:
	CMP DL, 0
	JE END_WHILER
	JMP WHILER

END_WHILER:
    LOOP ROWSR
    CMP DONE, 0
    JE PRINT

    JMP BEGIN

NEXT2:
    CMP USERIN, 48H         ;UP
    JNE NEXT3
UP:
	MOV CX, 4
	MOV BX, 1
ROWSU:
	LEA SI, ARR
	ADD SI, BX
	ADD BX, 1

	MOV DI, SI
	ADD DI, 4

	MOV DL, 3
WHILEU:
	MOV AL, [SI]
	MOV AH, [DI]
	CMP SI, DI
	JE NOWORKU
	CMP AH, 0
	JNE WORKU

NOWORKU:
	ADD DI, 4
	DEC DL
	JMP END_WORKU

WORKU:
	CMP AL, 0
	JE REPLACEU

NOREPLACEU:
	CMP AL, AH
	JE MERGEU
NOMERGEU:
	ADD SI, 4
	JMP END_WORKU
MERGEU:
	MOV DONE, 1
	MOV TMP1, AL
	MOV TSC, 1
	MOV CALC, AL
	SUB CALC, 'A'
	ADD CALC, 1
SHIFTU:
	DEC CALC
	SHL TSC, 1
	CMP CALC, 0
	JNE SHIFTU
	MOV AX, TSC
	ADD SCORE, AX
	ADD SCORE, AX

	MOV AL, TMP1

	INC AL
	MOV [SI], AL
	MOV [DI], 0
	ADD SI, 4
	ADD DI, 4
	DEC DL
	JMP END_WORKU

REPLACEU:
	MOV DONE, 1
	MOV [SI], AH
	MOV [DI], 0

END_WORKU:
	CMP DL, 0
	JE END_WHILEU
	JMP WHILEU

END_WHILEU:
	LOOP ROWSU
	CMP DONE, 0
    JE PRINT
    JMP BEGIN

NEXT3:
	CMP USERIN, 50H         ;DOWN
	JNE NEXT4
DOWN:
	MOV CX, 4
	MOV BX, 13
ROWSD:
	LEA SI, ARR
	ADD SI, BX
	ADD BX, 1

	MOV DI, SI
	SUB DI, 4
    MOV DL, 3
WHILED:
	MOV AL, [SI]
	MOV AH, [DI]
	CMP SI, DI
	JE NOWORKD
	CMP AH, 0
	JNE WORKD
NOWORKD:
	SUB DI, 4
	DEC DL
	JMP END_WORKD

WORKD:
	CMP AL, 0
	JE REPLACED

NOREPLACED:
	CMP AL, AH
	JE MERGED

NOMERGED:
	SUB SI, 4
	JMP END_WORKD

MERGED:
	MOV DONE, 1

	MOV TMP1, AL
	MOV TSC, 1
	MOV CALC, AL
	SUB CALC, 'A'
	ADD CALC, 1
SHIFTD:
	DEC CALC
	SHL TSC, 1
	CMP CALC, 0
	JNE SHIFTD
	MOV AX, TSC
	ADD SCORE, AX
	ADD SCORE, AX

	MOV AL, TMP1

	INC AL
	MOV [SI], AL
	MOV [DI], 0
	SUB SI, 4
	SUB DI, 4
	DEC DL
	JMP END_WORKD

REPLACED:
	MOV DONE, 1
	MOV [SI], AH
	MOV [DI], 0

END_WORKD:
	CMP DL, 0
	JE END_WHILED
	JMP WHILED

END_WHILED:
	LOOP ROWSD
	CMP DONE, 0
	JE PRINT
	JMP BEGIN
NEXT4:					    ;USER DOESN'T WANT TO PLAY :(
	CMP USERIN, 01H
	JNE NEXT5
	CLRSCR
	JMP INITIALIZE
NEXT5:					    ;INVALID INPUT
    JMP INPUT

LOSE:
	SETCURSOR 10, 8
	COOL Z1, Z2, Z3, Z4, STR5
	MOV AH, 0
	INT 16H
	CMP AH, 01H
	JNE LOSE

	CLRSCR
LOSE1:
	MOV BX, 6
	MOV CSR, 10
	MOV CSC, 14
	SETCURSOR CSR, CSC
	COOL Q1, Q2, Q3, Q4, STR1
	MOV AH, 0
	INT 16H
	CMP AH, 01H
	JNE LOSE1
	CLRSCR
	JMP INITIALIZE

WIN:
	SETCURSOR 10, 8
	COOL Y1, Y2, Y3, Y4, STR5
	MOV AH, 0
	INT 16H
	CMP AH, 01H
	JNE WIN
	CLRSCR
WIN1:
	LEA DI, STR2
	MOV BX, 5
	MOV CSR, 5
	MOV CSC, 10
	SETCURSOR CSR, CSC

MSG1:
    CMP [DI], '$'
    JE END_MSG1
    MOV AL, [DI]
    LEA SI, STRZ
    MOV [SI], AL
    COOL X1, X2, X3, X4, STRZ
    INC BX
    INC DI
    CMP BX, 16
    JNE MSG1
    MOV BX, 10
    JMP MSG1
END_MSG1:
    MOV AH, 0
    INT 16H
    CMP AH, 01H
    JNE WIN1
    CLRSCR
    JMP INITIALIZE
EXIT:
    CLRSCR
    MOV AH,4CH
    INT 21H
    MAIN ENDP

END MAIN
