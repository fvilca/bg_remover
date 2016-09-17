
#include "App.cuh"
#include <iostream>


using namespace std;


int main() {

	App* app = getApplication();
	app->init();
	app->execute();
	

	

	return 0;

}
