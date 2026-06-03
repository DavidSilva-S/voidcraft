# st - simple terminal
# See LICENSE file for copyright and license details.

include config.mk

SRC = st.c x.c boxdraw.chb.c
OBJ = ${SRC:.c=.o}

all: options st

options:
	@echo st build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

st: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f st ${OBJ} st-${VERSION}.tar.gz config.h

dist: clean
	mkdir -p st-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		st.1 arg.h  boxdraw.h hb.h ${SRC} st-${VERSION}
	tar -cf st-${VERSION}.tar st-${VERSION}
	gzip st-${VERSION}.tar
	rm -rf st-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f st ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/st
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < st.1 > ${DESTDIR}${MANPREFIX}/man1/st.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/st.1
	tic -sx st.info

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/st\
		${DESTDIR}${MANPREFIX}/man1/st.1

.PHONY: all options clean dist install uninstall
