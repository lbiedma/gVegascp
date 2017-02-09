#include "vegasconst.h"
#define CUDART_PI_F 3.141592654f

__device__
float sum(float* rx, int dim)
{
	float value = 0.f;
	for (int i = 0; i < dim; i++){
		value += rx[i];
	}
	value = 1.f / sqrt((float)dim/12.f) * (value - (float)dim / 2.f);
	return value;
}

__device__
float sqsum(float* rx, int dim)
{
	float value = 0.f;
	for (int i = 0; i < dim; i++){
		value += rx[i] * rx[i];
	}
	value = sqrtf(45.f / (4.f * (float)dim)) * (value - (float)dim / 3);
	return value;
}

__device__
float sumsqroot(float* rx, int dim)
{
	float value = 0.f;
	for (int i = 0; i < dim; i++){
		value += sqrtf(rx[i]);
	}
	value = sqrtf(18.f / (float)dim) * (value - 2.f/3.f * (float)dim);
	return value;
}

__device__
float prodones(float* rx, int dim)
{
	float value = 1.f;
	for (int i = 0; i < dim; i++){
		value *= copysignf(1.f, rx[i]-0.5f);
	}
	return value;
}

__device__
float prodexp(float* rx, int dim)
{
	float e = sqrtf((15.f * expf(15.f) + 15.f) / (13.f * expf(15.f) + 17.f));
	e = powf(e, float(dim) * 0.5f);
	float value = 1.f;
	for (int i = 0; i < dim; i++){
		value *= ((expf(30.f * rx[i] - 15.f)) - 1.f) / (expf(30.f * rx[i] - 15.f) + 1.f);		
	}
	value *= e;
	return value;
}

__device__
float prodcub(float* rx, int dim)
{
	float value = 1.f;
	for (int i = 0; i < dim; i++){
		value *= (-2.4f*sqrtf(7.f)*(rx[0]-0.5f)+8.f*sqrtf(7.f)*(rx[i]-0.5f)*(rx[i]-0.5f)*(rx[i]-0.5f));
	}
	return value;
}

__device__
//PRODX has a lot of extremes when dimensions are big, it's expected to not do well
float prodx(float* rx, int dim)
{
	float value = 1.f;
	for (int i = 0; i < dim; i++){
		value *= (r[x] - 0.5f);
	}
	value *= powf(2.f*sqrtf(3.f), (float) dim);
	return value;
}

__device__
float sumfifj(float* rx, int dim)
{
	float value = 0.f;
	for (int i = 0; i < dim; i++){
		float aux = 0.f;
		for (int j = 0; j < i; j++){
			aux += copysignf(1.f,(1.f/6.f - rx[j])*( rx[j] - 4.f/6.f));
		}
		value += copysignf(1.f,(1.f/6.f - rx[i])*( rx[i] - 4.f/6.f)) * aux;
	}
	value *= sqrtf(2.f/(float)(dim * (dim-1)));
	return value;
}



