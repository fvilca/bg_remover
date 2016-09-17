#pragma once
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
using namespace std;
using namespace cv;


class IModifier {

public:

	//virtual ~Modifier(void){}
	//
	virtual void processFrame(Mat &bg, Mat& curr, Mat &out)/*const*/ = 0;
	//funciones	de read y write pixel
	int getPixel(Mat& mat, int fil, int col){ return (uchar)mat.at<uchar>(fil, col); }
	cv::Vec3b& getPixel3(Mat& mat, int j, int i){ return mat.at<cv::Vec3b>(j, i); }
	void setPixel3(Mat& mat, int fil, int col, cv::Vec3b& color){ mat.at<cv::Vec3b>(fil, col) = color; }
	void setPixel1(Mat& mat, int fil, int col, int pixel){ mat.at<uchar>(fil, col) = pixel; }
	void print(int *mat, int N){

		int i, j;
		cout << endl;
		for (i = 0; i < N; i++){			// load arrays with some numbers
			for (j = 0; j < N; j++) {
				cout << mat[i * N + j] << " ";
			}cout << endl;
		}
	}

};