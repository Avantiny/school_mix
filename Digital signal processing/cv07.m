Fsy = 48000; % Vzorkovaci frekvence
len_ms = 20; % Delka nacteneho samplu v ms
[x,Fsx] = audioread('violin.wav'); % Nacteni audio materialu
x = x(Fsx+1:Fsx+(Fsx/(1000/len_ms))); % Nacteni potrebneho poctu vzorku
oversample_fn(x, Fsx, Fsy);

function y = oversample_fn(x, Fsx, Fsy)
    %% urceni cinitelu nadvzorkovani a podvzorkovani
    K = gcd(Fsx, Fsy); % nejvetsi spolecny delitel
    L = Fsy/K; % cinitel nadvzorkovani
    M = Fsx/K; % cinitel podvzorkovani
    %% prevzorkovani
    Nx = length(x);
    Ny = L*Nx;
    Fsy = Fsx*L;
    y = zeros(Ny, 1); %vytvoreni matice nulovych hodnot
    y(1:L:end) = x; %naplneni teto matice
    %% filtrace pomoci dp
    fcr = min((1/L), (1/M)); % ziskani hodnoty mezniho kmitoctu  
    dp = fir1(L*20, fcr, 'low'); %prenosova funkce
    y2 = conv(y, dp); %filtrace signalu
    y2 = y2(ceil((L*20-1)/2)+1:ceil((L*20-1)/2)+Ny);
    y2 = L*y2;    
    %% funkce resample
    yr = resample(x,L,M); % Funkce resample pro porovnani    
    %% podvzorkovani
    Fsy2 = Fsy/M;
    yo = y2(1:M:end);    
    %% vykresleni spekter
    mydft(x, Fsx);
    mydft(yr, Fsy);
    mydft(yo, Fsy2);
    %% vykresleni prubehu signalu
    figure(2)
    subplot(3,1,1)
    plot(x)
    title("Default")
    subplot(3,1,2)
    plot(yr)
    title("Resample")
    subplot(3,1,3)
    plot(yo)
    title("Oversample")
end
