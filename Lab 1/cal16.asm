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

	LHLD 8002H
	MVI C,00H
	XCHG
	LHLD 8004H
	DAD D
	JNC SKIP1
	INR C
	SKIP1: SHLD 8007H
	MOV A,C
	STA 8006H
	RST 5           
	
SUB:

	MVI C,00H
	MVI B,00H
	LHLD 8002H;	DE Contains A in A-B
	XCHG
	LHLD 8004H
	MOV A,E
	SUB L
	JNC SKIP2
	INR C
	SKIP2: MOV E,A
	MOV A,D
	SUB C
	SUB H
	JNC SKIP3
	INR B
	SKIP3: MOV D,A
	XCHG
	SHLD 8006H
	MOV A,B
	STA 8008H
    RST 5        
	
MUL:
	LHLD 8002H
	MOV A,H
	MOV H,L
	MOV L,A
	SPHL
	LHLD 8004H
	MOV A,H
	MOV H,L
	MOV L,A
	XCHG
	LXI H,0000H
	LXI B,0000H
	NEXT: DAD SP
	JNC LOOP4
	INX B
	LOOP4: DCX D
	MOV A,E
	ORA D
	JNZ NEXT
	
	MOV A,H
	MOV H,L
	MOV L,A
	SHLD 8008H ;LSB
	MOV L,B
	MOV H,C
	
	SHLD 8006H ;MSB
	RST 5           


DIV:

	LXI B, 0000H ;	BC HOLDS QUOTIENT
	
	LHLD 8004H ;	DE HOLDS DIVISOR
	MOV A,H
	MOV H,L
	MOV L,A
	MOV A,H
	ORA L
	JZ ZERO	; if divide by zero go to end!
	XCHG
	LHLD 8002H ;	DIVIDEND
	MOV A,H
	MOV H,L
	MOV L,A
	LOOP6: MOV A,L
	SUB E
	MOV L,A
	MOV A,H
	SBB D
	MOV H,A
	JC LOOP5
	INX B
	JMP LOOP6
	LOOP5: DAD D
	MOV A,H
	MOV H,L
	MOV L,A
	SHLD 8008H
	MOV L,B
	MOV H,C
	SHLD 8006H
ZERO:	RST 5