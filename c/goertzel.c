/*
 * main.c
 *
 *  Created on: Jun 27, 2020
 *      Author: pablo
 */

#include <math.h>
#include "xparameters.h"
#include "xgpio.h"

#define pi 3.14159265359
#define signal_add (long*)0x80000000
#define n_samples 64
#define capture_window_add (long*)0x80002000
#define n_samples_add (long*)0x80002004


int main (void) {

	/* Goertzel constants declaration */
	float w_re1, w_im1;
	float w_re5, w_im5;
	float w_re10, w_im10;

	/* Pipeline variables declaration */
	long* x;
	float x_1;

	float x_value;

	float y_re1, y_re1_1, y_re1_2;
	float y_im1, y_im1_1, y_im1_2;
	float c1;

	float y_re5, y_re5_1, y_re5_2;
	float y_im5, y_im5_1, y_im5_2;
	float c5;

	float y_re10, y_re10_1, y_re10_2;
	float y_im10, y_im10_1, y_im10_2;
	float c10;

	float h1, h5, h10;

	int i;

	long * capture_window;
	long *nsamples_reg;

	int finish;
	long mask = 0;

	XGpio Gpio; /* The Instance of the GPIO Driver */

	XGpio_Initialize(&Gpio, XPAR_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&Gpio, 1, 0);
	XGpio_DiscreteWrite(&Gpio, 1, mask);

	/* Goertzel constant definition */
	w_re1 = cos(2*pi*1/n_samples);
	w_im1 = sin(2*pi*1/n_samples);
	c1 = 2*cos(2*pi*1/n_samples);

	w_re5 = cos(2*pi*5/n_samples);
	w_im5 = sin(2*pi*5/n_samples);
	c5 = 2*cos(2*pi*5/n_samples);

	w_re10 = cos(2*pi*10/n_samples);
	w_im10 = sin(2*pi*10/n_samples);
	c10 = 2*cos(2*pi*10/n_samples);

	nsamples_reg = n_samples_add;
	capture_window = capture_window_add;

	*nsamples_reg = 255;

	while(1) {


		*capture_window = 1;

//		XGpio_DiscreteWrite(&Gpio, 1, 0x2);

		y_re1 = 0;
		y_re1_1 = 0;
		y_re1_2 = 0;
		y_im1 = 0;
		y_im1_1 = 0;
		y_im1_2 = 0;

		y_re5 = 0;
		y_re5_1 = 0;
		y_re5_2 = 0;
		y_im5 = 0;
		y_im5_1 = 0;
		y_im5_2 = 0;

		y_re10 = 0;
		y_re10_1 = 0;
		y_re10_2 = 0;
		y_im10 = 0;
		y_im10_1 = 0;
		y_im10_2 = 0;
		*capture_window = 0;

		x = signal_add;

		for (i=0; i<(n_samples*4); i=i+4) {

//			y_re1 = (float)*x*w_re1-x_1+c1*y_re1_1-y_re1_2;
//			y_im1 = (float)*x*w_im1+c1*y_im1_1-y_im1_2;
//
//			y_re1_2 = y_re1_1;
//			y_re1_1 = y_re1;
//			y_im1_2 = y_im1_1;
//			y_im1_1 = y_im1;

			y_re5 = (float)*x*w_re5-x_1+c5*y_re5_1-y_re5_2;
			y_im5 = (float)*x*w_im5+c5*y_im5_1-y_im5_2;

			y_re5_2 = y_re5_1;
			y_re5_1 = y_re5;
			y_im5_2 = y_im5_1;
			y_im5_1 = y_im5;

//			y_re10 = (float)*x*w_re10-x_1+c10*y_re10_1-y_re10_2;
//			y_im10 = (float)*x*w_im10+c10*y_im10_1-y_im10_2;
//
//			y_re10_2 = y_re10_1;
//			y_re10_1 = y_re10;
//			y_im10_2 = y_im10_1;
//			y_im10_1 = y_im10;

			x_1 = *x;
			x++;
		}

//		h1 = y_im1*y_im1+y_re1*y_re1;
		h5 = y_im5*y_im5+y_re5*y_re5;
//		h10 = y_im10*y_im10+y_re10*y_re10;
//		XGpio_DiscreteWrite(&Gpio, 1, 0x0);
		mask = 0;

		if (h1 > 10000000)
			mask |= 0x1;

		if (h5 > 10000000)
			mask |= 0x2;

		if (h10 > 10000000)
			mask |= 0x4;

		XGpio_DiscreteWrite(&Gpio, 1, mask);

		finish = finish+1;

	}
}

