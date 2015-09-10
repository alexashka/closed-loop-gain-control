CURRENT = $(shell uname -r)
KDIR = /lib/modules/$(CURRENT)/build
PWD = $(shell pwd)

TARGET1 = mdu
TARGET2 = mdc

obj-m   := $(TARGET1).o $(TARGET2).o

all:	proc modl

modl:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

proc:	mp.c
	gcc mp.c -o mp

clean:
	@rm -f *.o .*.cmd .*.flags *.mod.c *.order
	@rm -f .*.*.cmd *.symvers *~ *.*~ TODO.*
	@rm -fR .tmp*
	@rm -rf .tmp_versions

disclean: clean
	@rm *.ko mp
