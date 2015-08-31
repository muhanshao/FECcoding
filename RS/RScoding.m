clear;close all;clc;
%%
m = 3;
n = 7;   % Length of code
k = 3;    % Length of each message
N = 1e4*k;   % Total number of bits
SNR = 10:.2:12;
% SNR = -2:0.2:12;
Pb_psk  = zeros(1,length(SNR));
%% message generate 
Message =  randi([0,n],1,N);   
%% psk mapping
x_psk  = pskmod(Message,2^m);  
%% psk only bit error rate in add-awg-noise channel 
for i=1:length(SNR)
    r = awgn(x_psk,SNR(i),'measured'); %+10*log10(2),'measured'); % adding noise SNR以分贝为单位，‘measured’表示加入噪声前测定信号强度
    r_psk = pskdemod(r,2^m);                     %slice
    error_counter =sum(r_psk~=Message);       %求和
    Pb_psk (i) = error_counter/N;
end
%% RS coding
PrimPoly = primpoly(m);
[Gen_gf,t] = rsgenpoly(2^m-1,k);
field = gftuple([-1:2^m-2]',m,2);
[field_pow,field_data] = find_index(field,m);
Gen = double(Gen_gf.x);
for i = 1:length(Gen)
    if Gen(i) == 0
        Gen(i) = -inf;
    else
        Gen(i) = field_pow(Gen(i));
    end
end
Gen = fliplr(Gen);
%
Pb_RS = zeros(1,length(SNR));
for i=1:length(SNR)
fprintf('i = %d\n',i);   
MessageDecode = zeros(1,N);
for j = 1:k:N
    Message_Buffer = Message(j:j+k-1);    
    MessageEncode = RsEnc(Message_Buffer,n,k,field_data,field_pow,Gen,field); % Encode 
    RS_psk = pskmod(MessageEncode,2^m);     
    Rs_r = awgn(RS_psk,SNR(i),'measured');%+10*log10(2),'measured'); % adding noise    
    Rx = pskdemod(Rs_r,2^m);
    MessageDecode(j:j+k-1) = RsDec( Rx,n,m,k,t,PrimPoly);
end
    error_counter = sum(Message ~= MessageDecode);
    Pb_RS (i) = error_counter/N;
end


% figure, plot(imgRawSingle(line1D,:),'k-','linewidth',3); 
semilogy(SNR,Pb_RS,'b',SNR,Pb_psk,'r','linewidth',2 ); hold on;
xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
ylabel('bit error rate','FontName','Arial','FontSize',22); 
title('N = 3e5','FontSize',22);
grid on;
hold on;
% plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
hLegend = legend('RS(7,3,2)','Not encoding','FontSize',22); hold off
set(hLegend, 'FontSize', 22);
set(gca, 'FontSize', 22);
set(gca, 'LineWidth', 3');
% print -r300 -djpeg RS(7,3,2) 

% semilogy(SNR,Pb_RS,'b',SNR,Pb_psk,'r' ); hold on;
% grid on;
% % axis([-3,12,10e-7,1]);
% xlabel('SNR/dB');
% ylabel('bit error rate ');
% % save('RS(7,3,2,3e5)');



