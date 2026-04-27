;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke    
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     : 
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe
    
;* We need some data to work on
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000

;* We need minimal memory setup of InRootSection placed in Code Section 
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
    ldr     R0,=VariableA   ; Anw01 Lädt die Adresse von VariableA in R0
    ldrb    R2,[R0]         ; Anw02 Lädt den Wert von Adresse VariableA in R2, aber nur das Niederwertige Byte
    ldrb    R3,[R0,#1]      ; Anw03 Lädt den Wert von VariableA in R3 aber nur den höherwertigen Byte
    lsl     R2, #8          ; Anw04 schiebt den Wert von R2 und schiebt ihn um 8 Bit nach links
    orr     R2, R3          ; Anw05 Für jedes Bit von R2 und R3, wenn eines der Bits 1 ist, wird das entsprechende Bit in R2 auf 1 gesetzt. Ansonsten bleibt es 0.
    strh    R2,[R0]         ; Anw06 Speichert R2 an die Adresse in R0, also in VariableA

;* const in var
    mov     R5,#ConstByteA  ; Anw07 Lädt den Wert von ConstByteA in R5
    strh    R5,[R0]         ; Anw08 Speichert den Wert von R5 in die Adresse  R0 (VariableA)
    
    ldr     R0,=VariableC
    strh    R5,[R0]         

    ldrb    R8,[R0]         
    ldrb    R9,[R0,#1]      
    lsl     R8, #8
    orr     R8, R9         
    strh    R8,[R0]         


;* Change value from x1234 to x4321
    ldr     R1,=VariableB   
    ldrh    R6,[R1]         
    mov     R7, #0x21DE     
    add     R6, R6, R7      
    strh    R6,[R1]         
    b .                     

    
    ALIGN
    END