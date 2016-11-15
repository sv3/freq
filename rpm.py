# rpm.py - gets rpm value

import pypruss
import os

os.system("config-pin p8.12 pruout")

pypruss.modprobe()                                  # This only has to be called once pr boot
pypruss.init()                                      # Init the PRU
pypruss.open(0)                                     # Open PRU event 0 which is PRU0_ARM_INTERRUPT
#pypruss.pruintc_init()                              # Init the interrupt controller
pypruss.exec_program(0, "./rpm.bin")           # Load firmware "blinkled.bin" on PRU 0
#pypruss.wait_for_event(0)                           # Wait for event 0 which is connected to PRU0_ARM_INTERRUPT
#pypruss.clear_event(0,pypruss.PRU0_ARM_INTERRUPT)   # Clear the event
#pypruss.pru_disable(0)                              # Disable PRU 0, this is already done by the firmware
#pypruss.exit()                                      # Exit, don't know what this does.
