#include <cstdlib>
#include <iostream>
#include <unistd.h>
#include <ctime>
#include <sys/time.h>
#include <sys/resource.h>

// includes, project
#include "helper_cuda.h"
// include initial files

#define __MAIN_LOGIC
#include "vegas.h"
#include "gvegas.h"
#undef __MAIN_LOGIC

#include "kernels.h"

int main(int argc, char* argv[])
{

   //------------------
   //  Initialization
   //------------------
   //
   // program interface:
   //   program -n "ncall0" -i "itmx0" -a "nacc" -b "nBlockSize0"
   //
   // parameters:
   //   ncall = 1024*ncall0 is the amount of function calls
   //   itmx  = itmx0 is the maximum iterations for the algorithm
   //   acc   = nacc*0.00001f is the desired accuracy
   //   nBlockSize = nBlockSize0 is the size of the CUDA block
   //

   int ncall0 = 256;
   int itmx0 = 20;
   int nacc  = 10;
   int nBlockSize0 = 256;
   int c;

   while ((c = getopt (argc, argv, "n:i:a:b:")) != -1)
       switch (c)
         {
         case 'n':
           ncall0 = atoi(optarg);
           break;
         case 'i':
           itmx0 = atoi(optarg);
           break;
         case 'a':
           nacc = atoi(optarg);
           break;
         case 'b':
           nBlockSize0 = atoi(optarg);
           break;
         case '?':
           if (isprint (optopt))
             fprintf (stderr, "Unknown option `-%c'.\n", optopt);
           else
             fprintf (stderr,
                      "Unknown option character `\\x%x'.\n",
                      optopt);
           return 1;
         default:
           abort ();
         }

   ncall = ncall0*1024;
   itmx = itmx0;
   acc = (float)nacc*0.000001f;
   nBlockSize = nBlockSize0;

   //cutilSafeCallNoSync(cudaSetDevice(0));

   mds = 1;
   ndim = 6; //Dimension of integration space

   ng = 0;
   npg = 0;

   for (int i=0;i<ndim;i++) { //Choose the box where to integrate
      xl[i] = -1.; //lower bound
      xu[i] = 1.; //upper bound
   }

   nprn = 1;
//   nprn = -1;

   double avgi = 0.;
   double sd = 0.;
   double chi2a = 0.;

   gVegas(avgi, sd, chi2a);

   //-------------------------
   //  Print out information
   //-------------------------
   std::cout.clear();
   std::cout<<"#==========================="<<std::endl;
   std::cout<<"# No. of Thread Block Size : "<<nBlockSize<<std::endl;
   std::cout<<"#==========================="<<std::endl;
   std::cout<<"# No. of dimensions        : "<<ndim<<std::endl;
   std::cout<<"# No. of func calls / iter : "<<ncall<<std::endl;
   std::cout<<"# No. of max. iterations   : "<<itmx<<std::endl;
   std::cout<<"# Desired accuracy         : "<<acc<<std::endl;
   std::cout<<"#==========================="<<std::endl;
   std::cout<<"# Answer                   : "<<avgi<<" +- "<<sd<<std::endl;
   std::cout<<"# Chisquare                : "<<chi2a<<std::endl;
   std::cout<<"#==========================="<<std::endl;

   //cudaThreadExit();

   return 0;
}
