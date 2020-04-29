// mpig++ -g -O0 -I../src -o test_ckpt_C test_ckpt.C -L/usr/local/tools/scr-1.1/lib -lscr

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

#include "mpi.h"
#include "scr.h"

using namespace std;

int checkpoint()
{
  // inform SCR that we are starting a new checkpoint
  SCR_Start_checkpoint();

  // get our rank
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // build the filename for our checkpoint file
  stringstream tmp;
  tmp << "rank_" << rank << ".ckpt";
  string name = tmp.str();
  cout << "File= " << name << endl;

  // register our checkpoint file with SCR,
  // and ask SCR where to write the file
  char file[SCR_MAX_FILENAME];
  SCR_Route_file(name.c_str(), file);
  cout << "File: " << file << endl;

  // write our checkpoint file
  int valid = 1;

  ofstream ckpt;
  ckpt.open(file, ios::out | ios::trunc);
  ckpt << "I am in ckpt file 10" << endl;
  ckpt.close();

  // inform SCR whether this process wrote each of its
  // checkpoint files successfully
  SCR_Complete_checkpoint(valid);

  return 0;
}

int restart()
{
  SCR_Start_restart(NULL);
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  char checkpoint_file[SCR_MAX_FILENAME];
  sprintf(checkpoint_file, "rank_%d.ckpt", rank);
  cout << "File= " << checkpoint_file << endl;

  char scr_file[SCR_MAX_FILENAME];
  SCR_Route_file(checkpoint_file, scr_file);
  cout << "File: " << scr_file << endl;

  ofstream ckpt;
  ckpt.open(checkpoint_file, ios::out | ios::trunc);
  ckpt << "I am in ckpt file 11" << endl;
  ckpt.close();

  SCR_Complete_restart(1);

  return 0;
}

int main()
{
  MPI_Init(NULL, NULL);

  // initialize the SCR library
  SCR_Init();
  int have_restart;
  SCR_Have_restart(&have_restart, NULL);
  if (have_restart)
    restart();

  else
  {

    // ask SCR whether we need to checkpoint
    int flag = 0;
    SCR_Need_checkpoint(&flag);
    if (flag)
    {
      // execute the checkpoint code
      checkpoint();
    }
  }

  // shut down the SCR library
  SCR_Finalize();

  MPI_Finalize();

  return 0;
}
