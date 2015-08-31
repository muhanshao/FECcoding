function [ MessageEncode ] = RsEnc( Message,n,k,field_data,field_pow,Gen,field )

% field = gftuple([-1:2^m-2]',m,2);
% [field_pow,field_data] = find_index(field,n);
% Gen = [3 1 0 3 0];


Message_a = zeros(1,k);
for i = 1:k
    if Message(i) == 0
        Message_a(i) = -inf;
    else
        Message_a(i) = field_pow(Message(i));
    end
end
Message_a = fliplr([Message_a,-Inf*ones(1,n-k)]);
[~,Message_b] = gfdeconv(Message_a,Gen,field);

for i = 1:length(Message_b)
    if Message_b(i) == -inf;
        Message_b(i) = 0;
    else
        Message_b(i) = field_data(Message_b(i)+1);
    end
end

Message_b = fliplr(Message_b);

while length(Message_b) ~= n-k
    Message_b = [0,Message_b];
end

MessageEncode = [Message,Message_b];

end

