N = 1024;
f0 = 1;
T = 1/f0;
t = (0:N-1)'/N*T;
A1 = 10e-3;
A2 = 10e-3;
M = 20;
vi = A1*cos(2*pi*f0*t);
vo = A2*cos(2*pi*M*f0*t);
g = randn(4);

io = zeros(N, 1);
for j = 1:4
    for k = 1:4
        io = io + g(j, k)*vi.^(j-1).*vo.^(k-1);
    end
end

IO = fft(io)/(N);

g10 = sign(g(2, 1))*abs(IO(1+1))/(A1/2);
g01 = sign(g(1, 2))*abs(IO(M+1))/(A2/2);

disp([g10/g(2, 1), g01/g(1, 2)])

a1 = IO(1+1)/g10;
a2 = IO(M+1)/g01;

g30 = IO(3+1)/a1^3;
g21 = IO(2+1*M+1)/a1^2/a2;


%%
gtrans_fft = calcgtrans_fft(io, vi, vo);
gtrans_lms = calcgtrans_lms(io, vi, vo);

gtrans_fft./g
gtrans_lms./g


%%
dvi = 1e-3;
dvo = 1e-3;
vi_dc = (-7:7)*dvi;
vo_dc = (-7:7)*dvo;

[vi_grid, vo_grid] = meshgrid(vi_dc, vo_dc);

io_dc = zeros(size(vi_grid));
for j = 0:3
    for k = 0:3
        io_dc = io_dc + g(j+1, k+1)*vi_grid.^j.*vo_grid.^k;
    end
end

gdc = calcgdc(io_dc, vi_dc, vo_dc);

gdc./g


