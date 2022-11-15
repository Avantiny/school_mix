%rad - urcen poctem polu
%stabilita - poly lezi v jednotkove kruznici
%kauzalita - polu je stejne nebo vice nez NB
% FIR/IIR - pokud jsou vsechny poly v nule, pak FIR, jinak IIR

% 1. system
%3. rad, FIR, kauzalni, stabilni
a1 = [1 2 3 4];
b1 = [1 0 0 0];
h1 = impz(a1,b1);
H1 = tf(a1,b1,-1);
figure;
freqz(a1,b1)
subplot(2,1,2)
zplane(a1,b1)

% 2. system
%3. rad, FIR, kauzalni, stabilni
h2 = [1 -2 3 -4];
a2 = h2;
b2 = b1;
H2 = tf(a2,b2,-1);
figure;
freqz(a2,b2)
subplot(2,1,2)
zplane(a2,b2)

% 3. system
%1. rad, IIR, kauzalni, stabilni
z = tf('z');
H3 = ((1/2)+((z^-1)/2))/(1-((z^-1)/4));
[a3,b3] = tfdata(H3, 'v');
figure;
freqz(a3,b3)
subplot(2,1,2)
zplane(a3,b3)

% 4. system
%3. rad, FIR, kauzalni, stabilni
H4 = 1+(3/4)*z^(-1)+(2/4)*z^(-2)+(1/4)*z^(-3);
[a4,b4] = tfdata(H4, 'v');
figure;
freqz(a4,b4)
subplot(2,1,2)
zplane(a4,b4)

% 5. system
%4. rad, IIR, kauzalni, stabilni
H5 = series(H1, H3);
[a5,b5] = tfdata(H5, 'v');
figure;
freqz(a5,b5)
subplot(2,1,2)
zplane(a5,b5)

% 6. system
%4. rad, IIR, kauzalni, stabilni
H6 = parallel(H5, H2);
[a6,b6] = tfdata(H6, 'v');
figure;
freqz(a6,b6)
subplot(2,1,2)
zplane(a6,b6)

% 7. system
%7. rad, IIR, kauzalni, stabilni
H7 = series(H6, H4);
[a7,b7] = tfdata(H7, 'v');
figure;
freqz(a7,b7)
subplot(2,1,2)
zplane(a7,b7)

%Jaky je rozdil mezi systemem 1 a 2?
%   Co dela operace (-1)^n?
%       obraci znamenko u kazdeho sudeho clenu v citateli
%   Jak se to projevilo na kmitoctove charakteristice a nulovych bodech a polech?
%       Nulove body a poly jsou prevraceny pres imaginarni osu
%       Kmitoctova char-ka je otocena (Z DP na HP)
% Kombinace
%   Jak se projevuje seriova kombinace systemu z pohledu nulovych bodu a polu?
%       System obsahuje poly a NB z obou vstupnich systemu
%   Jak se projevuje paralelni kombinace systemu z pohledu nulovych bodu a polu?
%       Pocet i poloha jednotlivych poly a NB se zmenila
%   Jak se projevuje seriova kombinace z pohledu kmitoctove charakteristiky?
%       Vykazuje dle ocekavani (vzhledem k tomu, ze jde o jejich nasobeni) charakter obou dvou systemu, ktere jsou kombinovany
%   Jak se projevuje paralelni kombinace z pohledu kmitoctove
%       Vykazuje dle ocekavani (vzhledem k tomu, ze jde o jejich soucet) charakter obou dvou systemu, ktere jsou kombinovany