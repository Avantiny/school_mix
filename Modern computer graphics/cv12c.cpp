// MPC-MPG cviceni 12
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

using namespace cv;
using namespace std;

#define NAZEV_OKNA	"MPC-MPG cviceni 12"

Mat g_input;	// glob�ln� deklarovan� obraz
Mat g_output;

///////////////////////////////////////////////////////////////////////////////////////////
// Funkce n�sob� 3kan�lov� obraz (RGB) hodnotou od 0 do 1 a ukl�d� jej do druh�ho, p�edem 
// alokovan�ho obrazu 
///////////////////////////////////////////////////////////////////////////////////////////
void BasicLoop(const Mat &in, Mat &out, float value)
{
	int cols  = in.cols;		// po�et sloupc� (���ka obrazu)
	int rows  = in.rows;		// po�et ��dk� (v��ka obrazu)
	int chnls = in.channels();  // po�et barevn�ch kan�l�
	int step  = in.step;		// vzd�lenost mezi ��dky

	// z�sk�n� ukazatel� na obrazov� data
	const uchar* ptr_in = in.data;
	uchar* ptr_out = out.data;

	// x, y jsou sou�adnice pixelu
	for (int y = 0; y < rows; y++)
	{
		// z�sk�n� ukazatel� na prvn� pixel v ��dku y
		const uchar* ptr_in_row = ptr_in + y*step;
		uchar* ptr_out_row = ptr_out + y*step;

		for (int x = 0; x < cols; x++)
		{
			// p��stup k pixel�m
			const uchar* pixel_in = ptr_in_row + x * chnls;
			uchar* pixel_out = ptr_out_row + x * chnls;


			// �prava p�es v�echny barevn� kan�ly obrazu
			pixel_out[0] = pixel_in[0] * value;
			pixel_out[1] = pixel_in[1] * value;
			pixel_out[2] = pixel_in[2] * value;

		}
	}

	// p�ekreslen� okna
	imshow(NAZEV_OKNA, out);

}


void onChange(int pozice, void* userdata = 0)
{
	float poziceFloat = (float)pozice;
	BasicLoop(g_input, g_output, poziceFloat/100);


		
}

int main(int argc, char* argv[])
{
	g_input = imread("lena.jpg"); // pozor na spr�vn� um�st�n� souboru

	int cols = g_input.cols;			// po�et sloupc� (���ka obrazu)
	int rows = g_input.rows;			// po�et ��dk� (v��ka obrazu) 
	int type = g_input.type();			// datov� typ
	int chnls = g_input.channels();		// po�et barevn�ch kan�l�
	int step = g_input.step;			// d�lka jednoho ��dku

	namedWindow(NAZEV_OKNA);			// vytvo�en� okna s n�zvem NAZEV_OKNA
	imshow(NAZEV_OKNA, g_input);		// zobrazen� obrazu do okna NAZEV_OKNA

	// inicializace g_output pomoc� konstruktoru Mat
	g_output = Mat(rows, cols, type);
		
	int value = 100;

	// vytvoreni posuvniku:
	createTrackbar("posuvnik", NAZEV_OKNA, &value, 100, onChange);

	waitKey();						// �ekej na stisknut� kl�vesy v okn�
	destroyWindow(NAZEV_OKNA);		// uvoln�n� okna
	
	return 0;
}
