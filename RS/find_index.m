function [ field_pow,field_data ] = find_index( field,m )

% This function generate the data and power vector of GF(2^m).
n = 2^m-1;
field_data = zeros(1,n);
field_pow = zeros(1,n);
for i = 0:n-1
    str = num2str(field(i+2,:));
    str(find(isspace(str))) = [];
    str = fliplr(str);
    field_data(i+1) = bin2dec(str);
end

for i = 1:n
    field_pow(i) = find(field_data==i)-1;
end

end

