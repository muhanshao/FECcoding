function  MessageDecode =  BCH_Decoder2(Rx,t,data,pow)
% clc;
% Rx = [0 0 0 0 1 0 0 0 0 0 0 1 0 0 0];
n = length(Rx);
Ex = zeros(1,n);
% t = 3;
% principle = [1 0 0 1 1]; 
% principlen = 4;
% [data,pow] =  gentable(principle,principlen);
 
%% calculate H and S
H = zeros(2*t,n);   % H内存储data
for i = 1:2*t
    for j = 1:n
        H(i,j) = data(mod(i*(n-j),n)+1);
    end
end

S = zeros(1,2*t);    % S=H*Rx',运算在有限域内进行,S内存储data
for i = 1:2*t
    for j = 1:n
        if Rx(j) ~= 0
            S(i) = add2(S(i),mul(H(i,j),Rx(j),data,pow,n));            
        end
    end
end

%% 迭代算法  sig存储data 
% 初始化sigma，omega，d，D
sig = zeros(t,2*t);  % sig(-0.5) = 1; sig(0) = 1;
%w = zeros(2*t,2+t);    % w(-0.5) = 0; w(0) = 1;
d = zeros(1,t);        % d(-0.5) = 1; d(0) = S(1);
D = zeros(1,t);        % D(-0.5) = 0; D(0) = 0;
DD = zeros(1,t);       % DD(-0.5) = -1; DD(0) = 0;  DD(j)=2j-D(j)

sig(1,1) = 1;
sig(1,2) = S(1);
%w(1,1) = 1;

%%
for j = 1:t-1
    i = t*2;
    while sig(j,i)==0 
        i = i-1;
    end
    D(j) = i-1;
    DD(j) = 2*j-D(j);
    d(j) = S(2*j+1);
    for i = 1:D(j)
        d(j) = add2(d(j),mul(S(2*j+1-i),sig(j,i+1),data,pow,n));
    end
    if d(j)==0
        sig(j+1,:) = sig(j,:);
%       w(j+1,:) = w(j,:);
    else
        if j==1     %i=0或i=-0.5
            if S(1)~=0    %i=0
                sig(2,3) = div(d(1),S(1),data,pow,n);
                sig(2,2) = S(1);
                sig(2,1) = 1;
%               w(2,2) = add2(w(1,2),div(d(1),S(1),data,pow,n));
%               w(2,1) = 1;
            else     %i=0.5
                sig(2,4) = d(1);
                sig(2,2) = S(1);
                sig(2,1) = 1;
            end
        else
            maxDD = DD(1);    %在优化下，DD(1)=1或2，因此一定大于DD(0)和DD(-0.5)
            m = 1;
            for i = 1:j-1
                if d(i)~=0 && DD(i)>maxDD
                        maxDD = DD(i);
                        m = i;
                end
            end
            i = m;
            if i==1 && d(1)==0   %遍历d后没有找到符合要求的，则应取i=0或0.5
                sig(j+1,:) = sig(j,:);
                if S(1)==0   %取i=-0.5   
                    sig(j+1,2*j+2) = add2(sig(j,2*j+2),d(j));
                else   %取i=0
                    sig(j+1,2*j+1) = add2(sig(j,2*j+1),div(d(j),S(1),data,pow,n));
                end
            else
                tempsig = circshift(sig(i,:)',2*j-2*i)';
%               tempw = circshift(w(i,:)',2*j-2*i)';
                for k = 1:2+t
                    sig(j+1,k) = add2(sig(j,k),mul(div(d(j),d(i),data,pow,n),tempsig(k),data,pow,n));
%                   w(j+1,k) = add2(w(j,k),mul(div(d(j),d(i),data,pow,n),tempw(k),data,pow,n));  
                end
            end
        end
    end
end

sigma = sig(t,:);

%% 求解sigma，钱氏搜索
    for i = 1:n
        sumr = 1;
        for j = 1:t
            sumr = add2(sumr,mul(sigma(j+1),data(mod(i*j,n)+1),data,pow,n));
        end
        if sumr==0
            Ex(i) = 1;
        end
    end
    MessageDecode = xor(Ex,Rx);

end