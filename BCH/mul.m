function result = mul(data1,data2,data,pow,n)   %�������ڵĳ˷�����
if data1 ==0 || data2 ==0   %����һ����Ϊ0ʱ�����Ϊ0
    result =0;
    return;
end
power1 = pow(data1);     
power2 = pow(data2);               %�����data��Ӧ�����Ħ��Ĵ���
result = mod((power1+power2),n);   %���ݶ�n���࣬���Ϊ�˷������Ӧ�Ħ��Ĵ���
result = data(result+1);
end
