function MessageEncode =  BCH_Encoder(k, Message, n, Gen)
MatrixTemp = zeros(k,n);
m = length(Gen)-1;    %m=14
%Gen=[1 904 6 701 32 656 925 900 614 391 592 265 945 290 432];
MessageEncode = zeros(1,n);
for i = 1:k
    MatrixTemp(i,i:i+m) = Message(i)*Gen;   
end

for i =1:k
    MessageEncode =xor( MessageEncode , MatrixTemp(i,:) );  %码字多项式=消息矢量×生成多项式
end       
end