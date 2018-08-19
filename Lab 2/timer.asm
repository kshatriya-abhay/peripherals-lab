cpu "8085.tbl"
hof "int8"


;ORG 8FBFH                  ;putting ISR into the location
;JMP INTR
org 9000h
GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H


jmp start

INTR:
	push PSW
	CALL RDKBD
	pop PSW
	EI
	RET

DELAY:   ;Delay service routine
	MVI C, 0AH
	LOOP:  MVI D, 64H
	LOOP1:      MVI E, 0DAH
	LOOP2:      DCR E
	JNZ LOOP2
	DCR D
	JNZ LOOP1
	DCR C
	JNZ LOOP
	RET

change_hr:   ; update time on reaching 60 minutes
	MVI a,59h
	sta 9291h
	lda 9292h
	dcr a
	sta 9292h
	ani 0Fh
	cpi 0Fh
	cz hour1
	lda 9292h
	CPI 0F9h
	jz eop
	sta 9292h
	ret

change_min:   ;update time on reaching 60 seconds
	MVI a,59h
	sta 9290h
	lda 9291h
	dcr a
	sta 9291h
	ani 0Fh
	cpi 0Fh
	cz min1
	lda 9291h
	CPI 0F9h
	cz change_hr
	ret

displ:   ;Display the time on LEDs usnig UPDDT and UPDDA
	lda 9290h
	sta 8ff1h
	lda 9291h
	sta 8fefh
	lda 9292h
	sta 8ff0h
	mvi b, 01h
	CALL 044CH
	call 0440H
	ret

hour1:
	LDA 9292h
	SUI 06h
	STA 9292h
	RET
sec1:
	LDA 9290h
	SUI 06h
	STA 9290h
	RET
min1:
	LDA 9291h
	SUI 06h
	STA 9291h
	RET

	
onesecond: ;Routine for Clock
	
	call displ
	call delay
	MVI A,0BH
	SIM
	EI
	lda 9290h
	dcr a
	sta 9290h
	ani 0Fh
	cpi 0Fh
	cz sec1
	lda 9290h
	CPI 0F9h
	cz change_min
	jmp onesecond
	RET

start: 
	mvi a,0c3h
	sta 8fbfh
	mvi a,03h
	sta 8fc0h
	mvi a,90h
	sta 8fc1h
	call onesecond
eop:	rst 5
