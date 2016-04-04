function A = create_A(N, alpha)
A = nan(N, N);
for m = 0:N-1
    for n = 0:N-1
        A(m+1, n+1) = create_a_mn(m, n, N, alpha);
    end
end
end

function a_mn = create_a_mn(m, n, N, alpha)
a_mn = 0;
for k = max(0, m-n):min(N-1-n, m)
    a_mn = a_mn + (-1)^(m-k)*alpha^(m-k)*binom(N-1-n, k)*binom(n, m-k);
end
end

function y = binom(n, k)
y = factorial(n)/factorial(n-k)/factorial(k);
end