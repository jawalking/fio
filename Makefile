CC	= gcc
CFLAGS	= -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
PROGS	= fio
SCRIPTS = fio_generate_plots

INSTALL = install
prefix = /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib/fio

FIO_INST_DIR = $(subst ','\'',$(prefix))

CFLAGS += '-D_INST_PREFIX="$(FIO_INST_DIR)"'

all: depend $(PROGS) $(SCRIPTS)
	$(MAKE) -C engines

fio: fio.o ioengines.o init.o stat.o log.o time.o md5.o crc32.o filesetup.o
	$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) -lpthread -laio -lm -lrt -ldl

clean:
	-rm -f *.o .depend cscope.out $(PROGS) engines/*.o

depend:
	@$(CC) -MM $(ALL_CFLAGS) *.c 1> .depend

cscope:
	@cscope -b

install: $(PROGS) $(SCRIPTS)
	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
	$(INSTALL) -m755 -d $(DESTDIR) $(libdir)
	$(INSTALL) engines/*.o $(libdir)

ifneq ($(wildcard .depend),)
include .depend
endif
