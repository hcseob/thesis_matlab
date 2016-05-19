function gtrans = calcgtrans_lms(f, x, y, N)
if nargin < 4; N = 3; end;
x = x(:); % make column vector
y = y(:); % make column vector
f = f(:); % make column vector

A = [];
for j = 0:N
    for k = 0:N
        A = [A, x.^j.*y.^k];
    end
end

gtrans = A\f;
gtrans = reshape(gtrans, [N+1, N+1])';