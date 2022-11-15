f = [100 1000 10000 20000];
el2_c02_source(f);

function el2_c02_source(f)
%
% el2_c02_graf(order)
%
% f - vektor kmitoctu
% priprava pole retezcu pro legendu grafu
desc = cell(length(f),1);

%% TODO: vytvorit vektor uhlu pro vypocet smerove charakteristiky
% ulozeni do promenne phi
phi = linspace(0, 2*pi, 361);

% vypocitat citlivost pro vsechny uhly podle vzorecku 3

% %% TODO: vypocitat smerovou chrakteristiku pro vsechny prvky vektoru order
 for m = 1:length(f)
%     % vytvoreni matice eta kde v kazdem radku bude smerova charakteristika
%     % pro rad order(m)
%
%      eta(m,:) = 2 * besselh(1, 
c0 = 344;
k = 2.*pi.*f(m)./c0;
R = 0.1;
arg = k.*R.*sin(phi);
eta(m,:) = abs(2.*besselj(1,arg)./arg);
% 
%     % priprava textu pro legendu grafu
     desc{m} = strcat(num2str(f(m)),'Hz'); 
 end

%% vykresleni grafu
figure();

% TODO: vykreslit polarni graf
polarplot(phi, eta);

% % zobrazeni legendy grafu
 legend(desc);

end
