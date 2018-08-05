cpu "8085.tbl"
hof "int8"
org 9000h

LDA 8001H

CPI 01h
JZ ADD

CPI 02h
JZ SUB

CPI 03h
JZ MUL

CPI 04h
JZ DIV

RST 5

ADD:

	MVI C, 00H      ; carry
        LDA 8002H       ; get first number
        MOV B, A        ; save in B
        LDA 8003H       ; get second number in A
        ADD B           ; A=A+B
        JNC LOOP1       ; if no carry, continue to store the val, and carry =0
        INR C           ; else carry=1
LOOP1:  STA 8004H       ; store the val
        MOV A, C        ; A=C
        STA 8005H       ; store the carry
        RST 5           ; stop

;for subtraction

SUB:

	MVI C, 00H   ; borrow
        LDA 8003H    ; get second number
        MOV B, A     ; save it in B
        LDA 8002H    ; get first number
        SUB B        ; A= A-B
        JP LOOP2      ; if result is +ve, skip complementing
        CMA          ; complement
        INR A        ; add one to get 2's complement
        INR C        ; saving borrow
LOOP2:   STA 8004H    ; saving the result
        MOV A, C     ; moving the borrow to A
        STA 8005H    ; saving the borrow
        RST 5        ; stop

;for multiplication

MUL:

	LDA 8002H       ; Load first number
        MOV B, A        ; Move to B
        CPI 00          ; if number is 0, jump to end and result=0
        JZ END1
        LDA 8003H       ; Load second number
        MOV C, A        ; Move to C
        CPI 00          ; if number is 0, jump to end and result=0
        JZ END1
        XRA A           ; A XOR A => A = 0 sweg
LOOP3:  ADD B           ; A=A+B
        DCR C           ; C = C-1
						; compare?
        JZ  END1         ; if C==0, jump to end and store result
        JMP LOOP3        ; Loop back n add again
END1:   STA 8004H       ; store result in memory
	RST 5           ; stop

;for division

DIV:

	MVI C,00H
	LDA 8003H
	CPI 00H
	JZ ZERO
	MOV B,A
	LDA 8002H
	LABEL: CMP B
	JC SKIP
	SUB B
	INR C
	JMP LABEL
	SKIP: STA 8005H
	MOV A,C
	STA 8004H
	ZERO: RST 5
