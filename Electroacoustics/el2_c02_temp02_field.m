% Vypocet 2D zvukoveho pole bodoveho zdroje
% 
%L = el2_c02_field(area, step, sourcex, sourcey, R, f, vs);
%
% area - oblast simulace, area = [xmin xmax ymin ymax]
% step - krok simulace
% sourcex - souradnice x zdroje
% sourcey - souradnice y zdroje
% R - polomer zdroje
% f - kmitocet signalu
% vs - rychlost kmitani povrchu zarice

L = el2_c02_field([0 6 0 4], 0.01, 3, 2, 0.1, 1000, 0.01);
function L = el2_c02_field(area, step, sourcex, sourcey, R, f, vs)

% osa x a y oblasti simulace
x=(area(1):step:area(2));
y=(area(3):step:area(4));

% priprava pole pro vysledny rychlostni potencial
% x ~ sloupce matice, y ~ radky matice
Phi = zeros(length(y),length(x));

% rychlost sireni zvuku
c0 = 344;

% vypocet promenne k obsahujici vlnove cislo pro zadany kmitocet
k = 2*pi*f/c0; 

% TODO: vypocet promenne A obsahujici amplitudu kmitani zdroje podle
% rovnice (6)
A = -vs*(R^2./(1+1i*k*R)).*exp(1)^(-1i*k*R);

%% TODO: vypocet rozlozeni rychlostniho potencialu v prostoru

% 1) vytvoreni cyklu for pro souradnici x
 for n = 1:length(x)

% 2) vytvoreni cyklu for pro souradnici y
    for m = 1:length(y)

% 3) vypocet vzdalenosti r a uhlu phi mezi aktualnim bodem a pozici zdroje
       [phi, r] = cart2pol(x(n)-sourcex,y(m)-sourcey);

        % pozn.: moznosti zamezeni deleni nulou v souradnici zdroje: 
        if(r < step), r = step; end 
        % NEBO 
        % r(r<step) = step;

% 4) vypocet rychlostniho potencialu pro bod x(n),y(m) podle rovnice (4),
%    ulozeni vysledku do pripravene matice Phi
       Phi(m,n) = (A/r)*exp(1)^(-1i*k*r);

% konec smycek
    end
 end

%% TODO: po skonceni smycky vypocet akustickeho tlaku z rychlostniho potencialu 
% podle rovnice (5), ulozeni vysledku do promenne p 
% (Phi je matice => p bude take matice)
p0 = 1.205;
p = -1i*p0*k*c0*Phi;

% vypocet hladiny akustickeho tlaku
L = 20*log10(abs(p)/2e-5);
% omezeni spodni hranice na prah slyseni
L(L<0) = 0;

% vykresleni pole
figure;
imagesc(x,y,L);
colormap(jet);
axis image;
axis xy;
colorbar;
xlabel('{\itx} [m] \rightarrow');
ylabel('{\ity} [m] \rightarrow');
title('hladina akustickeho tlaku [dB_{SPL}]');
end