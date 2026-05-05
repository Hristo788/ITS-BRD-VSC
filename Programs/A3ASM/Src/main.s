;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register
                mov   r0,#0x12                      ; Anw-01 ; lädt die Konstante 0x12 in r0, da 0x12 kleiner als 255 ist, kann es direkt als Immediate-Wert in das Register geladen werden.
                mov   r1,#-128                      ; Anw-02 ; lädt die Konstante -128 in r1, da -128 kleiner als 255 ist, kann es direkt als Immediate-Wert in das Register geladen werden. Es wird als 0xFFFFFF80 im Register gespeichert, da ARM die Werte im Zweierkomplement darstellt.
                ldr   r2,=0x12345678                ; Anw-03 ; *lädt die Konstante 0x12345678 in r2, da 0x12345678 größer als 255 ist, kann es nicht direkt als Immediate-Wert in das Register geladen werden. Stattdessen wird die Adresse der Konstante im Speicher geladen, und der Wert wird von dieser Adresse in das Register geladen.
; Zugriff auf Variable
                ldr   r0,=VariableA                 ; Anw-04 ; lädt die Adresse von VariableA in r0
                ldrh  r1,[r0]                       ; Anw-05 ; lädt den Inhalt von VariableA (0x1234) in r1, 2 Bytes (halfword)
                ldr   r2,[r0]                       ; Anw-06 ; lädt den Inhalt von VariableA (0x1234) in r2, 4 Bytes (word), da VariableA als DCW definiert ist, wird der Wert 0x00001234 geladen
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07 ; *speichert den Wert von r2 (0x00001234) in VariableC, da VariableC direkt nach VariableA im Speicher liegt, wird die Adresse von VariableC durch die Berechnung VariableC-VariableA ermittelt, was 4 ergibt, da VariableA 2 Bytes (DCW) und VariableC 4 Bytes (DCD) belegt. Daher wird der Wert von r2 in die Adresse von VariableC geschrieben.	

; Zugriff auf Felder (Speicherzellen)
                ldr   r0,=MeinHalbwortFeld          ; Anw-08 ; lädt die Adresse von MeinHalbwortFeld in r0
                ldrh  r1,[r0]                       ; Anw-09 ; lädt den Inhalt der ersten Speicherzelle von MeinHalbwortFeld (0x22) in r1, 2 Bytes (halfword)
                ldrh  r2,[r0,#2]                    ; Anw-10 ; startet bei r0 im Register, da #2 angegeben ist, wird die Adresse von MeinHalbwortFeld um 2 Bytes erhöht, wodurch die zweite Speicherzelle (0x3e) geladen wird, da MeinHalbwortFeld als DCW definiert ist, werden die Werte als 2 Bytes (halfword) interpretiert.	
                mov   r3,#10                        ; Anw-11 ; speichert den Wert 1o in r3
                ldrh  r4,[r0,r3]                    ; Anw-12 ; lädt den Inhalt der Speicherzelle von MeinHalbwortFeld, die sich 10 Bytes (5 halfwords) von der Adresse in r0 "höher" befindet, da MeinHalbwortFeld als DCW definiert ist, werden die Werte als 2 Bytes (halfword) interpretiert. Daher wird die sechste Speicherzelle (0x45) geladen, da sie sich 10 Bytes von der ersten Speicherzelle entfernt befindet.

                ldrh  r5,[r0,#2]!                   ; Anw-13 ; lädt den Inhalt der zweiten Speicherzelle von MeinHalbwortFeld (0x3e) in r5, da #2 angegeben ist, wird die Adresse von MeinHalbwortFeld um 2 Bytes erhöht, wodurch die zweite Speicherzelle geladen wird. Das "!" am Ende der Anweisung bewirkt, dass die Adresse in r0 nach dem Laden automatisch um 2 Bytes erhöht wird, sodass r0 nun auf die dritte Speicherzelle von MeinHalbwortFeld zeigt.
                ldrh  r6,[r0,#2]!                   ; Anw-14 ; lädt den Inhalt der dritten Speicherzelle von MeinHalbwortFeld (-52) in r6, da #2 angegeben ist lädt er das zweite element, also er rutscht von r0 zwei bytes höher und lädt diesen Inhalt in r6 was dann dass zweite Element ist. Durch ! wird die Adresse in r0 nachdem laden um 2 Bytes erhöht.
                strh  r6,[r0,#2]!                   ; Anw-15 ; speichert er den Inhalt von r6 (-56) in die vierte Speicherzelle von MeinHalbwortFeld, da #2 angegeben ist und erhöht die Adresse von r0 durch das ! um 2 Bytes.

; Addition und Subtraktion von unsigned / signed Integer-Werten
                ldr  r0,=MeinWortFeld               ; Anw-16 ; lädt die Adresse von MeinWortFeld in r0
                ldr  r1,[r0]                        ; Anw-17 ; lädt den Inhalt der ersten Speicherzelle von MeinWortFeld (0x12345678) in r1, 4 Bytes (word)
                ldr  r2,[r0,#4]                     ; Anw-18 ; lädt den Inhalt von r0 um 4 Bytes erhöht, also die zweite Speicherzelle von MeinWortFeld 
                adds r3,r1,r2                       ; Anw-19 ; addiert den Wert von r1 und r2 und speichert das Ergebnis in r3 

                ldr  r4,[r0,#8]                     ; Anw-20 ; lädt den Inhalt von r0 um 8 Bytes erhöht, also die dritte Speicherzelle von MeinWortFeld in r4, das MeinWortFeld DCD = 4 Bytes
                ldr  r5,[r0,#12]                    ; Anw-21 ; lädt den Inhalt von r0 um 12 Bytes erhöht, also die vierte Speicherzelle von MeinWortFeld in r5, das MeinWortFeld DCD = 4 Bytes
                subs r6,r4,r5                       ; Anw-22 ; subtrahiert den Wert von r5 von r4 und speichert das Ergebnis in r6, 

                ldr  r7,[r0,#16]                    ; Anw-23 ; lädt den Inhalt von r0 um  16 Bytes erhöht, also die fünfte Speicherzelle von MeinWortFeld in r7, das MeinWortFeld DCD = 4 Bytes
                ldr  r8,[r0,#20]                    ; Anw-24 ; lädt den Inhalt von r0 um 20 Bytes erhöht, also die sechste Speicherzelle von MeinWortFeld in r8, das MeinWortFeld DCD = 4 Bytes
                subs r9,r7,r8                       ; Anw-25 ; subtrahiert den Wert von r8 von r7 und speichert das Ergebnis in r9, 

forever         b   forever                         ; Anw-26 ; Endlosschleife 
                ENDP
                END