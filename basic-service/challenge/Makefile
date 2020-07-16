CC=gcc
CFLAGS=-Wall
LDFLAGS=
SRCS=$(wildcard *.c)
OBJS=$(SRCS:.c=.o)

BIN=challenge

build: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)
