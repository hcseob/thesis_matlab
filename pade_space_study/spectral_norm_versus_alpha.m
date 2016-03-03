function spectral_norm_versus_alpha
run('~/thesis/matlab/thesis.m'); addpath('./lib');
alphas = logspace(-3, 1, 50);
for j = 2:7
    order = j;
    Aeq1 = create_A(order, 1);
    for k = 1:length(alphas)
        alpha = alphas(k);
        Aeqa = create_A(order, alpha);
        Ma = Aeqa^-1*Aeq1;
        S = transpose(Ma)*Ma;
        [V, D]= eig(S);
        sN(k, j) = sqrt(max(real(diag(D))));
    end
end

Aeq1 = create_A(5, 1);
M = create_A(5, 1/3)^-1*Aeq1;
S = transpose(M)*M;
[V, D]= eig(S);
sN1by3 = sqrt(max(real(diag(D))));

M = create_A(5, 0)^-1*Aeq1;
S = transpose(M)*M;
[V, D]= eig(S);
sN0 = sqrt(max(real(diag(D))));


figure;
semilogx(alphas, sN(:, 2), '-k', 'linewidth', 2); hold all;
semilogx(alphas, sN(:, 3), '-k', 'linewidth', 2); hold all;
semilogx(alphas, sN(:, 4), '-k', 'linewidth', 2); hold all;
semilogx(alphas, sN(:, 5), '-k', 'linewidth', 2); hold all;
text(3e-3, 3.3, 'N=2', 'fontsize', 14);
text(3e-3, 7, 'N=3', 'fontsize', 14);
text(3e-3, 17.5, 'N=4', 'fontsize', 14);
text(3e-3, 46.5, 'N=5', 'fontsize', 14);
set(gca, 'fontsize', 14);
xlabel('alpha', 'fontsize', 14);
ylabel('sN', 'fontsize', 14);
print('-depsc', './figures/spectral_norm_versus_alpha');
end