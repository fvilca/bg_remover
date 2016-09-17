#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv\cv.h>
#include <cuda.h>

using namespace cv;
using namespace std;

__global__ void gpu_bg_remover(uchar *bg, uchar *curr, uchar *out, int W, int H) {

	int col = threadIdx.x + blockDim.x * blockIdx.x;
	int row = threadIdx.y + blockDim.y * blockIdx.y;

	int grid_width = gridDim.x * blockDim.x;
	int index = col + (row * grid_width);

	int threshold = 50;
	if (col < W && row < H){
		
		int pixelBG = bg[index];
		int pixelCURR = curr[index];
		int distancia = abs(pixelBG - pixelCURR);
		int threhold = 50;

		(distancia < threshold)
			? out[index] = 255
			: out[index] = curr[index];
	}

}



__global__ void gpu_gray_converter(unsigned char *d_in, float *d_out, int N)
{
	int idx = blockIdx.x*blockDim.x + threadIdx.x;

	if (idx < N)
		d_out[idx] = d_in[idx * 3] * 0.1144f + d_in[idx * 3 + 1] * 0.5867f + d_in[idx * 3 + 2] * 0.2989f;
}
