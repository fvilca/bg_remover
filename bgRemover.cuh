#include"IModifier.h"
#include"kernel.cuh"

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
//#include <opencv2/imgproc/imgproc.hpp>
#include <opencv\cv.h>

#include <cuda.h>
using namespace cv;
using namespace std;


class BgRemoverCuda: public IModifier
{
public:
	
	Mat outimg;
	uchar *c;
	uchar *dev_c;

	uchar *host_bg;
	uchar *host_curr;

	uchar *dev_bg;
	uchar *dev_curr;
	uchar *dev_out;

	//float * dev_img_gray; //[1]

	int size;



	BgRemoverCuda();
	~BgRemoverCuda();
	void processFrame(Mat &mat_bg, Mat &mat_curr, Mat &mat_out)
	{
		
		
		int W = mat_bg.cols;
		int H = mat_bg.rows;

		cout << mat_bg.rows << "-" << mat_bg.cols << "-" << mat_bg.type() << endl;
		mat_out.create(mat_bg.rows, mat_bg.cols, mat_bg.type());
		int N = 4096;

		cudaEvent_t start, stop;
		float elapsed_time_ms;
		size = W * H * sizeof(int);

		c = (uchar*)malloc(size);
		host_bg = (uchar*)malloc(size);
		host_curr = (uchar*)malloc(size);


		uchar* data_bg = mat_bg.ptr<uchar>(0);
		for (int i = 0; i < W*H; i++) {
			host_bg[i] = data_bg[i];
		}

		uchar* data_curr = mat_curr.ptr<uchar>(0);
		for (int i = 0; i < W*H; i++) {
			host_curr[i] = data_curr[i];
		}
		//host_curr = mat_curr.data;

		cudaEventCreate(&start);     		// instrument code to measure start time
		cudaEventCreate(&stop);
		cudaEventRecord(start, 0);


		uchar* data = mat_bg.ptr<uchar>(0);
		for (int i = 0; i < W*H; i++) {
			c[i] = data[i];
		}

		cudaMalloc((void**)&dev_c, size);
		cudaMalloc((void**)&dev_bg, size);
		cudaMalloc((void**)&dev_curr, size);
		cudaMalloc((void**)&dev_out, size);
		//cudaMalloc((void**)&dev_img_gray, sizeof(float)*W*H); //[2]

		cudaMemcpy(dev_c, c, size, cudaMemcpyHostToDevice);

		cudaMemcpy(dev_bg, host_bg, size, cudaMemcpyHostToDevice);
		cudaMemcpy(dev_curr, host_curr, size, cudaMemcpyHostToDevice);



		
		//cudaEventSynchronize(start);  	// Needed?


		int nThreadsX = 16;
		int nThreadsY = 16;
		int blocksW = W / nThreadsX + ((W % nThreadsX) ? 1 : 0); // or =(w+nThreads-1)/nThreads
		int blocksH = H / nThreadsY + ((H % nThreadsY) ? 1 : 0); // or '=(h+nThreads-1)/nThreads


		dim3 blocks(blocksW, blocksH);
		dim3 threads(nThreadsX, nThreadsY);
		gpu_bg_remover << <blocks, threads >> >(dev_bg, dev_curr, dev_out, W,H);
		cudaMemcpy(c, dev_out, size, cudaMemcpyDeviceToHost);

		cudaEventRecord(stop, 0);     	// instrument code to measue end time
		cudaEventSynchronize(stop);
		cudaEventElapsedTime(&elapsed_time_ms, start, stop);
		printf("Time to calculate results on GPU: %f ms.\n", elapsed_time_ms);  // print out execution time

		//cudaEventRecord(start, 0);		// use same timing
		//cudaEventSynchronize(start);  	// Needed?



		//cudaEventRecord(stop, 0);     	// instrument code to measue end time
		//cudaEventSynchronize(stop);
		//cudaEventElapsedTime(&elapsed_time_ms, start, stop);


		//printf("Time to calculate results on CPU: %f ms.\n", elapsed_time_ms);  // print out execution time



		int pixel = 0;
		for (int i = 0; i < H; i++)
			for (int j = 0; j < W; j++) {
				pixel = c[(i *W) + j];
				setPixel1(mat_out, i, j, pixel);
			}
		//cudaEventDestroy(start);
		//cudaEventDestroy(stop);


		//system("pause");
	}

private:

};


BgRemoverCuda::BgRemoverCuda()
{
}

BgRemoverCuda::~BgRemoverCuda()
{
	free(c);
	cudaFree(dev_c);
	
}







////GaussianBlur(img, img, Size(7, 7), 0, 0);