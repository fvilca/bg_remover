#pragma once
#include"bgRemover.cuh"
#include"kernel.cuh"
#include "IModifier.h"
#include<iostream>
using namespace std;


class App{

private:
	float * dev_bg_gray; //[1]
	float * host_bg_gray;
	//uchar * host_bg_rgb;
	//float * dev_bg_rgb;
	IModifier* bgRemoverCuda;
	IModifier* edgeDetector;

public:
	App(){
		bgRemoverCuda = new BgRemoverCuda;
	}
	~App(){
		delete this;
	}

	/*
	 *	Carga la imagen de prueba
	 */
	void init(){
		
		
	}

	/*
	*	carga la imagen e invoca a bgRemover
	*/
	void execute(){
		cout << "ejecutando bgRemover"<<endl;
		
		Mat mat_bg, mat_bg2;
		Mat mat_curr;
		Mat mat_out;

		
		VideoCapture cap;
		cap.open(0);

		int  q = 10;
		while (--q){
			cap.read(mat_bg);
		}
		int W = mat_bg.cols;
		int H = mat_bg.rows;
		cvtColor(mat_bg, mat_bg, CV_BGR2GRAY);
		cap.release();
		
		//[2] Capturar frames
		cout << "bg listo\n";

		cap.open(0);
		while (1){
			cap.read(mat_curr);
			cvtColor(mat_curr, mat_curr, CV_BGR2GRAY);
			bgRemoverCuda->processFrame(mat_bg, mat_curr, mat_out);
			imshow("result frame::", mat_out);
			if (cv::waitKey(1) == 27) break;
		}
		cap.release();
		
		
	}
};

App* getApplication(void){
	return new App();
}