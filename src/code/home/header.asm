SETCHARMAP DialogCharmap

; Interrupts setup
section "RST 0x0000", rom0[$0000]
    jp   TableJump

; Debug Mode (see debug.asm)
; Uncomment to enable
section "Debug tool toggles", rom0[$0003]
IF DEF(ENABLE_DEBUG_1)
    db 1
ELSE
    db 0
ENDC
IF DEF(ENABLE_DEBUG_2)
    db 1
ELSE
    db 0
ENDC
IF DEF(ENABLE_DEBUG_3)
    db 1
ELSE
    db 0
ENDC

section "Interrupt VBlank", rom0[$0040]
    jp   InterruptVBlank

section "Interrupt LCD Stat", rom0[$0048]
    jp   InterruptLCDStatus

section "Interrupt Timer", rom0[$0050]
    reti

section "Interrupt Serial", rom0[$0058]
    jp   InterruptSerial

section "Interrupt Joypad", rom0[$0060]
    reti

; Data-copy routines
section "Hardcoded CopyData variants", rom0[$0062]

; Load 3 tiles of the meter that appears in the dialog box corner
; when a new Piece of Heart is found.
;
; The tiles are loaded at the place of the exchanged item and seashell tiles.
LoadPieceOfHeartMeterTiles1::
    ld   hl, PieceOfHeartMeterTiles
    ld   de, vTiles1 + $1A0
    jr   CopyTilesToPieceOfHeartMeter

LoadPieceOfHeartMeterTiles2::
    ld   hl, PieceOfHeartMeterTiles + $30
    ld   de, vTiles1 + $1D0
    jr   CopyTilesToPieceOfHeartMeter

; Restore the tiles that were overwritten by the Piece-of-Hearts meter.
ClearPieceOfHeartMeterTiles1::
    ld   hl, InventoryEquipmentItemsTiles + $1D0
    ld   de, vTiles1 + $1D0
    jr   CopyTilesToPieceOfHeartMeter

ClearPieceOfHeartMeterTiles2::
    ld   hl, InventoryEquipmentItemsTiles + $1A0
    ld   de, vTiles1 + $1A0

; Copy 3 tiles to VRAM,
; then clear the hBGTilesLoadingStage flags.
;
; Inputs:
;   hl   the source address of the tiles
;   de   the tiles destination address in vram
CopyTilesToPieceOfHeartMeter::
    ld   bc, $30
    call CopyData
    xor  a
    ldh  [hNeedsUpdatingBGTiles], a
    ldh  [hBGTilesLoadingStage], a
.restoreBank0C
    ld   a, $0C
    ld   [rSelectROMBank], a
    ret

section "ThiefDownside", rom0[$0091]
IF NO_THIEF_DOWNSIDES
ThiefEventCheck::
	ldh  a, [hMapId]	; $0091: $F0 $F7, Load Map ID
	cp   MAP_SHOP		; $0093: $FE $0E, Is map the shop?
	jr   nz, .not_shop	; $0095: $20 $0C, Increment if not in shop
	ldh  a, [hMapRoom]	; $0097: $F0 $F6
	cp   $A1		; $0099: $FE $A1, Is the current shop the one in Mabe Village?
	jr   nz, .not_shop	; $009B: $20 $06, Increment if it's not the Mabe Shop
	ld   a, [wDeathCount]	; $009D: $FA $57 $DB
	add  $00		; $00A0: $C6 00
	ret			; $00A2: $C9
.not_shop
	ld   a, [wDeathCount]	; $00A3: $FA $57 $DB
	add  $01		; $00A6: $C6 01
	ret			; $00A8: $C9
ENDC

section "Entry", rom0[$100]
    ; This is the entry point to the program.
    nop
    jp Start

section "Header", rom0[$104]
    ; The header is created by rgbfix.
    ; The space here is allocated as a placeholder.
    ds $150 - $104
