function [coeffs_opt, pmr_opt, p_opt] = brute_force_pmr_opt(ps, bits, threshold)
num_coeffs = size(ps, 2);
pmr_opt = 0;

if num_coeffs == 2
    for j = (2^bits-1)
        for k = -(2^bits-1):(2^bits-1)
            p = ps*[j; k]/2^bits;
            if max(p) > threshold
                pmr = max(p)/sum(abs(p));
                if pmr > pmr_opt
                    pmr_opt = pmr;
                    coeffs_opt = [j; k]/2^bits;
                    p_opt = p;
                end
            end
        end
    end
elseif num_coeffs == 3
    for j = -(2^bits-1):(2^bits-1)
        for k = 2^bits-1
            for l = -(2^bits-1):(2^bits-1)
                p = ps*[j; k; l]/2^bits;
                if max(p) > threshold
                    pmr = max(p)/sum(abs(p));
                    if pmr > pmr_opt
                        pmr_opt = pmr;
                        coeffs_opt = [j; k; l]/2^bits;
                        p_opt = p;
                    end
                end
            end
        end
    end
elseif num_coeffs == 4
    for j = -(2^bits-1):(2^bits-1)
%         disp(100*(j+(2^bits-1))/2^(bits+1))
        for k = 2^bits-1
            for l = -(2^bits-1):(2^bits-1)
                for m = -(2^bits-1):(2^bits-1)
                    p = ps*[j; k; l; m]/2^bits;
                    if max(p) > threshold
                        pmr = max(p)/sum(abs(p));
                        if pmr > pmr_opt
                            pmr_opt = pmr;
                            coeffs_opt = [j; k; l; m]/2^bits;
                            p_opt = p;
                        end
                    end
                end
            end
        end
    end
elseif num_coeffs == 5
    for j = -(2^bits-1):(2^bits-1)
%         disp(100*(j+(2^bits-1))/2^(bits+1))
        for k = 2^bits-1
            for l = -(2^bits-1):(2^bits-1)
                for m = -(2^bits-1):(2^bits-1)
                    for n = -(2^bits-1):(2^bits-1)
                        p = ps*[j; k; l; m; n]/2^bits;
                        if max(p) > threshold
                            pmr = max(p)/sum(abs(p));
                            if pmr > pmr_opt
                                pmr_opt = pmr;
                                coeffs_opt = [j; k; l; m; n]/2^bits;
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