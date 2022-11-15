
% Výpoèet 2D zvukového pole bodového zdroje zvuku v uzavøeném prostoru 
% obrazovou metodou
% 
% function L = AKP_c02_mirror_images(area, step, sourcex, sourcey, f, alpha, R, vs)
%
% area - oblast simulace, area = [xnim xmax ymin ymax]
% step - krok simulace
% sourcex - souøadnice x zdroje zvuku
% sourcey - souøadnice y zdroje zvuku
% f - kmitoèet signálu
% alpha - vektor pohltivostí stìn (skalár pro stejné pohltivosti)
% R - polomìr zdroje, výchozí hodnota 0,1 m
% vs - rychlost kmitání povrchu zdroje, výchozí hodnota 0,01 m/s

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
    
    %% pøíprava promìnných
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
    
    % rychlost šíøení zvuku
    c0 = 344;
    
    % vlnové èíslo
    k = 2*pi*f/c0;
    
    % amplituda kmitání bodového zdroje
    A0 = -vs.*(R.^2)./(1+j*k*R).*exp(-j*k*R); 
    A = A0;
    
    %% TODO: VÝPOÈET POLOH ZRCADLOVÝCH ZDROJÙ
    
    if exist('alpha','var') % zrcadlové zdroje se poèítají pouze když je zadána promìnná alpha
        if length(alpha)==1 % pokud je délka aplha =1, bere se stejná hodnota pro všechny stìny
            alpha = alpha .* ones(1,4);
        end
        % TODO: výpoèet souøadnic zrcadlových zdrojù a doplnìní do vektoru sourcex a sourcey
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

        % TODO: výpoèet amplitud zrcadlových zdrojù podle koeficientù pohltivosti a doplnìní do vektoru A
        A(1) = A0;
         for i = 1:length(alpha)
             A(i+1) = A0*sqrt(1-alpha(i));
         end
    end
    
    %% výpoèet rychlostního potenciálu
    % osa x a y oblasti simulace
    x=(area(1):step:area(2));
    y=(area(3):step:area(4));
    
    % pøíprava pole pro výsledný rychlostní potenciál všech zdrojù
    % x ~ sloupce matice, y ~ øádky matice
    Phi = zeros(length(y),length(x));
    
    for o = 1:length(sourcex)
        % z vektoru x a y je nutné repeticí vytvoøit matice
        xx = repmat(x,length(y),1); % vznikne matice, kde hodnota x je stejná v celém sloupci
        yy = repmat(y',1,length(x)); % vznikne matice, kde hodnota y je stejná v celém øádku
        
        [~, r] = cart2pol(xx-sourcex(o), yy-sourcey(o)); % r je matice
                
        % zamezení dìlení nulou v souøadnici zdroje
        r(r<step) = step; % {r<step) vrátí všechny indexy matice r, na kterých jsou hodnoty < step
    
        % rychlostní potenciál o-tého zdroje v bodì x(m),y(n)
        Phio = A(o).*exp(-1i.*k.*r)./r; 
                
        % celkový rychlostní potenciál (souèet potenciálu jednotlivých zdrojù)
        Phi = Phi + Phio;
    end
    
    %% výpoèet akustického tlaku z rychlostního potenciálu
    p = -j*2*-pi*f*Phi;
    
    % výpoèet hladiny akustického tlaku
    L = 20*log10(abs(p)/2e-5);
    % omezení spodní hranice na práh slyšení
    L(L<0) = 0;
    
    % vykreslení pole
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
