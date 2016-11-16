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
    
START:
    lbco r0, CONST_PRUCFG, 4, 4          // Enable OCP master port
    clr  r0, r0, 4
    sbco r0, CONST_PRUCFG, 4, 4
    
    mov  r0, SHARED_RAM                  // Set C28 to point to shared RAM
    mov  r1, PRU0_CTRL + CTPPR0
    sbbo r0, r1, 0, 4

    mov  r0, 0
    mov  r1, 0                           // Shift register

LOP:
    add  r0, r0, 3                       // Increment edge timer
    lsl  r1, r1, 1                       // Shift the register

    qbbc LOP, r31.t15                    // Restart loop if input is 0
    add  r0, r0, 3
    set  r1, 0
    qbbs LOP, r1.t1                     // Restart loop if no edge (...11) in shift reg

    add  r0, r0, 5
    sbco r0, CONST_PRUSHAREDRAM, 0, 4    // Write count to RAM
    mov  r0, 0                           // Clear counter on posedge
    mov  R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion

    jmp LOP
