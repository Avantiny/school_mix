
% [RT, EDT] = AKP_c03_RT(fs,h)
%   RT - vypoètená doba dozvuku
%   EDT - vypoètená poèáteèní doba dozvuku
%   fs - vzorkovací kmitoèet
%   h - impulsová odezva prostoru

RT;

function [T30, EDT] = RT(fs,h)

    % pokud není zadán parametr h, naète se impulsová charakteristika ze souboru
    if ~exist('h','var')
        % zobrazení dialogu pro naètení souboru
        [filename, pathname] = uigetfile( ...
            {'*.wav', 'Zvukove soubory wav';...
            '*.*', 'Vsechny soubory'},...
            'Vyber zvukovy soubor');
        % naètení souboru
        [h, fs] = audioread( fullfile( pathname, filename));
    end
    
    %% výpoèet energie impulsové odezvy a poklesu energie dozvuku
    % èasový vektor
    t = 0:1/fs:(length(h)-1)/fs;
    
    % TODO: výpoèet a vykreslení poklesu energie dozvuku
    Wn = cumsum(h.^2);
    Winf = sum(h.^2);

    EDCR = 1 - Wn/Winf;
    Dt = 10*log10(EDCR);

    plot(t, EDCR);
    hold on;
    plot(t, h);

    Dt1 = find(Dt<-5,1);
    Dt2 = find(Dt<-35,1);
    Dr = Dt(Dt1:Dt2);
    
    tr = 0:1/fs:(length(Dr)-1)/fs;
    p = polyfit(tr,Dr,1);
 
    
    % % výpoèet T30 z prostého rozdílu èasù - mùete pouít pro porovnání s výpoètem z regresní pøímky 
    % % kód pøedpokládá, e normalizovaná køivka dozvukového poklesu v dB je uloena ve vektoru Dt
    % % zjitìní indexu vektoru dozvukového poklesu odpovidající úrovni -5dB a -35dB
    % Dt1ind = find(Dt<-5,1);
    % Dt2ind = find(Dt<-35,1);
    % % výpoèet T30 z rozdílu èasù
    % T30 = 2*(t(Dt2ind)-t(Dt1ind));
    % disp(['T30 = ' num2str(T30) ' s']);
    
    % TODO: výpoèet T30 pomocí regresní pøímk
    T30 = -60/p(1);
    y = p(1)*t;
    figure;
    plot(t, Dt);
    hold on;
    plot(t, y);
    % TODO: vykreslení regresní pøímky
    disp(['T30 = ' num2str(T30) ' s']);
    %% vypocet EDT
    % TODO: výpoèet EDT pomocí regresní pøímky
    Dtedt = find(Dt<-10,1);
    Dredt = Dt(1:Dtedt);
    tredt = 0:1/fs:(length(Dredt)-1)/fs;
    pedt = polyfit(tredt,Dredt,1);
    EDT = -10/pedt(1);
    disp(['EDT = ' num2str(EDT) ' s']);
    %% výpoèet C7, C50 a C80
    % TODO: výpoèet C7, C50 a C80
    C7 = 10*log10(Wn(find(t==0.007))./(Winf - Wn(find(t==0.007)))); 
    C50 = 10*log10(Wn(find(t==0.051)) ./ (Winf - Wn(find(t==0.051)))); 
    C80 = 10*log10(Wn(find(t==0.080)) ./ (Winf - Wn(find(t==0.080))));
    disp(['C7 = ' num2str(C7) ' ']);
    disp(['C50 = ' num2str(C50) ' ']);
    disp(['C80 = ' num2str(C80) ' ']);
    %% výpoèet a vykreslení EDR
    
    % návrh banky filtrù

    % poèet pásem na jednu oktávu
    n = 3;
    % støední kmitoèty se budou ukládat do vektoru Fc
    Fc = [];
    % poèet tøetino-oktávových pásem nad a pod 1 kHz, ve kterých chceme reliéf poèítat
    bands = 3*n; 
    % výpoèet støedních kmitoètù pásem
    G = 10.^(3/10);
    Fref = 1000;
    for x = -bands:bands
        Fc = [Fc Fref.*G.^(x./n)];
    end
    
    % poèet filtrù
    Nfc = length(Fc);
    % navrh filtru
    for k = 1:Nfc
        spec = fdesign.octave(n,'Class 1','N,F0',6,Fc(k),fs);
        edrFilter{k} = design(spec);
    end

    % pøíprava matice pr výsledný EDR, sloupce = kmitoètová pásma
    EDR = zeros(length(h),Nfc);
    % TODO: filtrace impulsové odezvy v jednotlivých pásmech, výsledky ukládejte do matice EDR
    for k = 1:Nfc
        hk = filter(edrFilter{k}, h);
        Wnedr = cumsum(hk.^2);
        Winfedr = sum(hk.^2);
        EDRx = 1 - Wnedr/Winfedr;
        EDR(:,k) = 10*log10(EDRx);
    end
    % vykreslení EDR
    EDR(EDR<-60) = -60;
    td = downsample(t,1000);
    EDRd = downsample(EDR,1000);
    figure1 = figure(4);
    axes1 = axes('Parent',figure1,'XScale','log');
    grid('on');
    hold('all');
    mesh(Fc, td(td<2), EDRd(td<2,:), 'Parent', axes1);
    hold off;
    zlim([-80 20]);
    view([130 40]);
    xlabel('{\itf} [Hz] \rightarrow');
    ylabel('{\itt} [s] \rightarrow');
    zlabel('{\itEDT} [dB] \rightarrow');
    colormap(gray(1));
    title('{\itEDR}');
end