clear all, clc;

% zdroj dat:  https://www.czso.cz/csu/czso/otevrena_data_pro_vysledky_scitani_lidu_domu_a_bytu_2011_sldb_2011
T=readtable('sp.csv');
save('datas.mat','T');
datas = load('datas.mat').T;
data = diff(table2array(datas(2,400:500)));

%% 

% AR MODEL:
% reprezentace znamych dat jako AR procesu
M = 80; % pocet referencnich bodu
R = size(data,2) - M; % vypocet poctu bodu, ktere se budou odhadovat

znama_data = (data(1,1:M))';

predikceAR10 = pred(10, znama_data, R, M);
predikceAR50 = pred(50, znama_data, R, M);
predikceAR80 = pred(80, znama_data, R, M);

%% vykreslovani dat
% vykresleni prubehu
figure
hold on

plot(data)
plot(predikceAR10)
plot(predikceAR50)
plot(predikceAR80)

legend('Realna', '2. rad', '10. rad', '80. rad');

%%  funkce
function predikceX = pred(rad, znama_data, R, M)
a = aryule(znama_data, rad);
predikceX = [znama_data; zeros(R, 1)];
    for n = M+1:M+R   
        for i = 1:rad
            predikceX(n) = predikceX(n) - a(i+1)*predikceX(n-i);
        end   
    end
end












