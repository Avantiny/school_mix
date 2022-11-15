// MPC-MPG cviceni 12
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

using namespace cv;
using namespace std;

#define NAZEV_OKNA	"MPC-MPG cviceni 12"

Mat g_input;	// globálnì deklarovaný obraz
Mat g_output;

///////////////////////////////////////////////////////////////////////////////////////////
// Funkce násobí 3kanálový obraz (RGB) hodnotou od 0 do 1 a ukládá jej do druhého, pøedem 
// alokovaného obrazu 
///////////////////////////////////////////////////////////////////////////////////////////
void BasicLoop(const Mat &in, Mat &out, float value)
{
	int cols  = in.cols;		// poèet sloupcù (šíøka obrazu)
	int rows  = in.rows;		// poèet øádkù (výška obrazu)
	int chnls = in.channels();  // poèet barevných kanálù
	int step  = in.step;		// vzdálenost mezi øádky

	// získání ukazatelù na obrazová data
	const uchar* ptr_in = in.data;
	uchar* ptr_out = out.data;

	// x, y jsou souøadnice pixelu
	for (int y = 0; y < rows; y++)
	{
		// získání ukazatelù na první pixel v øádku y
		const uchar* ptr_in_row = ptr_in + y*step;
		uchar* ptr_out_row = ptr_out + y*step;

		for (int x = 0; x < cols; x++)
		{
			// pøístup k pixelùm
			const uchar* pixel_in = ptr_in_row + x * chnls;
			uchar* pixel_out = ptr_out_row + x * chnls;


			// úprava pøes všechny barevné kanály obrazu
			pixel_out[0] = pixel_in[0] * value;
			pixel_out[1] = pixel_in[1] * value;
			pixel_out[2] = pixel_in[2] * value;

		}
	}

	// pøekreslení okna
	imshow(NAZEV_OKNA, out);

}


void onChange(int pozice, void* userdata = 0)
{
	float poziceFloat = (float)pozice;
	BasicLoop(g_input, g_output, poziceFloat/100);


		
}

int main(int argc, char* argv[])
{
	g_input = imread("lena.jpg"); // pozor na správné umístìní souboru

	int cols = g_input.cols;			// poèet sloupcù (šíøka obrazu)
	int rows = g_input.rows;			// poèet øádkù (výška obrazu) 
	int type = g_input.type();			// datový typ
	int chnls = g_input.channels();		// poèet barevných kanálù
	int step = g_input.step;			// délka jednoho øádku

	namedWindow(NAZEV_OKNA);			// vytvoøení okna s názvem NAZEV_OKNA
	imshow(NAZEV_OKNA, g_input);		// zobrazení obrazu do okna NAZEV_OKNA

	// inicializace g_output pomocí konstruktoru Mat
	g_output = Mat(rows, cols, type);
		
	int value = 100;

	// vytvoreni posuvniku:
	createTrackbar("posuvnik", NAZEV_OKNA, &value, 100, onChange);

	waitKey();						// èekej na stisknutí klávesy v oknì
	destroyWindow(NAZEV_OKNA);		// uvolnìní okna
	
	return 0;
}
