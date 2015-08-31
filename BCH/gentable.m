function [data,pow] =  gentable(principle,n) %本原多项式构建有限域中的运算函数
clc;
% n = 10;       %此处的n相当于主函数里的m，即GF（2^m）的m
% principle = [1 0 0 0 0 0 0 1 0 0 1];  %本原多项式
N = 2^n;   %可组成的所有序列,有限域中所有的元素
Table = zeros(N,n);     %所有码字序列的初始化
data = zeros(1,N);
pow = zeros(1,N);
temp  = principle(2:end);   %（2：end）从第二个到最后，本原多项式这样操作即代表了x^10=x^3+1
for i=1:n
    Table(i,:) = zeros(1,n);
    for k = 1:n
        if k== n-i+1
            Table(i,k) = 1;
        end
    end
end     %得到一个从对角线为1，其余为0的n*n矩阵；
        %即前4个数为α^0,α^1,α^2,α^3,即1，2，4，8，所以与α^15=1有重复，故后面再做处理。

for i = n+1:N
     Table(i,1:end-1) = Table(i-1,2:end);  
     Table(i,end) = 0;    %第i行为α^i,第i+1行为α^(i+1),故每行数字理论上为前一行数字×2，操作为左移一位，且先不考虑首位
     if Table(i-1,1) == 1   %前一行首位为1，则说明×2后出现了x^4,需用x+1代替
         for k = 1:n
             Table(i,k) = xor(Table(i,k) , temp(k) );  %xor：异或，在此是进行加法运算，加x+1
         end
     end
end       
for k=1:N
    for i = 1:n
    data(k) = data(k) + Table(k,i)*2^(n-i);   %二进制转换成十进制
    end    
end
for k = 1:N
    num = data(k);
    pow(num) = k-1;
end     %将data转为pow，pow中的数据为0~15，且pow(16)=0

pow = pow(1:end-1);
end     


%最终得到表格为
% 序号(i)   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
% data     2   4   8   3   6   12  11  5   10   7  14  15   13  9   1
% pow(j)   15  1   4   2   8   5   10  3   14   9   7   6   13  11  12
% 序号表示α的次幂数i，data表示在定义的运算中α^i对应的数，pow(j)表示α^pow(j)=j,为了方便将pow与data进行了对应(因为平时处理的是data)
% 注意：此函数最终结果中，data有16个数据，pow有15个，故中间有一错位，在mul乘法函数里有所体现   
