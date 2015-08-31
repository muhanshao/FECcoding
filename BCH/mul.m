function result = mul(data1,data2,data,pow,n)   %有限域内的乘法运算
if data1 ==0 || data2 ==0   %当有一个数为0时，结果为0
    result =0;
    return;
end
power1 = pow(data1);     
power2 = pow(data2);               %计算出data对应的数的α的次幂
result = mod((power1+power2),n);   %次幂对n求余，结果为乘法结果对应的α的次幂
result = data(result+1);
end
