% Vypocet vystupniho signalu ULA beamformeru

el2_c05_beamform2();

% M - pocet mikrofonu
% d - roztec mikrofonu v poli
% alpha - natoceni osy hlavniho laloku
% fs - vzorkovaci kmitocet
% y - matice signalu dopadajicich na mikrofony pole (sloupce = signaly mikrofonu)
% p - vektor vystupniho signalu beamformeru

function p = el2_c05_beamform2(M, d, alpha, fs, y)
%% nastaveni vychozich hodnot, pokud nejsou zadany
if nargin<1
    M = 9;
    d = 0.1;
    alpha = pi/4;
end
% pokud neni zadan vstupni signal, je vygenerovan funkci el2_gen_mic_signals
if nargin<4
   [y, fs] = gen_mic_signals(M, d, alpha); 
end

%% 1) synchronizace signalu mikrofonu
% rychlost zvuku
c0 = 344;
% priprava pole pro casove kompenzovany signal mikrofonu
ya = zeros(length(y),M);

% TODO: vytvoreni vektoru m s indexy mikrofonu
m = ceil((M-1)/2):-1:-floor((M-1)/2);
    
% cyklus pro signaly jednotlivych mikrofonu (sloupce matice mics)
for n = 1:M
    % TODO: vypocet zpozdeni k m-temu mikrofonu podle rovnice (3)
    tau = m(n).*(d.*cos(alpha))./c0;
    % TODO: vypocet poctu vzorku zpozdeni
    numofsamples = floor(tau * fs);
    % TODO: kompenzace zpozdeni m-teho mikrofonu podle rovnice (4)
    if numofsamples < 0
        yan(:,n) = shiftdn(y(:,n), numofsamples);
    elseif numofsamples > 0
        yan(:,n) = shiftup(y(:,n), numofsamples);
    else %numofsamples==0
        yan(:,n) = y(:,n);
    end
    % zkopirováni synchronizovaneho signalu do matice ya
     ya(:,n) = yan(:,n);
end

%% 2) soucet synchronizovanych signalu mikrofonu
% TODO: soucet matice ya po radcich podle rovnice (5), 
% ulozeni do promenne p
 p = 1/M .* sum(ya,2);

%% zapis vystupniho signalu do souboru
audiowrite(['mics_sum_' num2str(alpha/pi) 'pi.wav'],p,fs);

clear p;

end