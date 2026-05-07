COMP   = CC

CFLAGS = -std=c++11 -fopenmp --rocm-path=${ROCM_PATH} -x hip

LMOD_SYSTEM_NAME=frontier

LFLAGS = -fopenmp --rocm-path=${ROCM_PATH}

INCLUDES  = -I${ROCM_PATH}/include
LIBRARIES = -L${ROCM_PATH}/lib -lamdhip64

hello_jobstep: hello_jobstep.o
	${COMP} ${LFLAGS} ${LIBRARIES} hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cpp
	${COMP} ${CFLAGS} ${INCLUDES} -c hello_jobstep.cpp

.PHONY: clean

clean:
	rm -f hello_jobstep *.o
