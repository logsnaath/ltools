CC = gcc
CFLAGS = -Wall -Wextra -pedantic -std=c99 # -I./libheif
LIBS = -lheif

all: decode_heif encode_heif

decode_program: decode_heif.c
	$(CC) $(CFLAGS) -o decode_program decode_program.c $(LIBS)

encode_program: encode_heif.c
	$(CC) $(CFLAGS) -o encode_program encode_program.c $(LIBS)

clean:
	rm -f decode_program encode_program

