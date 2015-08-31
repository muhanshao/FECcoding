function [ s ] = calS( Rx,n,m,t,PrimPoly )

%% Efficient way
% Creating alpha array
alpha = gf(2,m);
alpha_tb=gf(zeros(1, 2*t), m);
for i=1:2*t,
    alpha_tb(i)=alpha^(i);
end;

% Syndrome generation
% PrimPoly = primpoly(m);
s = gf(zeros(1, 2*t), m, PrimPoly);
for i = 1:n,
    s = s.*alpha_tb+Rx(i);
end;


%% Easy to understand but complex
% % Rx data to power
% R = zeros(1,n);
% for i = 1:n
%     if Rx(i) == 0
%         R(i) = -inf;
%     else
%         R(i) = field_pow(Rx(i));
%     end
% end
% R = fliplr(R);
% 
% % alpha power
% a = 0:n-1;
% b = ones(2*t,1);
% alphapow = diag(1:2*t)*(b*a);
% alphapow = mod(alphapow,n);
% 
% % Calculate S
% RR = b*R;
% S = gfmul(RR,alphapow,field);
% 
% % Calculate s
% s = -inf*ones(1,2*t);
% for i = 1:2*t
%     for j = 1:n
%         s(i) = gfadd(s(i),S(i,j),field);
%     end
% end
% 
% for i = 1:2*t
%     if s(i) == -inf
%         s(i) = 0;
%     else
%         s(i) = field_data(s(i)+1);
%     end
% end
% s = gf(s,m,PrimPoly);


end

