#!/bin/sh

PROG = matlab -r run_classification
all: 
	$(PROG)
all.tar:
	tar -czvf insect_classificaton.tar.gz *
paper.pdf:
	cd report && $(MAKE)
clean:
	rm -rf *.o *.class *.aux
