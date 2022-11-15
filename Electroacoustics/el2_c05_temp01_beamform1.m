% Smerova charakteristika ULA beamformeru

el2_c05_beamform1(2, 1, pi, 4000)

% M - pocet mikrofonu
% d - roztec mikrofonu v poli
% alpha - uhel natoceni osy pole v radianech
% f - kmitocet signalu



function el2_c05_beamform1(M, d, alpha, f)
%% nastaveni vychozich hodnot, pokud nejsou zadany
if nargin<1
    M = 9;
    d = 0.1;
    alpha = pi/2;
    f = 1000;
end

%% vypocet smerove funkce
% TODO: vytvoreni vektoru pro uhly azimutu (phi) v radianech
 phi = (0:1:360)/180*pi;
 c0 = 344;

% vypocet r (citlivost pole) pro smery phi podle rovnice (1)
citatel = sin(M.*pi.*f.*d.*(cos(phi) - cos(alpha))./c0);
jmenovatel = M.*sin(pi.*f.*d.*(cos(phi) - cos(alpha))./c0);

 r = abs(citatel./jmenovatel);
% osetreni vysledku deleni nulou ve smeru alpha a zaokrouhlovacich chyb
r(isnan(r))=1;
r(r>1)=1;

%% vykresleni smerove charakteristiky v polarnich souradnicich
figure;
polarplot(phi,r);
grid on;

%% vykresleni smerove charakteristiky v kartezskych souradnicich
figure;
plot(phi,20*log10(r),'LineWidth',2);
grid on;
xlabel('{\it{\theta}}  [°]  \rightarrow')
ylabel('{\it{\eta(\theta,\alpha)}}  [dB]  \rightarrow')
end