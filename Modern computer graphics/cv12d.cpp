// MPC-MPG cviceni 12
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

using namespace cv;
using namespace std;

#undef MAX
#undef MIN
#define MAX(a,b) (a>b)?(a):(b)
#define MIN(a,b) (a<b)?(a):(b)

// globální deklarace
Mat g_input;		// vstupní obraz
Mat g_temp[3];		// tøi jednokanálové obrazy
Mat g_output;		// výstupní obraz

///////////////////////////////////////////////////////////////////////////////////////////
// pøevod BGR na YCbCr
// in  ... 3kanálový obraz
// out ... 3x 1kanálový obraz
///////////////////////////////////////////////////////////////////////////////////////////
void There(const Mat& in, Mat out[3])
{
	// získání informací o vstupním obraze
	int cols = in.cols;              // poèet slouocù (šíøka obrazu)
	int rows = in.rows;              // poèet øádkù (výška obrazu)
	int i_chnls = in.channels();     // poèet barevných kanálù
	int o_chnls = out[0].channels(); // poèet barevných kanálù
	int i_step = in.step;            // vzdálenost mezi øádky
	int o_step = out[0].step;        // vzdálenost mezi øádky

	// získání ukazatelù na obrazová data
	const uchar* i_data = in.data;
	uchar* o_data[] = { out[0].data, out[1].data, out[2].data };

	uchar R, G, B; // pomocné promìnné pro vstupní obraz

	// x, y jsou souøadnice pixelu
	for (int y = 0; y < rows; y++)	// cyklus prochází pøes všechny rádky
	{
		// získání ukazatelù na první pixel v øádku y
		const uchar* i_row = i_data + y * i_step;
		uchar* o_row[] = { o_data[0] + y * o_step, o_data[1] + y * o_step, o_data[2] + y * o_step };

		for (int x = 0; x < cols; x++)	// cyklus pøes pixely v akt. øádku	
		{
			// pøístup k pixelùm
			const uchar* i_pixel = i_row + x * i_chnls;
			uchar* o_pixel[] = { o_row[0] + x * o_chnls, o_row[1] + x * o_chnls, o_row[2] + x * o_chnls };

			// vstupní složky pixelu
			B = i_pixel[0];
			G = i_pixel[1];
			R = i_pixel[2];

			///////////////////////////////////////////////////
			// DOPLNIT - výstupní složky obrazu (BGR -> YCbCr)
			///////////////////////////////////////////////////
			*o_pixel[0] = (uchar)MAX(MIN((0.2990*R + 0.5870*G + 0.1140*B), 255), 0);
			*o_pixel[1] = (uchar)MAX(MIN((-0.1687*R - 0.3313*G + 0.5000*B + 128), 255), 0);
			*o_pixel[2] = (uchar)MAX(MIN((0.5000*R - 0.4187*G - 0.0813*B + 128), 255), 0);


		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
// pøevod YCbCr na BGR
// in  ... 3x 1kanálový obraz
// out ... 3kanálový obraz
///////////////////////////////////////////////////////////////////////////////////////////
void BackAgain(const Mat in[3], Mat& out)
{
	// ziskani informaci o vstupnim obraze
	int cols = in[0].cols;			// poèet sloupcu (sirka obrazu)
	int rows = in[0].rows;			// poèet radku (vyska obrazu)
	int i_chnls = in[0].channels(); // poèet barevných kanalu
	int o_chnls = out.channels();	// poèet barevných kanalu
	int i_step = in[0].step;		// vzdalenost mezi radky
	int o_step = out.step;			// vzdalenost mezi radky

	// získání ukazatelù na obrazová data
	const uchar * i_data[] = { in[0].data, in[1].data, in[2].data };
	uchar* o_data = out.data;

	uchar Y, Cb, Cr;

	for (int y = 0; y < rows; y++)	// cyklus prochází pres všechny øádky
	{
		// získání ukazatelù na první pixel v øádku y
		const uchar* i_row[] = { i_data[0] + y * i_step, i_data[1] + y * i_step, i_data[2] + y * i_step };
		uchar* o_row = o_data + y * o_step;

		for (int x = 0; x < cols; x++)	// cyklus pøes pixely v akt. øádku	
		{
			// pøístup k pixelùm
			const uchar* i_pixel[] = { i_row[0] + x * i_chnls, i_row[1] + x * i_chnls, i_row[2] + x * i_chnls };
			uchar* o_pixel = o_row + x * o_chnls;

			// vstupní složky pixelu
			Y  = *i_pixel[0];
			Cb = *i_pixel[1];
			Cr = *i_pixel[2];

			///////////////////////////////////////////////////
			// DOPLNIT - výstupní složky obrazu (YCbCr -> BGR)
			///////////////////////////////////////////////////

			o_pixel[0] = (uchar)MAX(MIN((Y + 1.77200*(Cb - 128)),255),0);
			o_pixel[1] = (uchar)MAX(MIN((Y - 0.34414*(Cb - 128) - 0.71414*(Cr - 128)), 255), 0);
			o_pixel[2] = (uchar)MAX(MIN((Y + 1.40200*(Cr - 128)), 255), 0);



		}
	}
}

int main(int argc, char* argv[]) {

	g_input = imread("lena.jpg"); // pozor na správné umístìní souboru

	// vytvoøení pomocných a výstupních obrazù
	g_temp[0] = Mat(g_input.rows, g_input.cols, CV_8UC1);
	g_temp[1] = Mat(g_input.rows, g_input.cols, CV_8UC1);
	g_temp[2] = Mat(g_input.rows, g_input.cols, CV_8UC1);

	g_output = Mat(g_input.rows, g_input.cols, CV_8UC3);

	// vytvoøení okna pro vstup
	imshow("MPC-MPG cviceni 12 - vstup", g_input);

	///////////////////////////////////////////////////
	// DOPLNIT - transformace tam, zpátky a zobrazení
	///////////////////////////////////////////////////
	There(g_input, g_temp);
	imshow("Y", g_temp[0]);
	imshow("Cb", g_temp[1]);
	imshow("Cr", g_temp[2]);

	BackAgain(g_temp, g_output);
	imshow("vystup", g_output);

	waitKey();	// èekat na uživatele

	return 0;
}