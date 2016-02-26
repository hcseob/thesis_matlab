function obj = extract_s4p(path)
data = importdata(path, ' ', 39);

obj.f = data.data(1:4:end, 1);

for k = 1:4

    obj.magS(1, k, :) = data.data(1:4:end, 2*k);
    obj.magS(2, k, :) = data.data(2:4:end, 2*k-1);
    obj.magS(3, k, :) = data.data(3:4:end, 2*k-1);
    obj.magS(4, k, :) = data.data(4:4:end, 2*k-1);

    obj.angS(1, k, :) = data.data(1:4:end, 2*k+1);
    obj.angS(2, k, :) = data.data(2:4:end, 2*k+1-1);
    obj.angS(3, k, :) = data.data(3:4:end, 2*k+1-1);
    obj.angS(4, k, :) = data.data(4:4:end, 2*k+1-1);
end
end