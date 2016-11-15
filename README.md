# freq
Measure the frequency of a digital input on the BeagleBone Black

## Motivation
I have a vehicle that didn't come with an RPM gauge, so I'm using a BBB board to implement one (among other things).

## Implementation
The processor on the BBB has two built in PRUs (Programmable Runtime Units). These run independently of the linux operating system at a fixed clock frequency of 200Mhz, making them useful for operations requiring precise and reliable timing.

I'm using a simple program written in PRU assembly to measure the time between rising edges on one of the PRU's input pins. Simultaneously, a python script runs on the main core and reads the measured value from the PRU's RAM.

The pypruss library is used to greatly simplify using the pru.
