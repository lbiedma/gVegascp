# gVegascp

Trying to give better performance to the code made in 2012 by Junichi Kanzaki (junichi.kanzaki@kek.jp)
to integrate functions with the VEGAS algorithm (variation of Monte Carlo).

The example function is norm(x)^2 in the [-1,-1]^6 box.

The code uses OpenMP to measure function times and can be compiled with "nvcc gVegasMain.cu -lgomp".
