#include <iostream>
#include "mpi.h"
using namespace std;

int main(int argc, char **argv)
{
  int numtasks, rank, dest, source, rc, count, tag=1;
  int version, subversion;
  char inmsg, outmsg='x';
  MPI::Status Stat;

  MPI::Init(argc,argv);
  numtasks = MPI::COMM_WORLD.Get_size();
  rank = MPI::COMM_WORLD.Get_rank();
  MPI::Get_version(version, subversion);
  
  if(rank == 0)
    cout << "MPI VERS: " << version << "." << subversion <<endl;

  if (rank == 0) {
    dest = 1;
    source = 1;
    MPI::COMM_WORLD.Send(&outmsg, 1, MPI_CHAR, dest, tag);
    MPI::COMM_WORLD.Recv(&inmsg, 1, MPI_CHAR, source, tag, Stat);
  } 

  else if (rank == 1) {
    dest = 0;
    source = 0;
    MPI::COMM_WORLD.Recv(&inmsg, 1, MPI_CHAR, source, tag, Stat);
    MPI::COMM_WORLD.Send(&outmsg, 1, MPI_CHAR, dest, tag);
  }

  count = Stat.Get_count(MPI_CHAR);
  printf("Task %d: Received %d char(s) from task %d with tag %d \n",
	 rank, count, Stat.Get_source(), Stat.Get_tag());

  MPI::Finalize();
  return 0;
}
