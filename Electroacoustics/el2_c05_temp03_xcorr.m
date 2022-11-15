% Nalezeni smeru prichazejiciho zvuku pomoci krizove korelace
 
alpha = el2_c05_xcorr();

% d - roztec mikrofonu
% fs - vzorkovaci kmitocet
% y - matice signalu dopadajicich na mikrofony pole (sloupce = signaly mikrofonu)
% alpha - zjisteny smer prichazejiciho zvuku


function alpha = el2_c05_xcorr(d,fs,y)
%% nastaveni vychozich hodnot, pokud nejsou zadany
if nargin<1
    d = 0.1;
end
% vygenerovani signalu mikrofonu, pokud neni zadano y
if ~exist('y','var') || isempty(y)
    alpha = pi/8;
    [y, fs] = gen_mic_signals(2,d,alpha,0,[],[],zeros(1000,1));
end

%% vypocet smeru prichazejiciho zvuku
% TODO: vypocet krizove korelace signalu mikrofonu, ulozeni do vektoru r a lags
 [r, lags] = xcorr(y(:,1), y(:,2), 'coeff');

% TODO: nalezeni indexu maxima krizove korelace a vzdalenosti maxima od stredu 
% vektoru krizove korelace
[~, mri] = max(r);
% TODO: vypocet zpozdeni signalu mezi mikrofony podle rovnice (7)
dt = mri - length(r)/2;
% TODO: nalezeni smeru prichazejiciho zvuku podle rovnice (6), uloení do promìnné angle
dl = cot(alpha)*d;
angle = acos(dl/d);

%% vykresleni krizove korelace
figure();
subplot(1,2,1);
plot(lags,r,'k');
grid on;
xlabel('{\itn} \rightarrow');
ylabel('{\itR_{xy}}({\itn}) \rightarrow');subplot(1,2,2);
plot(lags,r,'k','LineWidth',2);
hold on;
xlabel('{\itn} \rightarrow');
ylabel('{\itR_{xy}}({\itn}) \rightarrow');subplot(1,2,2);

%% vykresleni maxima a stredu
[~,mri] = max(r);
Dn = mri - round(length(r)/2);
plot([Dn Dn],[min(r) 1.1*max(r)],'r','LineWidth',2);
plot([0 0],[min(r) 1.1*max(r)],'b','LineWidth',2);
hold off;
grid on;
Dn = max(Dn,3);
xlim([-20*Dn 20*Dn]);
ylim([min(r) 1.1*max(r)]);

%% vykresleni smeru
figure();
x = cos(alpha);
y = sin(alpha);
compass(x,y);
end
