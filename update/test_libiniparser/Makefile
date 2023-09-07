CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS = -liniparser

SRCS = test_libiniparser.c
OBJS = $(SRCS:.c=.o)
EXEC = test_libiniparser

.PHONY: all clean

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(EXEC) $(OBJS)

