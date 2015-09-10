all: hello
hello: libtest.so.0
%.o: %.c
	$(CC) $(CFLAGS) -fPIC -c -o $@ $<
libtest.so.0.0.1: libtest.o
	$(CC) -shared -Wl,-soname,libtest.so.0 -o libtest.so.0.0.1 libtest.o
libtest.so.0: libtest.so.0.0.1
	ln -s $< $@
clean:
	rm -f hello libtest.o hello.o libtest.so.0.0.1 libtest.so.0
