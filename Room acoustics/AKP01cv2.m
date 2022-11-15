%A me nezajima, z slozka taky ne

oom(3,2,6,6)

function f = oom(nx,ny,lx,ly)

x = 0:0.01:lx;
y = 0:0.01:ly;

for i = 1:length(x)
    for j = 1:length(y)
        P(i,j) = (cos(nx*pi*x(i)/lx))*(cos(ny*pi*y(j)/ly));
    end
end

figure(1);
mesh(x,y,P);

figure(2);
imagesc(x,y,P');

end


