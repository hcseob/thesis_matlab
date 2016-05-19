function gdc = calcgdc(f, x, y, N)
if nargin < 4; N = 3; end;
dx = diff(x(1:2));
dy = diff(y(1:2));

center = (size(f) + 1)/2;
gdc=nan(N+1, N+1);
for j=1:N+1
    for k=1:N+1
        gdc(j,k)=deriv2(f, dx, dy, center, j-1, k-1) ...
                 /factorial(j-1)/factorial(k-1);
    end
end
end

function d = deriv2(z,dx,dy,xy,ordx,ordy)
if ordy==0
    cvy=[1];
    indy=[0];
else
    cvy=[1,-1];
    for k = 1:ordy-1
        cvy=conv(cvy,[1,-1]);
    end
    if mod(ordy,2)==0
        indy=[ordy/2:-1:-ordy/2];
    else
        indy=[ordy:-2:-ordy];
    end
end
d=0; m=1;
for k=xy(2)+indy
    if ordx==0
        d=d+cvy(m)*z(k,xy(1));
    else
        d=d+cvy(m)*deriv(z(k,:),dx,xy(1),ordx);
    end
    m=m+1;
end
d=d/(dy*(2^mod(ordy,2)))^ordy;
end

function d = deriv(y,dx,n,order)
if size(y,1)>size(y,2)
    y=transpose(y);
end
cv=[1,-1];
for k = 1:order-1
    cv=conv(cv,[1,-1]);
end
if mod(order,2)==0
    d=sum(y(n+[order/2:-1:-order/2]).*cv)/dx^order;
else
    d=sum(y(n+[order:-2:-order]).*cv)/(2*dx)^order;
end
end