[org 0x100]

jmp start
oldisr: dd 0
m1: dw '*'
roww: dw  15
coll: dw   0
rowBuild: dw 2,3,0,2,0,5,2,4,3,5
colBuild: dw 0,11,22,38,51,66,82,96,110,121
rowCar1: dw 11,12,13,14
colCar1: dw 30
rowCar2: dw 11,12,13,14
colCar2: dw 60

platFormRow: dw 37,31,22
platFormCol: dw 52,52
platFormSize: dw 20
platAscii: dw '*'
checkByte: dw 0

pauseStore: times 11616 dw 0

rabbitRow: dw 38,39,40,41
rabbitCol: dw 68
rabbitSize: dw 5

rabbitRow1: dw 30,31,32,33
rabbitCol1: dw 58
rabbitSize1: dw 5

ScoreRow: dw 21
ScoreCol: dw 120
ScoreString: dw 'Score: '
ScoreLength: dw 7
ScoreValue: dw 0

buffer: times 1320 dw 0

r1: dw ' //  '
r2: dw ' (-> '
r3: dw ' /rr '
r4: dw '*\))_'

tickcount: dw 0
BlueCountFlag: dw 0
BlueEnd: dw 0
GameOverFlag: dw 0
seed: db 0
seed2: db 0

v1: dw ' _________________   '
v2: dw '|             |___\  '  
v3: dw '|         -        \ '
v4: dw '|__(o)________(o)__| '
attribute: dw 9
carSize: dw 21


c2: db '\/'
carrotPosition: db 0
rowrestore: dw 29
storekaro: dw 37,33
clrsegmentrow: dw 37,32
restorerabbitrow: dw 32,27

fprow: dw 26,25,32
fpcol: dw 60,50,45
tbrow: dw  19
tbrow2: dw 42
tbrow3: dw 26
tbrow4: dw 34

buffer2:  times 264 dw 0
buffer3:  times 264 dw 0
buffer4:  times 264 dw 0
buffer5:  times 264 dw 0
 
oldkb: dd 0

msg_start: dw 'Welcome to the Game!!!'
msg_Names : dw 'Mujtaba Ahmed & Aun Ali'
msg_RollNum: dw '22L-6908 & 22L-6783'
msg_Instructions1: dw 'Instructions:'
msg_Instructions2: dw 'Press up-key to jump and try to score maximum points '
msg_Continue: dw 'Press Any Key to Continue......'
msg_GameOver: dw 'Unlucky Game Over!!'
msg_PauseScreen: dw 'Are you sure you want to exit?'

display: db '*'
colGraphic: db 10
check: db 13
enterName: db 'LOADING'
 
rabbitstorage: times 1320 dw 0
Plat_Form_Mover: dw 35
game_iterator: db 10
bool_check: db 0
bool_movement:db 0



bool_initial:db 20
Right_BOOL:db 40
Left_BOOL:db 40
Right_BOOL2:db 0
Left_BOOL2:db 0
check_jump_occ:db 0

random_color:db 0
checkFlag_B: db 0
counter: dw 5
;__________________________________________________________________________________
clrscrUpper:

push es
push ax
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column

nextloc1: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 3828; (13*132+132)*2
jne nextloc1 ; if no clear next position

pop di
pop ax
pop es
ret


clrscrMiddle:
push es
push ax
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 3960;3696 ; point di to top left column;3432

nextloc2: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 5016;5016 ; has the whole screen cleared
jne nextloc2 ; if no clear next position

pop di
pop ax
pop es
ret
;_____________________________________________________________________________________________________________
clrSegment:
push bp
mov bp,sp
push es
push ax
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di,132
mov ax ,[bp+6]
imul di,ax
add di,[bp+4]
imul di,2

mov bx,di
add bx,1320


nextloc4: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, bx ; has the whole screen cleared
jne nextloc4 ; if no clear next position

pop di
pop ax
pop es
pop bp
ret 4
;______________________________________________________________________________________________________________
segmentclear:
            push bp
mov bp,sp
push es
push ax
push di
            push bx

mov ax, 0xb800
mov es, ax ; point es to video base

mov al, 132 ; load al with columns per row
mul byte [bp+6] ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)
mov di,ax
mov bx,ax
add bx,1584               ; 792

nextloc: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, bx ; has the whole screen cleared
jne nextloc ; if no clear next position
           
pop bx
pop di
pop ax
pop es
pop bp
ret 4

;______________________________________________________________________________________________________________

clrscrBottom:

push es
push ax
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 5016 ; from 18th row to end

nextloc3: mov word [es:di], 0x0720 ;2020 clear next char on screen
add di, 2 ; move to next screen location
cmp di, 11352 ; has the whole screen cleared
jne nextloc3 ; if no clear next position

pop di
pop ax
pop es
ret

;_____________________________________________________________________________________
printbuilding:

push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx      ; it needs to be popped
push si
push di

mov bh,0x18

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0
mov si,m1
mov cl,[bp+4];loop
mov ch,[bp+6];col
mov bl,[si]
mov dx,0

building1:
add dl,1
mov si,m1
mov bl,[si]
call formulaBuild
mov di,ax
mov [es:di], bx
inc byte[bp+6]
cmp dl,cl
jnz building1

call resetColb
mov dx,0
inc byte[bp+8];row
mov dl,[bp+8]
cmp dl,10
mov dx,0
jnz building1
mov dx,0
mov di,0

jmp f
mov bh,0x11

resetColb:
dec byte[bp+6]
cmp byte[bp+6],ch
jnz resetColb
ret

f:
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6


formulaCar:
mov al,132
mul byte[bp+6]
add ax,[bp+4]
shl ax,1
ret

formulaBuild:
mov al,132
mul byte[bp+8];row
add ax,[bp+6];col
shl ax,1
ret
;______________________________________________________________________________________________________________

Delay:
push ax
push cx

mov ax, 3

Delay_OuterLoop:
mov cx, 0xFFFF
Delay_InnerLoop:
loop Delay_InnerLoop

dec ax
jnz Delay_OuterLoop

pop cx
pop ax
ret


; Delay2:
; push ax
; push cx

; mov ax, 10

; Delay_OuterLoop2:
; mov cx, 0x1112
; Delay_InnerLoop2:
; loop Delay_InnerLoop2

; dec ax
; jnz Delay_OuterLoop2

; pop cx
; pop ax
; ret

;_____________________________________________________________________________________________________________
printroad:

push bp
mov bp, sp
push es
push ax
push bx
push dx      
push cx
push si
push di
mov bh,0x77

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0
mov bl,[si]
mov dx,0

road1:
add dx,1
mov si,m1
mov bl,[si]
mov al,132
mul byte[roww]
add ax,[coll]
shl ax,1
mov di,ax
mov [es:di], bx
inc byte[coll]
cmp dx,132
jnz road1

call resetColl
mov dx,0
inc byte[roww]
mov dl,byte[roww]
cmp dl,18
mov dx,0
jnz road1
mov dx,0
mov di,0

jmp finish

resetColl:
dec byte[coll]
cmp byte[coll],0
jnz resetColl
ret

finish:
pop di
pop si
pop cx
pop dx
pop bx
pop ax
pop es
pop bp
ret


;_____________________________________________________________________________________________________________
setCar:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov ax, 0xb800
mov es, ax ; point es to video base

mov al, 132 ; load al with columns per row
mul byte [bp+10] ; 132 x r
add ax, [bp+8] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)

mov di, ax ; point di to required location
mov si, [bp+6] ; point si to string
mov cx, [bp+4] ; load length of string in cx
mov ah, [attribute] ; load attribute in ah

printCar:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop printCar

pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8

;_____________________________________________________________________________________________________

setRabbit:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov ax, 0xb800
mov es, ax ; point es to video base

mov al, 132 ; load al with columns per row
mul byte [bp+8] ; 132 x r
add ax, [bp+6] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)

mov di, ax ; point di to required location
mov si, [bp+4] ; point si to string
mov cx, [rabbitSize] ; load length of string in cx
mov ah, 0x09 ; load attribute in ah
printRabbit:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop printRabbit
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 6

;_____________________________________________________________________________________________________________
restoreRabbit:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov ax,0xb800
mov es, ax

mov di,132
imul di,[rowrestore] ;[bp+6]
add di,0;[bp+4]
imul di,2

mov si, buffer
mov cx,1320
restoreLoop:

mov ax,[si]
mov [es:di],ax
inc si
inc di
loop restoreLoop

pop di
pop si
pop cx
pop ax
pop es
pop bp
ret

;______________________________________________________________________________________________________________
rabbitJump:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov ax,[bp+4]
push ax
call bufferStoring
mov ax,[bp+6]   ; row number                                
push ax
mov ax ,0    ; col number                                  
push ax
call clrSegment

call restoreRabbit

pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 6

;______________________________________________________________________________________________________________
initial_Plat_form:

mov ah,6
mov al,0
mov bh,4bh;00111011b
mov ch,34
mov cl,60;58
mov dh ,34
mov dl,80;78
int 10h

mov ah,6
mov al,0
mov bh,6bh;00111011b
mov ch,26
mov cl,60
mov dh ,26
mov dl,80
int 10h
ret
;_________________________________________________________________________________________________

;______________________________________________________________________________________________________________
Move_firstPortion:

push bx
push ax
push cx
xor ax,ax
mov bx, 10
inc bx
     ; row starting at 1

Move_Left:
mov cx, ax
push cx                   ; row number to be shifted
call SLeft

inc ax
cmp ax, bx
jnz Move_Left

pop cx
pop ax
pop bx
ret
SLeft:
push bp
mov bp, sp
sub sp, 4 ; 1 word space for local variable
push ax ; bp - 2 = 132 i.e total columns ; bp - 4 = temporary extreme left pixel stored

mov ax, 132
mov [bp-2], ax

push ds
push es
push di
push cx
push si

mov ax, 0xb800
mov es, ax
mov ds, ax

; Copy extreme left character
mov di, [bp-2]
mov ax, [bp+4]           ; row number 0
dec ax;FFFF
imul di, ax ; (row number * 132) * 2
imul di , 2
mov ax, [es:di]
mov [bp-4], ax ; temporary stored

mov di, [bp-2]
mov ax, word[bp+4]
dec ax
imul di, ax
imul di, 2

mov si, [bp-2]
imul si, ax
imul si, 2
add si, 2

mov cx, [bp-2]
;std
cld
rep movsw

; Paste extreme left character to extreme right
mov di, [bp-2]
imul di, word[bp+4]
imul di, 2
sub di, 2
mov ax, [bp-4]
mov [es:di], ax

pop si
pop cx
pop di
pop es
pop ds
pop ax
mov sp, bp
pop bp
ret 2




MoveSecondSegment:

push bx
push ax
push cx
xor ax,ax
mov bx, 18    ; Previous segment ended at row 18
inc bx
     ; row starting at 1
mov ax,12
M_Right:
mov cx, ax
push cx                   ; row number to be shifted
call SRight

inc ax
cmp ax, bx
jnz M_Right

pop cx
pop ax
pop bx
ret
SRight:
push bp
mov bp, sp
sub sp, 4 ; 1 word space for local variable
push ax ; bp - 2 = 132 i.e total columns ; bp - 4 = temporary extreme left pixel stored

mov ax, 132
mov [bp-2], ax

push ds
push es
push di
push cx
push si

mov ax, 0xb800
mov es, ax
mov ds, ax


mov di, [bp-2]
mov ax, [bp+4]           ; row number 0
dec ax;FFFF
imul di, ax ; (row number * 132) * 2
imul di , 2
add di,262
mov ax, [es:di]
mov [bp-4], ax ; temporary stored



mov di, [bp-2]
mov ax, word[bp+4]
dec ax
imul di, ax
imul di, 2
add di,2

mov si, [bp-2]
imul si, ax
imul si, 2
;add si, 2

mov cx, [bp-2]
std

rep movsw


mov di, [bp-2]
imul di, word[bp+4]
imul di, 2
;sub di, 2
sub di,262
mov ax, [bp-4]
mov [es:di], ax

pop si
pop cx
pop di
pop es
pop ds
pop ax
mov sp, bp
pop bp
ret 2
;______________________________________________________________________________________________________________

;new work from this line till 1014
saveScreen: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
mov ax,0xb800
mov es,ax
mov di, 132 ; load al with columns per row
imul di, [bp+6] ; 132 x r
add di, [bp+4] ; word number (132xr) + c
shl di, 1 ; byte no (((132xr) + c)x2)

mov cx,1320   ; size of buffer
mov si,rabbitstorage   ; BUFFER NAME
saveloop:
mov ax, [es:di] ; no, save this character
mov [si],ax
inc si
inc di
loop saveloop
            
pop ds
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 4



shiftright:
push bp
mov bp,sp
push es
push ax
push cx
push si
push di
push ds
push bx
push dx
mov ax, 0xb800
mov es, ax ; point es to video base
            mov ds,ax

mov al, 132 ; load al with columns per row
mul byte [bp+6]    ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)

mov di, ax ; point di to required location
mov si,ax
mov dx,ax
add si,260
add di,262
mov cx,132
mov bx,[es:di]           ;store last value in bx
std                      ;auto decrement mode
rep movsw                ;movs from [ds:si] to [es:di]
mov di,dx
mov [es:di],bx ;add last value to the start

pop dx
pop bx
pop ds
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 4


shiftleft:
push bp
mov bp,sp
push es
push ax
push cx
push si
push di
push ds
push bx
push dx
mov ax, 0xb800
mov es, ax ; point es to video base
            mov ds,ax

mov al, 132 ; load al with columns per row
mul byte [bp+6]    ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)

mov di, ax ; point di to required location
mov si,ax
mov dx,di
mov bx,[es:di]

add si,2

mov cx,132

cld
rep movsw
mov di,dx
add di,262
mov [es:di],bx


pop dx
pop bx
pop ds
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 4


rabbit_platform_shift_left:
pusha
mov dx,5
mov bx,25
Loop_rabbit_platform_shift_left:
mov ax,bx
push ax
mov ax,0
push ax
call shiftleft
add bx,1
sub dx,1
jnz Loop_rabbit_platform_shift_left
popa
ret

rabbit_platform_shift_left2:
pusha
mov dx,5
mov bx,30;38

Loop_rabbit_platform_shift_left2:
mov ax,bx
push ax
mov ax,0
push ax
call shiftleft
add bx,1
sub dx,1
jnz Loop_rabbit_platform_shift_left2
popa
ret

rabbit_platform_shift_right:
pusha
mov dx,5
mov bx,25
Loop_rabbit_platform_shift_right:
mov ax,bx
push ax
mov ax,0
push ax
call shiftright
add bx,1
sub dx,1
jne Loop_rabbit_platform_shift_right
popa
ret
rabbit_platform_shift_right2:
pusha
mov dx,5
mov bx,30 ;38
Loop_rabbit_platform_shift_right2:
mov ax,bx
push ax
mov ax,0
push ax
call shiftright
add bx,1
sub dx,1
jnz Loop_rabbit_platform_shift_right2
popa
ret


i_left_move:
call rabbit_platform_shift_left
dec byte[bool_initial]
jmp temp1

right_Shifter:
call rabbit_platform_shift_right
jmp temp2


later_shift_right:
dec byte[Right_BOOL]
cmp byte[Right_BOOL],0
ja right_Shifter
mov byte[Left_BOOL],40
jmp temp2
 

Shifter_left:
call rabbit_platform_shift_left
jmp temp3
;ret 2

later_shift_left:
dec byte[Left_BOOL]
cmp byte[Left_BOOL],0
ja Shifter_left
mov byte[Right_BOOL],40
jmp temp3

later_right_move:
cmp byte[Right_BOOL],0
ja later_shift_right
jmp temp2



lower_part_shifting:
cmp byte[bool_initial],0
jle  later_shift_right_more2
temp5:
cmp byte[Right_BOOL2],0
jle later_shift_left2
temp6:
jmp temp4

later_shift_right_more2:
cmp byte[Right_BOOL2],0
ja later_move_right2
jmp temp5

later_move_right2:
dec byte[Right_BOOL2]
cmp byte[Right_BOOL2],0




ja shifter_right2
mov byte[Left_BOOL2],40
jmp temp4
shifter_right2:
call rabbit_platform_shift_right2
jmp temp4


shifter_left2:
call rabbit_platform_shift_left2
jmp temp4
;ret 2

later_shift_left2:
dec byte[Left_BOOL2]
cmp byte[Left_BOOL2],0
ja shifter_left2
mov byte[Right_BOOL2],40
jmp temp4
         

;-----------------------------------------------------------------------------------------------
Animation:

shiftInfiniteLoop:
call Move_firstPortion
call MoveSecondSegment







cmp byte[bool_initial],0
jnz i_left_move

temp1:
cmp byte[bool_initial],0
jle  later_right_move
temp2:




cmp byte[Right_BOOL],0
jle later_shift_left
temp3:




cmp byte[check_jump_occ],1
je lower_part_shifting

temp4:
call Delay

cmp word[counter],4
jne skip2
call GameOverScreen
skip2:
jmp shiftInfiniteLoop
ret
;______________________________________________________________________________________________________________

bufferStoring:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov cx,1320                 ;row: 37,27
mov ax,0xb800
mov es,ax
mov di,132
imul di,[bp+4] ; row for rabbit storing        
add di,0
imul di,2
mov si,buffer

bufferLoop:
mov ax,[es:di]
mov [si],ax
inc si
inc di
loop bufferLoop

pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 2

;_____________________________________________________________________________________________________________
;______________________________________________________________________________________________________________

;mujtaba work

;______________________________________________________________________________________________________________
score:

push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push bx

mov ax, 0xb800
mov es, ax ; point es to video base

mov al, 132 ; load al with columns per row
mul byte [bp+12] ; 80 x r
add ax, [bp+10] ; word number (80xr) + c
shl ax, 1 ; byte no (((80xr) + c)x2)

mov di, ax ; point di to required location
mov si, [bp+6] ; point si to string
mov cx, [bp+4] ; load length of string in cx
mov ah, [bp+8] ; load attribute in ah

nextcharScore:

mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
add si, 1 ; move to next char in string
; call delay
loop nextcharScore
add di,2
mov al,[bp+14]
cmp al,9 ; if a two digit number div base by 10 twice
ja twoDigitScore

add al,48
mov [es:di],ax
jmp skipScore

twoDigitScore:

mov ax, [bp+14] ; load number in ax= 4529
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits

nextdigitScore: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10 AX/BX --> Quotient --> AX, Remainder --> DX .....
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack

inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigitScore

nextPosChar:

pop dx
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextPosChar

skipScore:
pop bx
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 12
;Mujtaba work alternative of ahmad platfoam
;______________________________________________________________________________________________________________
checkBluePlatform:
push ax
push bx
push cx
push dx
push es
push di

mov ax,0xb800
mov es,ax
mov di,132
imul di,34
add di,62
imul di,2


;mov cx,22; length of platform to remove

mov al,' '
mov ah,0x33

; cmp word[GameOverFlag],0
; jne removeBluePlatform

cmp word[es:di],ax
jne exitCheckBlue
;call GameOverScreen
;mov byte[counter],0
add word[BlueCountFlag],2
jmp exitCheckBlue
; jmp exitCheckBlue
    ; ; Set the RemovePlatformFlag to indicate that it's time to remove the blue platform
    ; ; mov [es:BlueCountFlag], 1
; ; cmp word[BlueCountFlag],1
; ; je removeBluePlatform
    ; ; ; Reset the bluePlatformPresent flag to indicate the platform has been processed
    ; ; mov [es:bluePlatformPresent], 0

; ;call compareTime

; removeBluePlatform:
; mov dx,0x0101
; mov [es:di],dx
; add di,2
; loop removeBluePlatform

; mov ah,0x13
; mov al,0
; mov bh,0
; mov bl,0x07
; mov cx,23
; mov dh,18
; mov dl,50
; push ds
; pop es
; mov bp, msg_GameOver
; int 10h



exitCheckBlue:
pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret

pauseScreen:

push ax
push di
push es
push bx
push cx
push dx

mov ax,0xb800
mov es,ax

mov al,' '
mov ah,0x07

mov di,0
clearAllPS:
mov [es:di],ax
add di,2
cmp di,11880
jne clearAllPS



mov ah,0x13
mov al,0
mov bh,0
mov bl,0x07
mov cx,29
mov dh,18
mov dl,50
push ds
pop es
mov bp, msg_PauseScreen
int 10h

pop dx
pop cx
pop bx
pop es
pop di
pop ax
ret

GameOverScreen:

push ax
push di
push es
push bx
push cx
push dx

mov ax,0xb800
mov es,ax

mov al,' '
mov ah,0x07

mov di,0
clearAll:
mov [es:di],ax
add di,2
cmp di,11880
jne clearAll

mov ah,0x13
mov al,0
mov bh,0
mov bl,0x07
mov cx,18
mov dh,18
mov dl,50
push ds
pop es
mov bp, msg_GameOver
int 10h

mov ax,[ScoreValue]
push ax
mov ax, 20
push ax ; push r position............[bp+12]
mov ax, 50
push ax ; push c position............[bp+10]
mov ax, 0x07 ; blue on black attribute
push ax ; push attribute............[bp+8]
mov ax, ScoreString
push ax ; push address of message............[bp+6]
push word [ScoreLength] ; push message length ....[bp+4]

call score


pop dx
pop cx
pop bx
pop es
pop di
pop ax




ret


; pop es
; pop di
; pop ax
; ret


;Mujtaba Work
;_____________________________________________________________________________________________________________

 
;______________________________________________________________________________________________________________
 saveScreen2: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
mov ax,0xb800
mov es,ax
mov al, 132 ; load al with columns per row
mul byte [bp+6] ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)
mov di, ax ; point di to required location
mov cx,1320
mov si,rabbitstorage
saveloop2:
mov ax, [es:di] ; no, save this character
mov [si],ax
inc si
inc di
loop saveloop2
            pop ds
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 4


restoreScreen2:push bp
              mov bp,sp
 push ax
 push es
 push di
 push si

mov si,rabbitstorage
mov ax,0xb800
mov es,ax
mov di, 132 ; load al with columns per row
imul di, [bp+6] ; 132 x r
add di, [bp+4] ; word number (132xr) + c
shl di, 1 ; byte no (((132xr) + c)x2)

mov cx,1320
restoreloop2:
mov ax,[si]
mov [es:di],ax
inc si
inc di
loop restoreloop2
             
 pop si
 pop di
 pop es
 pop ax
 pop bp
ret 4
 ;______________________________________________________________________________________________________________
 platform_down:

mov ax,22
push ax
mov ax,0
push ax
call saveScreen2
mov ax,22;[platefoammover]
push ax
mov ax,0
push ax
call segmentclear
;inc byte[platefoammover]
mov ax,30                                     ;[platefoammover]
push ax
mov ax,0
push ax
call restoreScreen2

ret
 
 restoreScreen:
 push bp
 mov bp,sp
 push ax
 push es
 push di
 push si

mov si,rabbitstorage
mov ax,0xb800
mov es,ax
mov al, 132 ; load al with columns per row
mul byte [bp+6] ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)
mov di, ax ; point di to required location

mov cx,1056                             ;528
restoreloop:
mov ax,[si]
mov [es:di],ax
inc si
inc di
loop restoreloop
             
 pop si
 pop di
 pop es
 pop ax
 pop bp
ret 4
carrotPrint:
push bp
mov bp,sp
 push ax
 push es
 push di
 push si
 push dx
 push bx
 push cx

 mov bx,0xb800
 mov es,bx


 mov ah, 2Ch    ; AH = Function to get system time
    int 21h        ; Call DOS to get time
    ;mov byte [tickcount], dl   ; Store seconds as the seedd
; Generate a random number
mov dl, [tickcount]  ; Load the current seed
    xor al, ah      ; XOR with high byte of time for more randomness
    xor al, dl      ; XOR with seconds
    ror al, 1       ; Rotate right for randomness
    xor al, dl      ; XOR again for more randomness
    and al, 0x03   ; Ensure it's a 2-bit value (values 0 to 3)

    ; Add 1 to the random number to get a value between 1 and 4
    inc al
mov [carrotPosition],al



mov al, 132 ; load al with columns per row
mul byte [bp+6]    ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)
mov di, ax ; point di to required location

add di,104
mov cx,2

cmp byte[carrotPosition],1




je leftCarrot
cmp byte[carrotPosition],2
je middleCarrot
cmp byte[carrotPosition],3
je rightCarrot
cmp byte[carrotPosition],4
je endlCarrLoop

leftCarrot:

mov ah,0x04
mov si,c2

leftCarrloop:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop leftCarrloop
jmp endlCarrLoop

rightCarrot:

add di,36
mov ah,0x04
mov si,c2

rightCarrloop:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop rightCarrloop
jmp endlCarrLoop

middleCarrot:
add di,20
mov ah,0x04
mov si,c2

middleCarrloop:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop middleCarrloop




endlCarrLoop:
 pop cx
 pop bx
 pop dx
 pop si
 pop di
 pop es
 pop ax
 pop bp
 ret 4


;use to generate random platefoam at the upper portion(MUJTABA WORK)
;__________________________________________________________________________________________
print_platform2:
push bp
mov bp,sp
 push ax
 push es
 push di
 push si
 push dx
 

mov ah, 2Ch    ; AH = Function to get system time
    int 21h        ; Call DOS to get time
    ;mov byte [tickcount], al   ; Store seconds as the seedd
; Generate a random number
mov dl, [tickcount]  ; Load the current seed
    xor al, ah      ; XOR with high byte of time for more randomness
    xor al, dl      ; XOR with seconds
    ror al, 1       ; Rotate right for randomness
    xor al, dl      ; XOR again for more randomness
    and al, 0x03    ; Ensure it's a 2-bit value (values 0 to 3)

    ; Add 1 to the random number to get a value between 1 and 4
    inc al




mov [random_color],al



mov al, 132 ; load al with columns per row
mul byte [bp+6]    ; 132 x r
add ax, [bp+4] ; word number (132xr) + c
shl ax, 1 ; byte no (((132xr) + c)x2)
mov di, ax ; point di to required location


add di,104
mov cx,20
mov al,' '
cmp byte[random_color],1
jz  green_color
cmp byte[random_color],2
jz  yellow_color
cmp byte[random_color],3
jz blue_color
cmp byte[random_color],4
je white_color
; mov ah,0x44                              ;[attribute]
; cld
; rep stosw

green_color:
mov ah,0x22                              ;[attribute]
cld
rep stosw
            jmp rpoint
yellow_color:
mov ah,0xee                             ;[attribute]
cld
rep stosw
            jmp rpoint
blue_color:
mov ah,0x33                             ;[attribute]
cld
rep stosw
 jmp rpoint
white_color:
mov ah,7bh                            ;[attribute]
cld
rep stosw            

rpoint:
pop dx
 pop si
 pop di
 pop es
 pop ax
 pop bp
ret 4

printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 5532 ; point di to 70th column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
;mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
mov word[cs:tickcount],0
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2

check_Below:

 ; push bp
 ; mov bp,sp
 ; push ax
 ; push es
 ; push di
 ; push si
 ; push dx
 ; push cx

; ;mov cx,20
; mov di,132
; imul di,[bp+6]
; add di,[bp+4]
; imul di,2

; mov dl,')'
; checkFunc:
 ; mov al,[es:di]
 ; cmp al,dl
 ; add di,2
 ; jne checkFunc
 ; add di,2
 ; loop checkFunc
; jmp endCheck
; matchBelow:
; add di,132
; mov al,[es:di]
; cmp al,0x07
; jne endCheck

; call GameOverScreen

; endCheck:
 ; pop dx
 ; pop si
 ; pop di
 ; pop es
 ; pop ax
 ; pop bp
; ret 4

pusha

mov ax,0xb800
mov es,ax
mov ax,8828
mov di,ax
mov si,ax
xor ax,ax
mov al,')'

checkloop:
mov bl,[es:di]
add di,2
cmp bl,al
jnz checkloop
mov ah,0x07
sub di,2
                                  ;we have the value where rabbit's leg is starting from.
mov bx,10
add di,260                 ;1 row down,2 column left
mov al,0x20					; space ascii
mov dx,[es:di]
cmp ax,dx
jz update_boolFlag
add di,bx
mov dx,[es:di]
cmp ax,dx
jz update_boolFlag

popa
ret


update_boolFlag:
mov byte[checkFlag_B],1
popa
ret


timer:

;push ax
inc word[cs:tickcount]
cmp word[cs:tickcount],18
jnz skip1
inc word [cs:counter]

push word[cs:counter]
call printnum
skip1:
; cmp word[cs:GameOverFlag],0
; je ContinueJumping
; mov ax,[cs:BlueEnd] ; Blue platform end game
; cmp ax,[cs:tickcount]
; jne ContinueJumping
; call GameOverScreen

; ContinueJumping:
;pop ax
jmp far[cs:oldisr]

iret

;_____________________________________________________________________________________

kbisr:

push ax
push es
 
mov ax, 0xb800
mov es, ax ; point es to video memory
   
in al, 0x60 ; read a char from keyboard port
cmp al, 0x48 ; is the key left shift
jne nextCmp

mov word[counter],5
 mov word[Plat_Form_Mover],31                               ;needed for platform down.
mov byte[checkFlag_B],0
mov byte[check_jump_occ],1
           
mov ax,30     ; Because lower platform starts at row 34 and the size of rabbit is 4.... so (34-4)=30 it save in buffer
push ax
mov ax,0
push ax
call saveScreen
 

push ax                                              
mov al,byte[Right_BOOL]


mov byte[Right_BOOL2],al



mov al,byte[Left_BOOL]



mov byte[Left_BOOL2],al
mov byte[bool_initial],20
mov byte[Right_BOOL],40
mov byte[Left_BOOL],40
pop ax

mov ax,30
push ax
mov ax,0
push ax
call segmentclear		; Clears the segment from row 30-34 after storing it in buffer

mov ax,22
push ax
mov ax,0
push ax
 call restoreScreen

 call platform_down
 cmp byte[random_color],3
 jnz sonamunda
mov word[counter],0
sonamunda:
   mov ax,26
   push ax
  mov ax,0
  push ax
  call print_platform2			; It prints the above platform having random colour 
 
  mov ax,25
  push ax
  mov ax,0
  push ax
  call carrotPrint				; It prints the carrot above the platform having random location
 
  ; mov ax,33
  ; push ax
  ; mov ax,60
  ; push ax
   call check_Below
   mov al,[checkFlag_B]
   cmp al,1
   jz GameOverScreen
   
 
 inc word[ScoreValue]
 mov ax,[ScoreValue]
push ax
mov ax, 20
push ax ; push r position............[bp+12]
mov ax, 50
push ax ; push c position............[bp+10]
mov ax, 0x07 ; blue on black attribute
push ax ; push attribute............[bp+8]
mov ax, ScoreString
push ax ; push address of message............[bp+6]
push word [ScoreLength] ; push message length ....[bp+4]

call score
 
 
call checkBluePlatform
; cmp word[cs:BlueCountFlag],0
; je nomatch
; mov ax,[cs:tickcount]
; add ax,80
; mov word[cs:BlueEnd],ax
; mov word [cs:GameOverFlag],1
jmp nomatch

nextCmp:
cmp al,0x01
jne nomatch





mov ax,0xb800
mov es,ax
mov di,0
mov si,pauseStore
mov cx,11616
loop_ConfirmBuffer:

mov ax,[es:di]
mov [si],ax
add di,2
add si,2
loop loop_ConfirmBuffer



mov al,0x20
out 0x20,al
pop es
pop ax

mov ah,0
int 0x16
;mov ah, 08h         ; AH = 08h for reading a key without echoing
 ;   int 21h  
cmp al,48

jne skip3
call GameOverScreen
skip3:






;jmp nomatch

; exit:
; pop es
; pop ax


nomatch:

;jmp far [cs:oldisr]  


;exit:
pop es
pop ax

mov al,0x20
out 0x20,al

iret






;____________________________________________________________________________________________
start:


mov ax, 0x0013  ;13 ; Set graphics mode
int 0x10        ; BIOS video services


mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x04
mov cx, 22
mov dh, 8
mov dl, 8
push ds
pop es
mov bp, msg_start
int 0x10

mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x04
mov cx, 23
mov dh, 10
mov dl, 8
push ds
pop es
mov bp, msg_Names
int 0x10

mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x04
mov cx, 19
mov dh, 12
mov dl, 8
push ds
pop es
mov bp, msg_RollNum
int 0x10

mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x04
mov cx, 29
mov dh, 14
mov dl, 8
push ds
pop es
mov bp, msg_Continue
int 0x10
;int 0x16     ; Wait for a key press

 mov ah, 08h         ; AH = 08h for reading a key without echoing
    int 21h  

;call clrBefore
mov ax, 0x0013 ; Set graphics mode
int 0x10        ; BIOS video services



mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x07
mov cx, 13
mov dh, 8
mov dl, 11
push ds
pop es
mov bp, msg_Instructions1
int 0x10


mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x06
mov cx, 20
mov dh, 10
mov dl, 8
push ds
pop es
mov bp, msg_Instructions2
int 0x10

mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x06
mov cx, 7
mov dh, 14
mov dl, 14
push ds
pop es
mov bp, enterName
int 0x10


loadAni:
add byte[colGraphic],1
mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x06
mov cx, 1
mov dh, 16
mov dl, [colGraphic]
push ds
pop es
mov bp, display
int 0x10
call Delay
dec byte[check]
cmp byte[check],0
jne loadAni




mov AH,0x00
mov al, 0x54
int 0x10


call printMainscreen

terminator:
push ax
cli
mov ax,[cs:oldisr]
mov [es:9*4],ax
mov ax,[cs:oldisr+2]
mov [es:9*4+2],ax
std
mov ax, 0x3100 ; terminate and stay resident
int 0x21


pop ax



; mov ax, 0x4c00
; int 0x21
;________
 


;_________________________________________________________________________________________________
printMainscreen:

;increase size of screen  (132 * 45)
; mov AH,0x00
; mov al, 0x54
; int 0x10

call clrscrUpper
call clrscrMiddle
call clrscrBottom

;printing building
mov cx,10
mov ax,[rowBuild+0] ;row
mov bx,[colBuild+0] ;col
push ax
push bx
push cx
call printbuilding

mov cx,10
mov ax,[rowBuild+2]
mov bx,[colBuild+2]
push ax
push bx
push cx
call printbuilding

mov cx,15
mov ax,[rowBuild+4]
mov bx,[colBuild+4]
push ax
push bx
push cx
call printbuilding

mov cx,12
mov ax,[rowBuild+6]
mov bx,[colBuild+6]
push ax
push bx
push cx
call printbuilding

mov cx,14
mov ax,[rowBuild+8]
mov bx,[colBuild+8]
push ax
push bx
push cx
call printbuilding

mov cx,15
mov ax,[rowBuild+10]
mov bx,[colBuild+10]
push ax
push bx
push cx
call printbuilding

mov cx,13   ; 19
mov ax,[rowBuild+12]
mov bx,[colBuild+12]
push ax
push bx
push cx
call printbuilding

mov cx,13 ;17
mov ax,[rowBuild+14]
mov bx,[colBuild+14]
push ax
push bx
push cx
call printbuilding

mov cx,10
mov ax,[rowBuild+16]
mov bx,[colBuild+16]
push ax
push bx
push cx
call printbuilding

mov cx,10
mov ax,[rowBuild+18]
mov bx,[colBuild+18]
push ax
push bx
push cx
call printbuilding

;______________________________________________________________________________


call printroad

;printing car

  mov ax, [rowCar1]
  push ax ; push row position............[bp+10]
  mov ax, [colCar1]
  push ax ; push c position............[bp+8]
  mov ax, v1
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar

  mov ax, [rowCar1+2]
  push ax ; push r position............[bp+10]
  mov ax, [colCar1]
  push ax ; push c position............[bp+8]
  mov ax, v2
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar
 
  mov ax, [rowCar1+4]
  push ax ; push r position............[bp+10]
  mov ax, [colCar1]
  push ax ; push c position............[bp+8]
  mov ax, v3
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar
 
  mov ax, [rowCar1+6]
  push ax ; push r position............[bp+10]
  mov ax, [colCar1]
  push ax ; push c position............[bp+8]
  mov ax, v4
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar
 
  mov ax, [rowCar2]
  push ax ; push r position............[bp+10]
  mov ax, [colCar2]
  push ax ; push c position............[bp+8]
  mov ax, v1
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar

  mov ax, [rowCar2+2]
  push ax ; push r position............[bp+10]
  mov ax, [colCar2]
  push ax ; push c position............[bp+8]
  mov ax, v2
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar
 
  mov ax, [rowCar2+4]
  push ax ; push row position............[bp+10]
  mov ax, [colCar2]
  push ax ; push c position............[bp+8]
  mov ax, v3
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar
 
  mov ax, [rowCar2+6]
  push ax ; push r position............[bp+10]
  mov ax, [colCar2]
  push ax ; push c position............[bp+8]
  mov ax, v4
  push ax ; push address of message............[bp+6]
  push word [carSize] ; push message length ....[bp+4]
  call setCar

;setting rabbit on screen
mov ax,[rabbitRow]
push ax
mov ax,[rabbitCol]
push ax
mov ax,r1
push ax

call setRabbit

mov ax,[rabbitRow+2]
push ax
mov ax,[rabbitCol]
push ax
mov ax,r2
push ax

call setRabbit

mov ax,[rabbitRow+4]
push ax
mov ax,[rabbitCol]
push ax
mov ax,r3
push ax

call setRabbit

mov ax,[rabbitRow+6]
push ax
mov ax,[rabbitCol]
push ax
mov ax,r4
push ax

call setRabbit


;print initial platefoams before the first jump
call  initial_Plat_form

;restore the rabbit from the buttom to the row number 34
mov ax,[restorerabbitrow]
push ax
mov ax,[clrsegmentrow]
push ax
mov ax,[storekaro]
push ax
call rabbitJump


xor ax, ax
mov es, ax
mov ax, [es:9*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldisr+2], ax ;
cli
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
mov word[es:8*4],timer
mov [es:8*4+2],cs
sti
call Animation

ret
