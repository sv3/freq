
COMPILER=/usr/bin/pasm -b 
#FILENAME=rpm
FILENAME=rpm

.PHONY: clean all

all:
	$(COMPILER) $(FILENAME).p


clean: 
	rm -rf $(FILENAME).bin


