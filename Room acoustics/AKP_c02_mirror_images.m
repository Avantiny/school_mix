
% V�po�et 2D zvukov�ho pole bodov�ho zdroje zvuku v uzav�en�m prostoru 
% obrazovou metodou
% 
% function L = AKP_c02_mirror_images(area, step, sourcex, sourcey, f, alpha, R, vs)
%
% area - oblast simulace, area = [xnim xmax ymin ymax]
% step - krok simulace
% sourcex - sou�adnice x zdroje zvuku
% sourcey - sou�adnice y zdroje zvuku
% f - kmito�et sign�lu
% alpha - vektor pohltivost� st�n (skal�r pro stejn� pohltivosti)
% R - polom�r zdroje, v�choz� hodnota 0,1 m
% vs - rychlost kmit�n� povrchu zdroje, v�choz� hodnota 0,01 m/s

area = [-5 5 -4 4];
step = 0.01;
sourcex = -1;
sourcey = 2;
f = 2500;
alpha = [0 0 0 0];

mirror_images(area, step, sourcex, sourcey, f, alpha);

function L = mirror_images(area, step, sourcex, sourcey, f, alpha, R, vs)
    
    beton = [0.36 0.44 0.31 0.29 0.39 0.25];
    okno = [0.3 0.25 0.18 0.12 0.07 0.04];
    sadra = [0.14 0.11 0.06 0.05 0.04 0.03];
    zaves = [0.03 0.04 0.12 0.17 0.24 0.35];
    
    %materialovy vektor
    matV = [beton; okno; sadra; zaves];
    
    freq = [125 250 500 1000 2000 4000];
    
    %% p��prava prom�nn�ch
    for m = 1:length(matV(:,1))
        for i = 1:length(freq)
            if (f < freq(1)*sqrt(2))
                x = matV(m,:);
                alpha(m) = x(1);
            end
            if (f > freq(length(freq)-1)*sqrt(2))
                x = matV(m,:);
                alpha(m) = x(length(matV(m,:)));
            end
            if (f > freq(i)/sqrt(2))
                %pojistka proti out of bounds
                if i ~= length(freq)
                    if (f < freq(i+1)/sqrt(2))
                        x = matV(m,:);
                        alpha(m) = x(i);
                    end
                end
            end
        end
    end
    
    if ~exist('R','var'), R = 0.1; end
    if ~exist('vs','var'), vs = 0.01; end
    
    % pro testovani bez uvazovani ruzneho kmitoctu a materialu
    % alpha = [0 0 0 0];
    
    % rychlost ���en� zvuku
    c0 = 344;
    
    % vlnov� ��slo
    k = 2*pi*f/c0;
    
    % amplituda kmit�n� bodov�ho zdroje
    A0 = -vs.*(R.^2)./(1+j*k*R).*exp(-j*k*R); 
    A = A0;
    
    %% TODO: V�PO�ET POLOH ZRCADLOV�CH ZDROJ�
    
    if exist('alpha','var') % zrcadlov� zdroje se po��taj� pouze kdy� je zad�na prom�nn� alpha
        if length(alpha)==1 % pokud je d�lka aplha =1, bere se stejn� hodnota pro v�echny st�ny
            alpha = alpha .* ones(1,4);
        end
        % TODO: v�po�et sou�adnic zrcadlov�ch zdroj� a dopln�n� do vektoru sourcex a sourcey
        sourcex(1) = sourcex;
        sourcey(1) = sourcey;
%         for i = 1:length(area)
%              sourcex(i+1) = sourcex(1) + area(i);
%              sourcey(i+1) = sourcey(1) + area(i);
%         end
        sourcex(2) = sourcex(1) + 2*(area(1) - sourcex(1));
        sourcex(3) = sourcex(1) + 2*(area(2) - sourcex(1));
        sourcex(4) = sourcex(1);
        sourcex(5) = sourcex(1);

        sourcey(2) = sourcey(1);
        sourcey(3) = sourcey(1);
        sourcey(4) = sourcey(1) + 2*(area(3) - sourcey(1));
        sourcey(5) = sourcey(1) + 2*(area(4) - sourcey(1));

        % TODO: v�po�et amplitud zrcadlov�ch zdroj� podle koeficient� pohltivosti a dopln�n� do vektoru A
        A(1) = A0;
         for i = 1:length(alpha)
             A(i+1) = A0*sqrt(1-alpha(i));
         end
    end
    
    %% v�po�et rychlostn�ho potenci�lu
    % osa x a y oblasti simulace
    x=(area(1):step:area(2));
    y=(area(3):step:area(4));
    
    % p��prava pole pro v�sledn� rychlostn� potenci�l v�ech zdroj�
    % x ~ sloupce matice, y ~ ��dky matice
    Phi = zeros(length(y),length(x));
    
    for o = 1:length(sourcex)
        % z vektoru x a y je nutn� repetic� vytvo�it matice
        xx = repmat(x,length(y),1); % vznikne matice, kde hodnota x je stejn� v cel�m sloupci
        yy = repmat(y',1,length(x)); % vznikne matice, kde hodnota y je stejn� v cel�m ��dku
        
        [~, r] = cart2pol(xx-sourcex(o), yy-sourcey(o)); % r je matice
                
        % zamezen� d�len� nulou v sou�adnici zdroje
        r(r<step) = step; % {r<step) vr�t� v�echny indexy matice r, na kter�ch jsou hodnoty < step
    
        % rychlostn� potenci�l o-t�ho zdroje v bod� x(m),y(n)
        Phio = A(o).*exp(-1i.*k.*r)./r; 
                
        % celkov� rychlostn� potenci�l (sou�et potenci�lu jednotliv�ch zdroj�)
        Phi = Phi + Phio;
    end
    
    %% v�po�et akustick�ho tlaku z rychlostn�ho potenci�lu
    p = -j*2*-pi*f*Phi;
    
    % v�po�et hladiny akustick�ho tlaku
    L = 20*log10(abs(p)/2e-5);
    % omezen� spodn� hranice na pr�h sly�en�
    L(L<0) = 0;
    
    % vykreslen� pole
    figure;
    imagesc(x,y,L);
    colormap(jet);
    axis image;
    axis xy;
    colorbar;
    xlabel('{\itx} [m] \rightarrow');
    ylabel('{\ity} [m] \rightarrow');
    title('hladina akustickeho tlaku [dB_{SPL}]');

    figure;
    mx = round(max(max(L)),-1);
    contour(x,y,L,(mx-60):3:mx);
    colormap(jet);
    axis image;
    axis xy;
    colorbar;
    xlabel('{\itx} [m] \rightarrow');
    ylabel('{\ity} [m] \rightarrow');
    title('hladina akustickeho tlaku [dB_{SPL}]');

end
