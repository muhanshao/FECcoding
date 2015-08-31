function result = div(data1,data2,data,pow,n)
if data1 == 0
    result =0;
    return;
end
power1 = pow(data1);
power2 = pow(data2);
result = mod((power1-power2)+n,n);
result = data(result+1);
end
