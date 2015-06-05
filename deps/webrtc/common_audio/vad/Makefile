OBJ = \
webrtc_vad.o \
vad_core.o \
vad_filterbank.o \
vad_gmm.o \
vad_sp.o

CFLAGS += -I../../.. -I./include

vad: libvad.a vad.o
	gcc -pthread -I./include -I../../.. vad.c -static -L. \
		-L../signal_processing \
		-lvad -ldsp -o vad

libvad.a: $(OBJ)
	ar rcs libvad.a $(OBJ)

.PHONY: clean
clean:
	rm -f vad libvad.a $(OBJ)
