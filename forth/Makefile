CC = gcc
CFLAGS = -nostdlib -static -g

forth: forth.S
	$(CC) $(CFLAGS) -o $@ $<

test: forth
	./forth run.fs
