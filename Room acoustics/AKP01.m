% Vytvořte funkci, která pro zadané rozměry místnosti vypočítá kmitočty 
% módů do zadaného řádu a vykreslí je pomocí funkce stem, dále vypočítá a 
% zobrazí jejich vzdálenost, hustotu a celkový počet módů do zadaného kmitočtu.

oom(5.7,4.2,3,5)

function f = oom(x,y,z,nxyz)

c0 = 331.8;

nl = 1:nxyz;

it = 1;
for i = 1:nxyz
    for j = 1:nxyz
        for k = 1:nxyz
            f(it) = (c0/2)*sqrt(((nl(i))/x)^2+((nl(j))/y)^2+((nl(k))/z)^2);
            it = it + 1;
        end
    end
end


stem(f,ones(size(f)))

V = x*y*z;
S = 2*x*y + 2*x*z + 2*y*z;
L = 4*x + 4*y + 4*z;

f = 0:1000;
%f = sort(f);

for i = 1:length(f)
    N(i) = (((4*pi*V)/(3*c0^3))*(f(i)^3))+((pi*S)/(4*(c0^2)))*(f(i)^2) + L/(8*c0)*f(i);
end

for i = 1:length(f)
    n(i) = ((4*pi*V/(c0^3))*(f(i)^2))+(pi*S/(2*(c0^2)))*f(i) + L/(8*c0);
end

for i = 1:length(f)
    df(i) = 1/n(i);
end

figure
plot(N)

figure
plot(n)

figure
plot(df)


end
