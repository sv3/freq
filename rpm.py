# rpm.py - gets rpm value

from __future__ import print_function

import pypruss
import os

import mmap
import struct
from time import sleep

PRU_ICSS = 0x4A300000
START = 0x00010000

def readrpm():
    with open('/dev/mem', 'r+b') as m:
        mem = mmap.mmap( m.fileno(), 512*1024, offset=PRU_ICSS)

        valuestring = mem[START:START+4]
        value = struct.unpack('L', valuestring)[0]
        seconds = value * 0.000000005   # 5ns per cycle

        return seconds


os.system("config-pin p8.15 pruin")

pypruss.modprobe()                                  # This only has to be called once pr boot
pypruss.init()                                      # Init the PRU
pypruss.open(0)                                     # Open PRU event 0 which is PRU0_ARM_INTERRUPT
pypruss.pruintc_init()                              # Init the interrupt controller
pypruss.exec_program(0, "./rpm-alt.bin")                # Load firmware "blinkled.bin" on PRU 0

try:
    while True:
        pypruss.wait_for_event(0)                           # Wait for event 0 which is connected to PRU0_ARM_INTERRUPT

        seconds = readrpm()
        print( r'{} seconds'.format(seconds) )

        pypruss.clear_event(0,pypruss.PRU0_ARM_INTERRUPT)   # Clear the event

except KeyboardInterrupt as e:
    print(e)
    pypruss.pru_disable(0)                             # Disable PRU 0, this is already done by the firmware
    pypruss.exit()                                     # Exit, don't know what this does.
