function Nsym = find_Nsym(v)
Nsyms = [4, 5, 6, 8];
max_c = -inf;
for k = Nsyms
    L = 254 * k;
    c = dot(v(1:L), v(L+1:2*L))/dot(v(1:L),v(1:L));
    if (c > 0.95)
        Nsym = k;
        break;
    end
end
end