#
# Makefile for sccpic - PIC Small C compiler (GNU/Linux)
#

VERSION="0.3 - 02/11/98"

CC = gcc
CFLAGS = -Wall -O
RM = /bin/rm -f

SRCS = data.c error.c expr.c function.c gen.c io.c lex.c main.c preproc.c \
       postproc.c primary.c stmt.c sym.c while.c codepic.c

OBJS = data.o error.o expr.o function.o gen.o io.o lex.o main.o preproc.o \
       postproc.o primary.o stmt.o sym.o while.o codepic.o

DEST = pic_cc

$(DEST): $(OBJS)
	 $(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJS): data.h defs.h

clean:
	$(RM) $(OBJS) pic_cc *~ core

