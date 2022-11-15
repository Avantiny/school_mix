#include <stdlib.h>
#include <GL\glut.h>
#include <string>

using namespace std;

#define POCET_RIDICICH_BODU 4
#define STEPS 100

int aktBod = 100;

// Ridici body cele krivky
float ridiciBody[POCET_RIDICICH_BODU][3] = {
	{60,400,0.0},
	{300,300,0.0},
	{150,200,0.0},
	{60,60,0.0}
};

// Ridici body rozdelene krivky – 1. cast (inicializovano na nuly)
float ridiciBodySub1[POCET_RIDICICH_BODU][3] = {
	{0.0,0.0,0.0},
	{0.0,0.0,0.0},
	{0.0,0.0,0.0},
	{0.0,0.0,0.0}
};

// Ridici body rozdelene krivky – 2. cast (inicializovano na nuly)
float ridiciBodySub2[POCET_RIDICICH_BODU][3] = {
	{0.0,0.0,0.0},
	{0.0,0.0,0.0},
	{0.0,0.0,0.0},
	{0.0,0.0,0.0}
};

void vykresliridiciBody(float ridiciBody[POCET_RIDICICH_BODU][3])
{
	// Vykresleni ridicich bodu
	glPointSize(10);
	glBegin(GL_POINTS);
	for (int i = 0; i < POCET_RIDICICH_BODU; i++)
	{
		glVertex2f(ridiciBody[i][0], ridiciBody[i][1]);
	}
	glEnd();

	// Vykresleni ridiciho polygonu
	glLineWidth(1);
	glBegin(GL_LINE_STRIP);
	for (int i = 0; i < POCET_RIDICICH_BODU; i++)
	{
		glVertex2fv(ridiciBody[i]);
	}
	glEnd();
}

void vykreslikrivku(float ridiciBody[POCET_RIDICICH_BODU][3], GLint PRIM)
{
	glEnable(GL_MAP1_VERTEX_3); // povolí použití evaluátoru poèítajícího souøadnice
	glMap1f(GL_MAP1_VERTEX_3, 0, STEPS - 1, 3, 4, ridiciBody[0]); // nastavení øídících bodù a rozsah t

	glBegin(PRIM);
	for (int i = 0; i < STEPS; i++)
	{
		glEvalCoord1f(i); // výpoèet 100 souøadnic vertexù
	}
	glEnd();
	glDisable(GL_MAP1_VERTEX_3);
}

void onReshape(int w, int h)            // event handler pro zmenu velikosti okna
{
	glViewport(0, 0, w, h);             // OpenGL: nastaveni rozmenu viewportu
	glMatrixMode(GL_PROJECTION);        // OpenGL: matice bude typu projekce
	glLoadIdentity();                   // OpenGL: matice bude identicka (jen jednicky v hlavni diagonale)
	glOrtho(0, w, 0, h, -1, 1);         // OpenGL: mapovani abstraktnich souradnic do souradnic okna
}

float nalezeneBody[STEPS][3];
void subdivision(float ridiciBody[POCET_RIDICICH_BODU][3])
{
	// Tato funkce prijima jako vstup ridici body cele krivky (ridiciBody)
	// V ramci funkce spocitejte souradnice ridicich bodu rozdelenych segmentu
	// a ulozte je do promennych ridiciBodySub1 a ridiciBodySub2

	float t = 0.5;

	float P01x, P01y, P12x, P12y, P23x, P23y;
	float P0112x, P0112y, P1223x, P1223y;
	float PCx, PCy;

	//prvni segment
	ridiciBodySub1[0][0] = ridiciBody[0][0];
	ridiciBodySub1[0][1] = ridiciBody[0][1];

	P01x = (1 - t) * ridiciBody[0][0] + t * ridiciBody[1][0];
	P01y = (1 - t) * ridiciBody[0][1] + t * ridiciBody[1][1];

	ridiciBodySub1[1][0] = P01x;
	ridiciBodySub1[1][1] = P01y;

	P12x = (1 - t) * ridiciBody[1][0] + t * ridiciBody[2][0];
	P12y = (1 - t) * ridiciBody[1][1] + t * ridiciBody[2][1];

	P0112x = (1 - t) * P01x + t * P12x;
	P0112y = (1 - t) * P01y + t * P12y;

	ridiciBodySub1[2][0] = P0112x;
	ridiciBodySub1[2][1] = P0112y;

	P23x = (1 - t) * ridiciBody[2][0] + t * ridiciBody[3][0];
	P23y = (1 - t) * ridiciBody[2][1] + t * ridiciBody[3][1];

	P1223x = (1 - t) * P12x + t * P23x;
	P1223y = (1 - t) * P12y + t * P23y;

	PCx = (1 - t) * P0112x + t * P1223x;
	PCy = (1 - t) * P0112y + t * P1223y;

	ridiciBodySub1[3][0] = PCx;
	ridiciBodySub1[3][1] = PCy;

	ridiciBodySub2[0][0] = PCx;
	ridiciBodySub2[0][1] = PCy;

	ridiciBodySub2[1][0] = P1223x;
	ridiciBodySub2[1][1] = P1223y;

	ridiciBodySub2[2][0] = P23x;
	ridiciBodySub2[2][1] = P23y;

	ridiciBodySub2[3][0] = ridiciBody[3][0];
	ridiciBodySub2[3][1] = ridiciBody[3][1];

}


void onDisplay(void)
{
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);

	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// Vykresleni cele krivky
	glColor3f(1, 0, 0);
	glPointSize(2);
	vykreslikrivku(ridiciBody, GL_POINTS);
	glColor3f(1, 1, 0);
	vykresliridiciBody(ridiciBody);

	// Vypocet subdivision
	subdivision(ridiciBody);



	// Vykresleni rozdelene krivky – 1. cast
	glColor4f(1, 0, 1, 0.3);
	glPointSize(4);
	vykreslikrivku(ridiciBodySub1, GL_LINE_STRIP);
	glColor4f(1, 0, 1, 0.7);
	vykresliridiciBody(ridiciBodySub1);




	// Vykresleni rozdelene krivky – 2. cast
	glColor4f(1, 1, 0, 0.3);
	glPointSize(4);
	vykreslikrivku(ridiciBodySub2, GL_LINE_STRIP);
	glColor4f(0, 1, 0, 0.7);
	vykresliridiciBody(ridiciBodySub2);



	glDisable(GL_BLEND);
	glDisable(GL_LINE_SMOOTH);

	glFlush();

	glutSwapBuffers();
}

// Obsluha tlacitek mysi
void onMouse(int button, int state, int mx, int my)
{
	// Posun y souradnice aby byl pocatek vlevo dole
	my = glutGet(GLUT_WINDOW_HEIGHT) - my;

	// Detekce povoleneho pohybu (left button only)
	if (button == GLUT_LEFT_BUTTON)
	{
		if (state == GLUT_UP)
		{
			aktBod = 100;
		}
		else {
			for (int i = 0; i < POCET_RIDICICH_BODU; i++)
			{
				if (abs(ridiciBody[i][0] - mx) < 10 && abs(ridiciBody[i][1] - my) < 10) // drag and drop funguje v okoli 10 px - osetreno abs hodnotou pro + i -
					aktBod = i;
			}
		}
	}
	else
	{
		aktBod = 100;
	}
}

// Obsluha pohybu mysi (aktivniho)
void onMotion(int mx, int my)
{
	// Posun y souradnice aby byl pocatek vlevo dole
	my = glutGet(GLUT_WINDOW_HEIGHT) - my;

	if (aktBod < POCET_RIDICICH_BODU)
	{
		ridiciBody[aktBod][0] = mx;
		ridiciBody[aktBod][1] = my;
	}

	glutPostRedisplay();
}

int main(int argc, char* argv[])
{
	glutInit(&argc, argv);              // inicializace knihovny GLUT

	glutInitDisplayMode(GLUT_DOUBLE);

	glutInitWindowSize(400, 500);       // nastaveni pocatecni velikosti dale oteviranych oken
	glutInitWindowPosition(200, 200);   // nastaveni pocatecniho umisteni dale oteviranych oken

	glutCreateWindow("Subdivision de Casteljau"); // vytvoreni okna
	glutDisplayFunc(onDisplay);         // registrace funkce volane pri prekreslovani aktualniho okna
	glutReshapeFunc(onReshape);         // registrace funkce volane pri zmene velikosti aktualniho okna
	glutMouseFunc(onMouse);
	glutMotionFunc(onMotion);

	glutMainLoop();                     // nekonecna smycka, interakce uz jen pomoci event handleru
	return 0;                           // ukonceni programu
}