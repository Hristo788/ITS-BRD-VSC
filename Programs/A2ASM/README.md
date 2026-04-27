# Task 2 

##   BL initITSboard             ; needed by the board to setup
; Anw01 Lädt die Adresse von VariableA in R0
; Anw02 Lädt den Wert von Adresse VariableA in R2, aber nur das Niederwertige Byte
; Anw03 Lädt den Wert von VariableA in R3 aber nur den höherwertigen Byte
; Anw04 schiebt den Wert von R2 und schiebt ihn um 8 Bit nach links
; Anw05 Für jedes Bit von R2 und R3, wenn eines der Bits 1 ist, wird das entsprechende Bit in R2 auf 1 gesetzt. Ansonsten bleibt es 0.
; Anw06 Speichert R2 an die Adresse in R0, also in VariableA
; Anw07 Lädt den Wert von ConstByteA in R5
; Anw08 Speichert den Wert von R5 in die Adresse  R0 (VariableA)

; Anw09 Lädt die Adresse von VariableB in R1 
; Anw0A Lädt den Wert von VariableB in R6
; Anw0B Lädt den Wert 0x30ED in R7
; Anw0C addiert R6 und R7 also 0x1234 + 0x30ED und Speichert das Ergebnis in R6
; Anw0D Lädt den Wert von R6 in die Adresse von R1 (VariableB)
; Anw0E endlosschleife