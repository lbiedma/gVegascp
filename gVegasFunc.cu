#include "vegasconst.h"

__device__
float func(float* rx, float wgt)
{

   float value = 0.f;
   for (int i=0;i<g_ndim;i++) {
      value += rx[i]*rx[i];
   }
   return value;

}
