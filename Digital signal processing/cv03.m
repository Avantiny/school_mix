close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Zde doplnit vstupn� parametry %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fvz = 10000;
fm = 350;
fft_N = 2048;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Zde zavolat funkci dp a hp %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% v�stupn� parametry funkce dp a hp by m�ly b�t dva � vektor koeficient� �itatele (Hc) 
% a vektor koeficient� jmenovatele (Hj), vstupem budou fm a fvz

% uvnit� t�chto funkc� je pot�eba ur�it zes�len� g podle zadan�ho fm a fvz a ur�it vektor koef. �itatele a jmenovatele
% vyu�ijte funkci parallel (paraleln� spojen�); p��m� cesta (nebo dop�edn� vazba) bez zes�len�/zeslaben� 
% a ��dn� jin� funkce (nebo zpo�d�n�) m� hodnotu 1

[Hcdp, Hjdp] = dp(fm, fvz);
[Hchp, Hjhp] = hp(fm, fvz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Zde vypo��tat frekven�n� charakteristiku %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% funkce freq (bude vol�na jednou pro ka�d� filtr), v�stupem je H1 (a H2) a f
[H1, f] = freqz(Hcdp, Hjdp, fft_N, fvz);
[H2, f] = freqz(Hchp, Hjhp, fft_N, fvz);

%%%%%%%%%%%%%%%%%%%
%%% Vykreslen� %%%%
%%%%%%%%%%%%%%%%%%%
% prostudujte, jak je zaobrazen� zad�no a p�izp�sobte tomu vol�n� funkc� v p�edchoz�m kroku
% u modulov�ho spektra p�idejte v grafu "tick", kter� bude roven -3 dB, a� je rozli�eno propustn� a nepropustn� p�smo 
% (nen� t�m my�lena �prava v grafick�m okn�, ale ji� samotn� vol�n� grafu)

subplot(2,1,1)
semilogx(f, 20*log10(abs(H1)), 'g');
hold on
semilogx(f, 20*log10(abs(H2)), 'b');


subplot(2,1,2)
semilogx(f, unwrap(angle(H1))/pi, 'g'); % angle norm�ln� ode��t� sud� n�sobky pi, proto unwrap (rozbalen� f�ze)
hold on
semilogx(f, unwrap(angle(H2))/pi, 'b');


subplot(2,1,1)
set(gca, 'xlim', [20 fvz/2])
set(gca, 'ylim', [-15 0])
title('\bfModulova kmitoctova charakteristika');
yticks(-3);
xlabel('{{\itf}} (Hz) \rightarrow')
ylabel('Modul (dB) \rightarrow')
legend('{\it\bfH}_D_P ({\itf})', '{\it\bfH}_H_P ({\itf})')
grid on

subplot(2,1,2)
set(gca, 'xlim', [20 fvz/2])
title('\bfFazova kmitoctova charakteristika');
xlabel('{{\itf}} (Hz) \rightarrow')
ylabel('Faze (\pirad) \rightarrow')
legend('{\it\bfH}_D_P ({\itf})', '{\it\bfH}_H_P ({\itf})')
grid on

function [Hc, Hj] = hp(fm, fvz) 

g = (tan(pi * fm/fvz) - 1) / (tan(pi * fm/fvz) + 1);

Hb = [g 1]; 
Ha = fliplr(Hb);

[Hc, Hj] = parallel(-Hb, Ha, 1, 1); 

Hc = 0.5*Hc; %jinak nesedi do grafu

end

function [Hc, Hj] = dp(fm, fvz) 

g = (tan(pi * fm/fvz) - 1) / (tan(pi * fm/fvz) + 1);

Hb = [g 1]; %vektor koeficientu
Ha = fliplr(Hb);

[Hc, Hj] = parallel(Hb, Ha, 1, 1);
Hc = 0.5*Hc; %jinak nesedi do grafu

end