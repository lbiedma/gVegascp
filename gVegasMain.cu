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

int main(int argc, char** argv)
{

   //------------------
   //  Initialization
   //------------------
   //
   // program interface:
   //   program -n="ncall0" -i="itmx0" -a="nacc" -b="nBlockSize0"
   //
   // parameters:
   //   ncall = 1024*ncall0
   //   itmx  = itmx0
   //   acc   = nacc*0.00001f
   //   nBlockSize = nBlockSize0
   //

   int ncall0 = 256;
   int itmx0 = 10;
   int nacc  = 1;
   int nBlockSize0 = 256;
   int ndim0 = 6;

   int c;

   while ((c = getopt (argc, argv, "n:i:a:b:d:")) != -1)
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
           case 'd':
             ndim0 = atoi(optarg);
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
   acc = (float)nacc*0.00001f;
   nBlockSize = nBlockSize0;
   ndim = ndim0;

   mds = 1;

   ng = 0;
   npg = 0;

   for (int i=0;i<ndim;i++) {
      xl[i] = -1.;
      xu[i] = 1.;
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

   cudaThreadExit();

   //Print running times!
   std::cout<<"#==========================="<<std::endl;
   std::cout<<"# Function call time per iteration: " <<timeVegasCall/(double)it<<std::endl;
   std::cout<<"# Values moving time per iteration: " <<timeVegasMove/(double)it<<std::endl;
   std::cout<<"# Filling (reduce) time per iteration: " <<timeVegasFill/(double)it<<std::endl;
   std::cout<<"# Refining time per iteration: " <<timeVegasRefine/(double)it<<std::endl;
   std::cout<<"#==========================="<<std::endl;

   return 0;
}
