# MKL specific Linux settings

# We have tested Kaldi with MKL version 10.2 on Linux/GCC and Intel(R) 64
# architecture (also referred to as x86_64) with LP64 interface layer.

# The linking flags for MKL will be very different depending on the OS,
# architecture, compiler, etc. used. The correct flags can be obtained from
# http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/
# Use the options obtained from this website to manually configure for other
# platforms using MKL.

ifndef MKLROOT
$(error MKLROOT not defined.)
endif

MKLLIB ?= $(MKLROOT)/lib/em64t

CXXFLAGS += -m64 -msse -msse2 -pthread -rdynamic \
            -DHAVE_EXECINFO_H=1 -DHAVE_CXXABI_H -DHAVE_MKL -I$(MKLROOT)/include

## Use the following for STATIC LINKING of the SEQUENTIAL version of MKL
MKL_STA_SEQ = $(MKLLIB)/libmkl_solver_lp64_sequential.a -Wl,--start-group \
	$(MKLLIB)/libmkl_intel_lp64.a $(MKLLIB)/libmkl_sequential.a \
	$(MKLLIB)/libmkl_core.a -Wl,--end-group -lpthread

## Use the following for STATIC LINKING of the MULTI-THREADED version of MKL
MKL_STA_MUL = $(MKLLIB)/libmkl_solver_lp64.a -Wl,--start-group \
	$(MKLLIB)/libmkl_intel_lp64.a $(MKLLIB)/libmkl_intel_thread.a \
	$(MKLLIB)/libmkl_core.a -Wl,--end-group $(MKLLIB)/libiomp5.a -lpthread

## Use the following for DYNAMIC LINKING of the SEQUENTIAL version of MKL
MKL_DYN_SEQ = -L$(MKLLIB) -lmkl_solver_lp64_sequential -Wl,--start-group \
	-lmkl_intel_lp64 -lmkl_sequential -lmkl_core -Wl,--end-group -lpthread

## Use the following for DYNAMIC LINKING of the MULTI-THREADED version of MKL
MKL_DYN_MUL = -L$(MKLLIB) -lmkl_solver_lp64 -Wl,--start-group -lmkl_intel_lp64 \
	-lmkl_intel_thread -lmkl_core -Wl,--end-group -liomp5 -lpthread

# MKLFLAGS = $(MKL_DYN_MUL)

LDFLAGS += -rdynamic
LDLIBS += $(MKLFLAGS)
