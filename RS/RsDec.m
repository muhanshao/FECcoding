function [ MessageDecode ] = RsDec( Rx,n,m,k,t,PrimPoly )

% m = log2(n);

Rx = gf(Rx,m,PrimPoly);
s = calS(Rx,n,m,t,PrimPoly);
alpha = gf(2,m,PrimPoly);

%% RiBM Algorithm
% Initialize
flag = 0;
gamma = 1;
delta = gf(zeros(1,3*t+2),m);
delta(1:2*t) = s;
delta(3*t+1) = 1;
theta = delta(1:3*t+1);
delta_temp = delta;

% Calculate
for r = 1:2*t+1
    delta = delta_temp;
% step 1
    delta_temp(1:3*t+1) = (gamma*delta(2:3*t+2))-(delta(1)*theta(1:3*t+1));
% step 2
    if (delta(1)~=0) && (flag>=0)
        theta(1:3*t+1) = delta(2:3*t+2);
        gamma = delta(1);
        flag = -flag-1;
    else
%         theta = theta;
%         gamma = gamma;
        flag = flag+1;
    end          
end
lamda = delta(t+1:2*t+1);
omega = delta(1:t);

%% Chain Search
inverse2 = gf(zeros(1,t+1),m,PrimPoly);
for i = 1:t+1
    inverse2(i) = alpha^(i-1);
end

zero = gf(0,m,PrimPoly);
err = zeros(2,n);
accu = gf(ones(1,t+1),m,PrimPoly);
for i = 1:n
    accu = accu.*inverse2;
    test = lamda*accu';
    if test == zero
        err(1,i) = 1;
    end
end

%% Forney's algorithm
even = floor(t/2)*2;
if even == t
    odd = t-1;
else
    odd = t;
end

inverse2 = gf(zeros(1, t+1), m, PrimPoly);
for i = 1:3*t,
    inverse2(i) = alpha^(-i+1);
end;

accu_tb = gf(ones(1, t+1), m,PrimPoly);
accu_tb1 = gf(ones(1, 3*t), m, PrimPoly);

omega2 = [zeros(1,2*t),omega]; 
for i = 1:n
    lamda_ov = lamda(2:2:odd+1)*accu_tb(2:2:odd+1)';
    if lamda_ov == zero
        lamda_ov = gf(randi([1,n]),m,PrimPoly);
    end
    omega_v = omega2*accu_tb1';    
    accu_tb = accu_tb.*inverse2(1:t+1);
    accu_tb1 = accu_tb1.*inverse2;    
    
    if(err(1,n-i+1) == 1)
        ev = (omega_v/lamda_ov)*alpha^(1-i);
        err(2, n-i+1) = double(ev.x);
    end
end

MessageCorrect = Rx-gf(err(2,:),m,PrimPoly);
MessageDecode = MessageCorrect(1:k);
MessageDecode = double(MessageDecode.x);


% % Calulation
% for r = 1:2*t
%     for i = 1:3*t
%         delta(i,r+1) = gfsub(gfmul(delta(i+1,r),gama(r),field),gfmul(delta(1,r),theta(i,r),field),field);
%     end
%     if r == 2*t
%         break;
%     end
%     if delta(1,r)~=-inf && k(r)>=0
%         theta(i,r+1) = delta(i+1,r);
%         gama(r+1) = delta(1,r);
%         k(r+1) = -k(r)-1;
%     else
%         theta(i,r+1) = theta(i,r);
%         gama(r+1) = gama(r);
%         k(r+1) = k(r)+1;
%     end
% end
% 
% sigma = delta(t+1:2*t+1,2*t+1);
% w = delta(1:t,2*t+1);

end

