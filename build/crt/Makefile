##
## Configuration
##

CC := ppu-gcc

CFLAGS := -Wall -pedantic -std=c99

LD := ppu-ld

LDFLAGS :=

TARGETS := crt0.o crt1.o crti.o crtn.o

PREFIX := $(PS3DEV)/ppu/ppu

##
## Build Rules
##

default: $(TARGETS)

clean:
	rm -f *.o

install: $(TARGETS)
	cp *.o $(PREFIX)/lib
	cp *.h $(PREFIX)/include

crt.o: crt1.c
	$(CC) $(CFLAGS) -c $< -o $@

crt1.o: crt0.o crt.o
	$(LD) $(LDFLAGS) -r crt0.o crt.o -o crt1.o

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@
