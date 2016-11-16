.origin 0

#define PRU0_ARM_INTERRUPT 19

#define CONST_PRUCFG         C4
#define CONST_PRUSHAREDRAM   C28
 
#define PRU0_CTRL            0x22000
#define PRU1_CTRL            0x24000
 
#define CTPPR0               0x28
 
#define OWN_RAM              0x000
#define OTHER_RAM            0x020
#define SHARED_RAM           0x100

#define SECOND               200000000      // 2e8 5ns cycles
#define DELAY                  2000000      // 0.01 s
    
START:
    lbco r0, CONST_PRUCFG, 4, 4          // Enable OCP master port
    clr  r0, r0, 4
    sbco r0, CONST_PRUCFG, 4, 4
    
    mov  r0, SHARED_RAM                  // Set C28 to point to shared RAM
    mov  r1, PRU0_CTRL + CTPPR0
    sbbo r0, r1, 0, 4

    mov  r2.w0, DELAY & 0xFFFF
    mov  r2.w2, DELAY >> 16 

WAITLO:
    qbbc WAITLO, r31.t15

IGNORE:                              // Wait for 50 consecutive readings of 1
    add  r0, r0, 2                     // 3 cycles per loop
    qbgt IGNORE, r0, r2

WAIT1:                                 // Continue counting while input is still 1
    add  r0, r0, 2
    qbbs WAIT1, r31.t15

WAIT2:                                 // Continue counting while input is 0
    add  r0, r0, 2
    qbbc WAIT2, r31.t15                // End count when input goes to 1

    sbco r0, CONST_PRUSHAREDRAM, 0, 4  // Write count to RAM
    MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
    mov  r0, 0
    jmp  IGNORE
