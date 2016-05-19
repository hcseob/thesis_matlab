function gtrans = calcgtrans_fft(f, x, y, threshold)
if nargin < 4; threshold = 1e-12; end;
Ax = max(abs(x));
Ay = max(abs(y));
[~, kx] = max(abs(fft(x))); kx = kx - 1;
[~, ky] = max(abs(fft(y))); ky = ky - 1;

N=length(f);
inds = 1:N;
f_fft=fft(f);
not_corrected = [ones(1, N/2), zeros(1, N/2)];
noncorrected_f_fft = abs(f_fft(find(not_corrected)));
while any(noncorrected_f_fft > threshold)
    valid_inds = find(noncorrected_f_fft > threshold);
    [~, min_ind] = min(noncorrected_f_fft(valid_inds));
    noncorrected_inds = inds(find(not_corrected));
    temp = noncorrected_inds(valid_inds);
    min_ind_actual = temp(min_ind);
    not_corrected(min_ind_actual) = 0;
    
    k = round((min_ind_actual-1)/ky);
    j = abs(round((min_ind_actual-1 - k*ky)/kx));
    xjyk_fft = fft(x.^j.*y.^k);
    gtrans(j+1, k+1) = real(xjyk_fft(min_ind_actual)'*f_fft(min_ind_actual))/abs(xjyk_fft(min_ind_actual))^2;
    
    noncorrected_f_fft = abs(f_fft(find(not_corrected)));
end

           