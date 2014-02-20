SRCDIR=.
ifneq (,$(findstring ghc,$(HOSTNAME)))
  # For ghc machines
  CXX=/usr/lib64/openmpi/bin/mpic++
  MPIRUN=/usr/lib64/openmpi/bin/mpirun
  LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
else ifneq (,$(findstring blacklight,$(HOSTNAME)))
  CXX=mpic++
  # Do not run this on blacklight
  MPIRUN=
else
  CXX=mpic++
  MPIRUN=mpirun
endif

mpi:=$(shell which mpic++ 2>/dev/null)
ifeq ($(mpi),)
  $(error "mpic++ not found - did you set your environment variables or load the module?")
endif

SRCS=\
     $(SRCDIR)/main.cpp 

# Pattern substitute replace .cpp in srcs with .o it makes sense
OBJS=$(patsubst $(SRCDIR)/%.cpp,$(SRCDIR)/%.o,$(SRCS))

CXXFLAGS+=-O3 -std=c++0x #-Wall -Wextra
LDFLAGS+=-lpthread -lmpi -lmpi_cxx


# all should come first in the file, so it is the default target!
all : mpi_test

run : mpi_test
	$(MPIRUN) -np 2 mpi_test.exec

mpi_test: $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o mpi_test.exec

$(SRCDIR)/%.o: $(SRCDIR)/%.cpp $(SRCDIR)/*.h Makefile
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $< -c -o $@

clean:
	rm -rf *.o mpi_test

