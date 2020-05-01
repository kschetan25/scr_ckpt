MPICC     ?= mpicc
MPICXX    ?= mpicxx
MPIF90    ?= mpif90
OPT       ?= -g -O3
LIBDIR     = -L/users/kschetan/spack/opt/spack/linux-centos7-haswell/gcc-4.8.5/scr-2.0.0-sf5lueadjuyeh6ekw5xlcw4l525gyjrn/lib64 -Wl,-rpath,/users/kschetan/spack/opt/spack/linux-centos7-haswell/gcc-4.8.5/scr-2.0.0-sf5lueadjuyeh6ekw5xlcw4l525gyjrn/lib64 -lscr 
INCLUDES   = -I/users/kschetan/spack/opt/spack/linux-centos7-haswell/gcc-4.8.5/scr-2.0.0-sf5lueadjuyeh6ekw5xlcw4l525gyjrn/include -I/usr/include -I.

all: test_api test_api_multiple test_interpose test_interpose_multiple test_ckpt_C test_ckpt_F ping_pong

clean:
	rm -rf *.o test_api test_api_multiple test_interpose test_interpose_multiple test_ckpt_C ping_pong

test_api: test_common.o test_common.h test_api.c
	$(MPICC) $(OPT) $(CFLAGS) $(INCLUDES) -o test_api test_common.o test_api.c \
	  $(LDFLAGS) $(LIBDIR)

test_api_multiple: test_common.o test_common.h test_api_multiple.c
	$(MPICC) $(OPT) $(CFLAGS) $(INCLUDES) -o test_api_multiple test_common.o test_api_multiple.c \
	  $(LDFLAGS) $(LIBDIR)

test_interpose: test_interpose.c
	$(MPICC) $(OPT) $(CFLAGS) -o test_interpose test_interpose.c $(LDFLAGS)

test_interpose_multiple: test_common.o test_common.h test_interpose_multiple.c
	$(MPICC) $(OPT) $(CFLAGS) -o test_interpose_multiple test_common.o test_interpose_multiple.c $(LDFLAGS)

test_common.o: test_common.c test_common.h
	$(MPICC) $(OPT) $(CFLAGS) $(INCLUDES) -c -o test_common.o test_common.c

test_ckpt_C: test_ckpt.C
	$(MPICXX) $(OPT) $(CXXFLAGS) $(INCLUDES) -o test_ckpt_C test_ckpt.C \
	  $(LDFLAGS) $(LIBDIR)

test_ckpt_F: test_ckpt.F
	$(MPIF90) $(OPT) $(F90FLAGS) $(INCLUDES) -o test_ckpt_F test_ckpt.F \
	  $(LDFLAGS) -lscrf $(LIBDIR)

ping_pong: ping_pong.c
	$(MPIF90) $(OPT) $(F90FLAGS) $(INCLUDES) -o ping_pong ping_pong.c \
	  $(LDFLAGS) -lscrf $(LIBDIR)