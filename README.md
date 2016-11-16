# freq
Measure the frequency of a digital input on the BeagleBone Black

## Motivation
I have a vehicle that didn't come with an RPM gauge, so I'm using a BBB board to implement one (among other things).

## Implementation
The processor on the BBB has two built in PRUs (Programmable Runtime Units). These run independently of the linux operating system at a fixed clock frequency of 200Mhz, making them useful for operations requiring precise and reliable timing.

I'm using a simple program written in PRU assembly to measure the time between rising edges on one of the PRU's input pins. Simultaneously, a python script runs on the main core and reads the measured value from the PRU's RAM.

The [pypruss](https://bitbucket.org/intelligentagent/pypruss) library is used to greatly simplify usage of the pru.

## Usage
Ensure the TI PRU assembler (pasm) is installed and that this project's Makefile points to it. Also make sure the uio_pruss kernel module is avialable (this depends on yout kernel version). Finally, multiplex the relevant pin as a pru input. On my system I do this:

    # config-pin P8.15 pruin
    
Assemble and run the pru code:

    # make
    # python rpm.py
    
Run readmem.py to continuously read the values saved in the PRU memory and convert them to seconds.
    
    # sudo python readmem.py
