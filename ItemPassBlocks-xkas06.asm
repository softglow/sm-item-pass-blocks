; Copyright 2014 [softglow](https://github.com/softglow).  All rights reserved.
; See the file LICENSE for copying permissions.

; xkas v06
lorom

; I'm going to replace the collision code for Air Fool XRay blocks (or as
; Kejardon calls them, "XRay Air") wholesale.
;
; I've laid out this patch file from lowest to highest address.  Conceptually,
; it reads in order:
; 1. The first two pointers, hijacking existing Air Fool XRay code.
; 2. The pointer stubs they point to (short code in between BTS and main.)
; 3. Both of those end up in the "main" routine, the last code block.
; 4. The last code block reads the BTS table and jumps to BTS code before it.
; 5. BTS code does the actual checking, returns solid/air through the carry
;    flag (just like the original game).
; 6. We resume in the pointer stubs, just after the JSR, which either just
;    returns the "air" decision (carry clear) or jumps to the appropriate
;    (horiz. or vert.) solid block collision code.

; I would like to make enemies see these as solid and also make shots show
; whether you can/can't pass through.  I'm also not sure what happens if you
; turn the equipment off while inside such a block...


; Let's start by hijacking the collision pointers.
; These addresses are derived from:
; table_base_address + ( size_of_pointer * block_type )
; e.g. $9494D5 + 2*2 = $9494D5 + 4 = $9494D9

org $9494D9

DW $DED0 ; pointer to new horizontal collision

org $9494F9

DW $DEE0 ; pointer to new vertical collision


; Collision detection main routine (JSR'd by collision pointers)
org $94DE50

LDX $0DC4        ; load block index
LDA $7F6402,X    ; get block BTS
AND #$000F       ; limit to supported size
ASL              ; convert byte offset to word offset
TAX              ; move to X register for X-indexing
; OK, this is a bit tricky.  The original ROM has FFFF at this address.
; I'm going to check for that by adding 1.  If that results in 0000, then
; there is no pointer, and we will just do an air reaction.  (The trick is
; that "BEQ" is "Branch if Zero Set" because CMP actually subtracts: if the
; result is zero, they were equal.)
; Otherwise, we jmp to the BTS code, which will be responsible for issuing
; either SEC (solid) or CLC (air) before RTS.
LDA $DF00,X      ; load BTS pointer
INC              ; add 1 (FFFF -> 0000)
BEQ no_bts_ptr   ; if 0, no pointer! just be air.
JMP ($DF00,X)    ; jump into the BTS code

no_bts_ptr:
CLC              ; signal air-ness
RTS              ; return to block checks


; BTS pointer target (from new table used by BTS code, see end of file)
org $94DEB0

LDA $09A2        ; Active equipment (09A4 for collected)
; For all possible inventory bits, see the very last table in Kejardon's notes,
; sm_misc.txt.  $0100 is Hi-Jump Boots.
AND #$0100       ; Restrict to interesting bit
CMP #$0100       ; Check if the bit is set
BNE be_solid     ; equipment check failed (bit clear): make solid

CLC              ; equipment check passed (bit set): make air
RTS

be_solid:
SEC
RTS


; Collision detection pointer target: horizontal
org $94DED0
JSR $DE50
BCS h_solid
RTS
h_solid:
JMP $8F49        ; original solid block horizontal collision

; Collision detection pointer target: vertical
org $94DEE0
JSR $DE50
BCS v_solid
RTS
v_solid:
JMP $8F82        ; original solid block vertical collision


; BTS pointer in new table, for tile BTS $0E (*2 to account for pointer size)
org $94DF1C

DW $DEB0

