// Name: Will Brower 
// NetID: dsc0679
//
// Implementation of Pong-Style game
// 
// Link to Demo: https://youtube.com/shorts/Ms2UypbWEDs?feature=share
//
// Mandatory Features:
//		Collision:
// 		Detects collisions w/ ball and paddle
//      Detects collisions w/ ball and top and bottom edge of screen
//
// 		Rewards w/ point and victory when 3 points ahead 
//		(relative score output in seven-segment display, game stops when there is a winner)
//
//		Player Inputs (Click on Type here for PS/2 keyboard at ff200100 to start inputting):
//		u/j -> Moves right paddle up/down
//		w/s -> Moves left paddle up/down
//		
// Advanced Features:
//		Sounds: 
//		Ball makes a sound on collision.
//
//		Special Visual Effect: 
// 		Ball flashes when point scored. 
//
//		Forces / Varied Velocity: 
//		Ball accelrates in the direction the direction
//		that the paddle is moving. (imagine as a friction impulse).
//
//
.data
// SVAED ADDRESSES
.EQU TEMP_BUFFER, 0xc2000000
.EQU PIX_BUFFER, 0xc8000000
.EQU TEXT_BUFFER, 0xc9000000
.EQU SCORE_DISPLAY, 0xff200020 
.EQU PIXEL_CTRL, 0xff203020 
.EQU TEMP_CTRL, 0xff203024
.EQU STATUS_REG, 0xff20302c
.EQU KEY_INPUT, 0xff200100
.EQU BREAK, 0xf000
.EQU U_MAKE, 0x3c
.EQU J_MAKE, 0x3b
.EQU W_MAKE, 0x1d
.EQU S_MAKE, 0x1b

// SPRITE VALS
.EQU SPRITE_MAP, 0
.EQU SPRITE_X, 4
.EQU SPRITE_Y, 6
.EQU SPRITE_XV, 8
.EQU SPRITE_YV, 10
// PIXMAP VALS
.EQU PIXMAP_WIDTH, 0
.EQU PIXMAP_HEIGHT, 2
.EQU PIXMAP_TRANSPARENCY, 4
.EQU PIXMAP_PIXELDATA, 6

.align 2
// PIXMAPS
	
Paddle:
	.hword 9, 33, 0x0001
	.hword 0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001, 0x0001
	.hword 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000  
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000   
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000  
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000  
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000  
	.hword 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001
	.hword 0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001, 0x0001
	.align 2
	
Ball:
	.hword 9, 9, 0x0001
	.hword 0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001, 0x0001
	.hword 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
	.hword 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001
	.hword 0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0001, 0x0001
	.align 2
	
Ball_Flash:
	.hword 9, 9, 0x0001
	.hword 0x0001, 0x0001, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0x0001, 0x0001
	.hword 0x0001, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0x0001
	.hword 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815
	.hword 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815
	.hword 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815
	.hword 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815
	.hword 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815
	.hword 0x0001, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0x0001
	.hword 0x0001, 0x0001, 0xF815, 0xF815, 0xF815, 0xF815, 0xF815, 0x0001, 0x0001
	.align 2

// Sprites
Paddle_Sprite1:
	.word Paddle  // pixmap_ptr
    .hword 30         // x  (start left side)
    .hword 120        // y  
	.hword 0		  // x-velocity
	.hword 0		  // y-velocity
	.align 2

Paddle_Sprite2:
	.word Paddle  // pixmap_ptr
    .hword 290         // x  (start left side)
    .hword 120        // y  
	.hword 0		  // x-velocity
	.hword 0		  // y-velocity
	.align 2
	
Ball_Sprite:
	.word Ball  // ball
    .hword 160        // x  (start middle)
    .hword 120        // y  
	.hword 2		  // x-velocity
	.hword 0		  // y-velocity
	.align 2
	
ScoreBoard:
	.byte 0
	.byte 0

.text

.global _start
_start:
	
	// Initalize Game
	ldr sp, =0x8000000
	ldr r0, =TEMP_CTRL
	ldr r1, =PIX_BUFFER
	str r1, [r0]
	bl UpdateScreen
	ldr r0, =TEMP_CTRL
	ldr r1, =TEMP_BUFFER
	str r1, [r0]
	bl ClearVGA
	bl ClearTemp
	
inf_loop:
	bl GameLoop // Main game functionality
	bl WriteScore // Write to seven-segment display
	b inf_loop
	
inf_2: // Loops when game is over
	b inf_2

// Functions/Routines
WriteScore: // Takes score vals from memory and writes them to the display
	push {r0-r5, lr}
	ldr r2, =ScoreBoard
	ldrb r0, [r2]
	ldrb r1, [r2, #1]
	cmp r1, r0
	subge r3, r1, r0
	sublt r3, r0, r1
	cmp r3, #3
	moveq r4, #79
	movge r1, #0
	movge r0, #0
	moveq r4, #79
	cmp r3, #2
	moveq r4, #91
	cmp r3, #1
	moveq r4, #6
	movlt r4, #63
	ScoreEnd:
	ldr r5, =SCORE_DISPLAY
	str r4, [r5] 
	cmp r3, #3
	pop {r0-r5, lr}
	bge inf_2
	bx lr

ClearTemp: // Clears back buffer of pixels
	push {r0-r3}
	mov r0, #0xffff
	ldr r2, =TEMP_CTRL
    ldr r3, [r2]
    mov r2, #0
	CTLoop1:
		mov r1, #0
	CTLoop2:
		strh r0, [r3, r1]
		add r1, r1, #2
		cmp r1, #640
		blo CTLoop2
		add r3, r3, #1024
		add r2, r2, #1
		cmp r2, #240
		blo CTLoop1
	pop {r0-r3}
	bx lr

ClearVGA: // Clears front pixel buffer at setup
	push {r0-r3}
	mov r0, #0xffff
    ldr r3, =PIX_BUFFER
    mov r2, #0
	ScreenLoop1:
		mov r1, #0
	ScreenLoop2:
		strh r0, [r3, r1]
		add r1, r1, #2
		cmp r1, #640
		blo ScreenLoop2
		add r3, r3, #1024
		add r2, r2, #1
		cmp r2, #240
		blo ScreenLoop1
	pop {r0-r3}
	bx lr
	
MakeSound: // Repurposed from Audio Loopback Test on CPULator, makes brief sound 
	push {r0-r8, lr}
	mov r8, #48
	ldr r6, =0xff203040
	ldr r4, =0x60000000
	mov r3, #0
	mov r5, r8
	WaitForWriteSpace:
		ldr r2, [r6, #4]
		tst r2, #0xff000000
		beq WaitForWriteSpace
		tst r2, #0x00ff0000
		beq WaitForWriteSpace
	WriteTwoSamples:
		str r4, [r6, #8]
		str r4, [r6, #12]
		subs r5, #1
		bne WaitForWriteSpace
	HalfPeriodInvertWaveform:
		mov r5, r8
		neg r4, r4
		add r3, r3, #1
		cmp r3, #30
		blt WaitForWriteSpace
	pop {r0-r8, pc}	
	
BitBilt:
    push {r0-r12, lr}
	// r0 = pix_map, r1 = x_coord, r2 = y_coord, r4 = draw_buffer
	ldr r3, =TEMP_CTRL
    ldr r11, [r3]
    ldrh r3, [r0, #PIXMAP_WIDTH]        // r3 = width
    ldrh r4, [r0, #PIXMAP_HEIGHT]       // r4 = height
    ldrh r5, [r0, #PIXMAP_TRANSPARENCY] // r5 = transp
    mov  r6, #PIXMAP_PIXELDATA          // r6 = byte offset (starts at 6)
    mov  r7, r3, lsr #1     // r7 = width/2
    sub  r7, r1, r7         // r7 = x_min = x - width/2
    add  r8, r7, r3         // r8 = x_min + width
    sub  r8, r8, #1         // r8 = x_max = x_min + width - 1
    // exit image is off screen
    cmp r8, #0
    blt  BB_done            
    cmp r7, #320
    bge  BB_done            
    mov  r9, r4, lsr #1     // r9 = height/2
    sub  r9, r2, r9         // r9 = y_min = y - height/2
    add  r10, r9, r4        // r10 = y_min + height
    sub  r10, r10, #1       // r10 = y_max = y_min + height - 1
    // exit image is off screen
    cmp r10, #0
    blt  BB_done            
    cmp r9, #240
    bge  BB_done            
    // r11 += y_min * 1024  
    mov  r1, #1024
    mul  r1, r1, r9         
    add  r11, r11, r1       
	BB_RowLoop:
		cmp r9, r10
		bgt BB_done 
		cmp r9, #240
		bge BB_done             // stop if past bottom
		// skip if off screen
		cmp r9, #0
		blt BB_SkipRow
		// Inner loop
		mov r12, #0
	BB_ColLoop:
		cmp r12, r3             
		bge BB_NextRow
		add r1, r7, r12         // r1 = screen_x
		ldrh r2, [r0, r6]       // r2 = curr_color 
		// Skip transparent
		cmp r2, r5
		beq BB_NextPixel
		cmp r1, #0
		blt BB_NextPixel
		cmp r1, #320
		bge BB_NextPixel
		lsl r1, r1, #1
		strh r2, [r11, r1]
	BB_NextPixel:
		add r6, r6, #2          
		add r12, r12, #1        // x++
		b   BB_ColLoop
	BB_SkipRow:
		// skip width of pixels 
		mov  r1, r3, lsl #1     
		add  r6, r6, r1
	BB_NextRow:
		add r9, r9, #1          // y++
		add r11, r11, #1024     // advance row pointer 
		b BB_RowLoop
BB_done:
    pop {r0-r12, pc}
	
	
MoveSprite: // Updates a sprite's location based on its velocity
	push {r0-r2, lr}
	ldrh r1, [r0, #SPRITE_X]
	ldrh r2, [r0, #SPRITE_XV]
	add r1, r1, r2
	strh r1, [r0, #SPRITE_X]
	
	ldrh r1, [r0, #SPRITE_Y]
	ldrh r2, [r0, #SPRITE_YV]
	add r1, r1, r2
	strh r1, [r0, #SPRITE_Y]
	pop {r0-r2, pc}

DrawSprite: // Draws a Sptire onto the back buffer
	push {r0-r3, lr}
	mov r3, r0
	ldr r0, [r3, #SPRITE_MAP]
	ldrh r1, [r3, #SPRITE_X]
	ldrh r2, [r3, #SPRITE_Y]
	bl BitBilt
	pop {r0-r3, pc}
	
CheckCollisions: // Checks collision for ball and walls
	push {r0-r7, lr}
	// Left paddle collisions
	ldr r0, =Paddle_Sprite1 
	ldrh r4, [r0, #SPRITE_Y]
	// Checks top of left paddle
	cmp r4, #224
	blt Paddle1Down
	mov r4, #224
	strh r4, [r0, #SPRITE_Y]
	Paddle1Down:
	// Checks bottom of left paddle
	cmp r4, #16
	bgt Paddle2Down
	mov r4, #16
	strh r4, [r0, #SPRITE_Y]
	Paddle2Down:
	// Checks top of right paddle
	ldr r0, =Paddle_Sprite2
	ldrh r5, [r0, #SPRITE_Y]
	cmp r5, #224
	blt Paddle2Up
	mov r5, #224
	strh r5, [r0, #SPRITE_Y]
	Paddle2Up:
	// Checks bottom of right paddle
	cmp r5, #16
	bgt Ball_Collisions
	mov r5, #16
	strh r5, [r0, #SPRITE_Y]
	Ball_Collisions:
	// All collisions for the ball
	ldr r0, =Ball_Sprite
	ldrh r1, [r0, #SPRITE_X]
	ldrh r2, [r0, #SPRITE_Y]
	// Collision check Right Paddle
	mov r3, #200
	add r3, r3, #82
	cmp r1, r3
	blt BallLeft
	add r5, r5, #19
	cmp r2, r5
	sub r5, r5, #19
	bgt BallLeft
	sub r5, r5, #19
	cmp r2, r5
	add r5, r5, #19
	blt BallLeft
	ldr r6, =Paddle_Sprite2
	ldrh r7, [r6, #SPRITE_YV]
	ldrh r3, [r0, #SPRITE_YV]
	add r3, r3, r7
	strh r3, [r0, #SPRITE_YV]
	bl XBounce
	BallLeft:
		// Collision check Left Paddle
		cmp r1, #38
		bgt BallUp
		add r4, r4, #19
		cmp r2, r4
		sub r4, r4, #19
		bgt BallUp
		sub r4, r4, #19
		cmp r2, r4
		add r4, r4, #19
		blt BallUp
		ldr r6, =Paddle_Sprite1
		ldrh r7, [r6, #SPRITE_YV]
		ldrh r3, [r0, #SPRITE_YV]
		add r3, r3, r7
		strh r3, [r0, #SPRITE_YV]
		bl XBounce
	BallUp:
		// Collision check top of screen
		cmp r2, #8
		bgt BallDown
		bl YBounce
	BallDown:
		// Collision check bottom of screen
		cmp r2, #232
		blt BallEnd
		bl YBounce
	BallEnd:
	cmp r4, #236
	pop {r0-r7, pc}
	

WinCon:
	// Checks ball position to see which side won the round, updates score struct
	push {r0-r5, lr}
	mov r5, #0
	ldr r0, =Ball_Sprite
	ldrh r1, [r0, #SPRITE_X]
	ldr r2, =ScoreBoard
	mov r4, #200
	add r4, r4, #90
	cmp r1, r4
	blt WinCon2
	ldrb r3, [r2, #1]
	add r3, r3, #1
	strb r3, [r2, #1]
	bl ResetScreen
	b WinConEnd
	WinCon2:
	mov r4, #30
	cmp r1, r4
	bgt WinConEnd
	ldrb r3, [r2]
	add r3, r3, #1
	strb r3, [r2]
	bl ResetScreen
	b WinConEnd
	WinConEnd:
	pop {r0-r5, pc}
	
ResetScreen:
	//Resets screen after wincon is met
	push {r0-r2, lr}
	bl ScoreAnimate
	bl ClearTemp
	ldr r0, =Paddle_Sprite1
	mov r1, #120
	strh r1, [r0, #SPRITE_Y]
	bl DrawSprite
	ldr r0, =Paddle_Sprite2
	mov r1, #120
	strh r1, [r0, #SPRITE_Y]
	bl DrawSprite
	ldr r0, =Ball_Sprite
	mov r1, #120
	strh r1, [r0, #SPRITE_Y]
	mov r1, #160
	strh r1, [r0, #SPRITE_X]
	mov r1, #1
	strh r1, [r0, #SPRITE_XV]
	strh r1, [r0, #SPRITE_YV]
	bl DrawSprite
	bl UpdateScreen
	pop {r0-r2, pc}
	
SetPaddles:
	// Takes input from the keyboard and updates paddle velocity based on which key is pressed
    push {r0-r7, lr}
    ldr r0, =KEY_INPUT      
    mov r6, #0              
	ReadFIFO:
		ldr r1, [r0]    // Reads + shifts read byte out        
		tst r1, #0x8000  // Check if more to read       
		beq SetPaddlesDone  // Branch back when no more to read   
		and r2, r1, #0xff       
		cmp r2, #0xf0
		moveq r6, #1            
		beq ReadFIFO           
		ldr r3, =W_MAKE
		cmp r2, r3
		beq Check_W
		ldr r3, =S_MAKE
		cmp r2, r3
		beq Check_S
		ldr r3, =U_MAKE
		cmp r2, r3
		beq Check_U
		ldr r3, =J_MAKE
		cmp r2, r3
		beq Check_J
		mov r6, #0              
		b ReadFIFO
	Check_W: 
		ldr r4, =Paddle_Sprite1
		mov r5, #-2             
		cmp r6, #1
		moveq r5, #0            
		strh r5, [r4, #SPRITE_YV]
		mov r6, #0
		b ReadFIFO
	Check_S:  
		ldr r4, =Paddle_Sprite1
		mov r5, #2              
		cmp r6, #1
		moveq r5, #0
		strh r5, [r4, #SPRITE_YV]
		mov r6, #0
		b ReadFIFO
	Check_U:
		ldr r4, =Paddle_Sprite2
		mov r5, #-2             
		cmp r6, #1
		moveq r5, #0
		strh r5, [r4, #SPRITE_YV]
		mov r6, #0
		b ReadFIFO
	Check_J:
		ldr r4, =Paddle_Sprite2
		mov r5, #2             
		cmp r6, #1
		moveq r5, #0
		strh r5, [r4, #SPRITE_YV]
		mov r6, #0
		b ReadFIFO
SetPaddlesDone:
    pop {r0-r7, pc}
	
XBounce:
	// Switches x direction of a sprite (used in collision)
	push {r1, lr}
	bl MakeSound
	ldrh r1, [r0, #SPRITE_XV]
	rsb r1, r1, #0
	strh r1, [r0, #SPRITE_XV]
	pop {r1, pc}
	
YBounce:
	// Switches y direction of a sprite (used in collision)
	push {r1, lr}
	bl MakeSound
	ldrh r1, [r0, #SPRITE_YV]
	rsb r1, r1, #0
	strh r1, [r0, #SPRITE_YV]
	pop {r1, pc}
	

	
ScoreAnimate:
	// Animation of ball when someone scores
	push {r0-r6, lr}
	ldr r6, =Ball_Sprite
	ldr r1, =Ball_Flash
	ldr r2, =Ball
	ldr r3, =Paddle_Sprite1
	ldr r4, =Paddle_Sprite2
	mov r5, #0
	mov r0, r3
	bl DrawSprite
	mov r0, r4
	bl DrawSprite
	bl UpdateScreen
	mov r0, r3
	bl DrawSprite
	mov r0, r4
	bl DrawSprite
	bl UpdateScreen
	mov r0, r6
	FlashLoop:
	str r1, [r0,#SPRITE_MAP] 
	bl DrawSprite
	bl UpdateScreen
	str r2, [r0,#SPRITE_MAP]
	bl DrawSprite
	bl UpdateScreen
	add r5, r5, #1
	cmp r5, #9
	blt FlashLoop
	pop {r0-r6, pc}
	

UpdateScreen:
    push {r0-r2, lr}
    
    ldr r0, =PIXEL_CTRL
    mov r1, #1
    str r1, [r0]            // write 1 to buffer

	Sync_Check:
    ldr r0, =STATUS_REG
    ldr r1, [r0]            
    tst r1, #1              // check bit
    bne Sync_Check          // if bit is not 1, continue
	
    pop {r0-r2, pc}
	

GameLoop:
	push {r0-r5, lr}
	bl ClearTemp
	bl SetPaddles
	ldr r0, =Paddle_Sprite1
	bl MoveSprite
	bl DrawSprite
	ldr r0, =Paddle_Sprite2
	bl MoveSprite
	bl DrawSprite
	ldr r0, =Ball_Sprite
	bl CheckCollisions
	bl MoveSprite
	bl DrawSprite
	bl UpdateScreen
	bl WinCon
	pop {r0-r5, pc}
	
	