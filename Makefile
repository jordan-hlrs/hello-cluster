COMP   = CC
CFLAGS = -std=c++11 -fopenmp --rocm-path=${ROCM_PATH} -x hip
LMOD_SYSTEM_NAME = frontier
LFLAGS = -fopenmp --rocm-path=${ROCM_PATH}
INCLUDES  = -I${ROCM_PATH}/include
LIBRARIES = -L${ROCM_PATH}/lib -lamdhip64

BUILDDIR = build

.PHONY: all clean

all: $(BUILDDIR)/hello_jobstep $(BUILDDIR)/jobscript.pbs

$(BUILDDIR)/hello_jobstep: hello_jobstep.o | $(BUILDDIR)
	${COMP} ${LFLAGS} ${LIBRARIES} hello_jobstep.o -o $@

hello_jobstep.o: hello_jobstep.cpp
	${COMP} ${CFLAGS} ${INCLUDES} -c hello_jobstep.cpp

$(BUILDDIR)/jobscript.pbs: jobscript.pbs | $(BUILDDIR)
	cp jobscript.pbs $@

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR) *.o
