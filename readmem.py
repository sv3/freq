
from __future__ import print_function

import mmap
import binascii
import struct
from time import sleep

PRU_ICSS = 0x4A300000
START = 0x00010000

old = 0

with open('/dev/mem', 'r+b') as m:
    mem = mmap.mmap( m.fileno(), 512*1024, offset=PRU_ICSS)

    while True:
        valuestring = mem[START:START+4]
        value = struct.unpack('L', valuestring)[0]
        #print(hex(value),end=' ')
        seconds = value * 0.000000005   # 5ns per cycle
        if seconds != old:
            print('{} seconds'.format(seconds))
            old = seconds
        sleep(0.01)
