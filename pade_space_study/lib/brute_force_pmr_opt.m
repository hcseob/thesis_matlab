function [coeffs_opt, pmr_opt, p_opt] = brute_force_pmr_opt(ps, bits, threshold)
num_coeffs = size(ps, 2);
pmr_opt = 0;
N = round(2^bits);
if num_coeffs == 2
    for j = (N-1)
        for k = -(N-1):(N-1)
            p = ps*[j; k]/(N-1);
            if max(p) > threshold
                pmr = max(p)/sum(abs(p));
                if pmr > pmr_opt
                    pmr_opt = pmr;
                    coeffs_opt = [j; k]/(N-1);
                    p_opt = p;
                end
            end
        end
    end
elseif num_coeffs == 3
    for j = -(N-1):(N-1)
        for k = N-1
            for l = -(N-1):(N-1)
                p = ps*[j; k; l]/(N-1);
                if max(p) > threshold
                    pmr = max(p)/sum(abs(p));
                    if pmr > pmr_opt
                        pmr_opt = pmr;
                        coeffs_opt = [j; k; l]/(N-1);
                        p_opt = p;
                    end
                end
            end
        end
    end
elseif num_coeffs == 4
    for j = -(N-1):(N-1)
        for k = N-1
            for l = -(N-1):(N-1)
                for m = -(N-1):(N-1)
                    p = ps*[j; k; l; m]/(N-1);
                    if max(p) > threshold
                        pmr = max(p)/sum(abs(p));
                        if pmr > pmr_opt
                            pmr_opt = pmr;
                            coeffs_opt = [j; k; l; m]/(N-1);
                            p_opt = p;
                        end
                    end
                end
            end
        end
    end
elseif num_coeffs == 5
    for j = -(N-1):(N-1)
        for k = N-1
            for l = -(N-1):(N-1)
                for m = -(N-1):(N-1)
                    for n = -(N-1):(N-1)
                        p = ps*[j; k; l; m; n]/(N-1);
                        if max(p) > threshold
                            pmr = max(p)/sum(abs(p));
                            if pmr > pmr_opt
                                pmr_opt = pmr;
                                coeffs_opt = [j; k; l; m; n]/(N-1);
                                p_opt = p;
                            end
                        end
                    end
                end
            end
        end
    end
else
    error('unsupported number of coeffs');
end

end