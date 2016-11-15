.origin 0

#define CONST_PRUCFG         C4
#define CONST_PRUSHAREDRAM   C28
 
#define PRU0_CTRL            0x22000
#define PRU1_CTRL            0x24000
 
#define CTPPR0               0x28
 
#define OWN_RAM              0x000
#define OTHER_RAM            0x020
#define SHARED_RAM           0x100
    
START:
    LBCO    r0, CONST_PRUCFG, 4, 4          // Enable OCP master port
    CLR     r0, r0, 4
    SBCO    r0, CONST_PRUCFG, 4, 4
    
    MOV     r0, SHARED_RAM                  // Set C28 to point to shared RAM
    MOV     r1, PRU0_CTRL + CTPPR0
    SBBO    r0, r1, 0, 4


CNT:
    mov  r0, 0
WAIT0:
    qbbc WAIT0, r31.t15

WAIT1:
    add r0, r0, 1
    qbbs WAIT0, r31.t15

WAIT2:
    add r0, r0, 1
ll python
:

pkill py    
jobs
top
    qbbc WAIT2, r31.t15
0
    sbco r0, CONST_PRUSHAREDRAM, 0, 4
    jmp CNT
