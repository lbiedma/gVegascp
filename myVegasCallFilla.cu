#include "vegasconst.h"
#include "vegas.h"

__device__ float d[ndim_max][nd_max];
__device__ float dtsi;
__device__ float dti;

__global__
void initzero(void){
  for (int dim = 0; dim < ndim_max; dim++){
    for (int box = 0; box < nd_max; box ++){
      d[dim][box] = 0.0f;
    }
  }
  dti = 0.0f;
  dtsi = 0.0f;
}

__global__
void myVegasCallFilla(int mds)
{
   //--------------------
   // Check the thread ID
   //--------------------
   const unsigned int tIdx  = threadIdx.x;
   const unsigned int bDimx = blockDim.x;

   const unsigned int bIdx  = blockIdx.x;
   const unsigned int gDimx = gridDim.x;
   const unsigned int bIdy  = blockIdx.y;
   //   const unsigned int gDimy = gridDim.y;

   unsigned int bid  = bIdy*gDimx+bIdx;
   const unsigned int tid = bid*bDimx+tIdx;

   //Using float for now, atomicAdd doesn't support double yet...
   __shared__ float block_fb;
   __shared__ float block_f2b;

   //int ig = tid;
   int lane = tid % warpSize;
   //d[tid] = 0.0;
   int kg[ndim_max];
   unsigned ia[ndim_max];
   //fb and f2b will be the accumulations of f and the "error", these values
   //will be reduced later and stored in dti and dtsi.
   block_fb = 0.0f;
   block_f2b = 0.0f;
   float fb = 0.0f;
   float f2b = 0.0f;

   if (tid<g_nCubes) {

      for (int point = 0; point < g_npg; point++){
        unsigned int tidRndm = tid * g_npg + point;

        unsigned igg = tid;
        for (int j=0;j<g_ndim;j++) {
           kg[j] = igg%g_ng+1;
           igg /= g_ng;
        }

        //Generate a random point in [0,1]^ndim.
        float randm[ndim_max];
        fxorshift128(tidRndm, g_ndim, randm);

        float x[ndim_max];

        float wgt = g_xjac;
        /*
        This piece of code places the random point in the domain of integration,
        g_xi will change at every iteration as a result of the refining step, so
        the weight will change as well.
        */
        for (int j=0;j<g_ndim;j++) {
          float xo,xn,rc;
          xn = (kg[j]-randm[j])*g_dxg+1.f;
          ia[j] = (int)xn-1;
          if (ia[j]<=0) {
            xo = g_xi[j][ia[j]];
            rc = (xn-(float)(ia[j]+1))*xo;
          } else {
            xo = g_xi[j][ia[j]]-g_xi[j][ia[j]-1];
            rc = g_xi[j][ia[j]-1]+(xn-(float)(ia[j]+1))*xo;
          }
          x[j] = g_xl[j]+rc*g_dx[j];
          wgt *= xo*(float)g_nd;
        }

        float f = wgt * func(x,wgt);
        fb += f;
        float f2 = f*f;
        f2b += f2;
        //If mds = 1, we just have to add f^2 to the corresponding space in d.
        if (mds > 0){
          for (int idim = 0; idim < g_ndim; idim++) {
            atomicAdd(&(d[idim][ia[idim]]), f2);
          }
        }
      }

      /*When mds = -1, original code uses the data of the first element of the
      cube to store f2b in d, that won't change much if I use the last element.
      If it does, maybe we can go for a decreasing loop in npg...*/
      f2b = sqrt(f2b * g_npg);
      f2b = (f2b - fb) * (f2b - fb);
      if (mds < 0){
        for (int idim = 0; idim < g_ndim; idim++)
        atomicAdd(&d[idim][ia[idim]], f2b);
      }
      __syncthreads();
      //REDUCE TIME!!!

      for (int offset = warpSize/2; offset < 0; offset /= 2){
        fb += __shfl_down(fb, offset);
        f2b += __shfl_down(f2b, offset);
      }

      if (0 == lane){
        atomicAdd(&block_fb, fb);
        atomicAdd(&block_f2b, f2b);
      }

		  __syncthreads();

      if (0 == tid){
        atomicAdd(&dti, block_fb);
        atomicAdd(&dtsi, block_f2b);
      }
    }

}
