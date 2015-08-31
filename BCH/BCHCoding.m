%%
clc;clear;
N = 1e6; %number of bits
SNR = -2:0.2:12;
Pb_2psk  = zeros(1,length(SNR));
%% message generate 
Message =  randi([0,1],1,N);   %生成一个随机向量，0，1概率相等，此函数已被淘汰。。。用randi试试 
%% bpsk mapping
x_bpsk  =(Message-0.5)*2;   %bpsk:binary phase shift keying 一种模数转换方式
%% bpsk only bit error rate in add-awg-noise channel 
for i=1:length(SNR)
    r = awgn(x_bpsk,SNR(i)+10*log10(2),'measured'); % adding noise SNR以分贝为单位，‘measured’表示加入噪声前测定信号强度
    r_bpsk = sign(r);                     %slice
    error = abs(r_bpsk-x_bpsk);
    error_counter =sum(error);       %求和
    Pb_2psk (i) = error_counter/N;
end
%% BCH （15，5，3）
n = 15;    %n：码字长度
k = 5;       %k：信息位位数
t = 3;       %t：纠错个数
Gen = [1 0 1 0 0 1 1 0 1 1 1];       %Gen:生成多项式
principle = [1 0 0 1 1];  %本原多项式 x^4+x+1
principlen = 4;  % m=4
%% BCH  (15,7,2)
% n = 15;    %n：码字长度
% k = 7;       %k：信息位位数
% t = 2;       %t：纠错个数
% Gen = [1 1 1 0 1 0 0 0 1];       %Gen:生成多项式
% principle = [1 0 0 1 1];  %本原多项式 x^4+x+1
% principlen = 4;  % m=4
%% BCH   (31,21,2)
% n = 31;    %n：码字长度
% k = 16;       %k：信息位位数
% t = 3;       %t：纠错个数
% Gen = [1 0 0 0 1 1 1 1 1 0 1 0 1 1 1 1];       %Gen:生成多项式
% principle = [1 0 0 1 0 1];  %本原多项式 x^5+x^2+1
% principlen = 5;  % m=5
%% BCH  (31,16,3)
% n = 31;    %n：码字长度
% k = 16;       %k：信息位位数
% t = 3;       %t：纠错个数
% Gen = [1 1 0 0 0 0 1 0 1 0 0 1 0 1 0 1];       %Gen:生成多项式
% principle = [1 1 0 1 1 1];  %本原多项式 x^5+x^2+1
% principlen = 5;  % m=5
%% BCH  (63,51,2)
% n = 63;    %n：码字长度
% k = 51;       %k：信息位位数
% t = 2;       %t：纠错个数
% Gen = [1 0 1 0 1 0 0 1 1 1 0 0 1];       %Gen:生成多项式
% principle = [1 0 0 0 0 1 1];  %本原多项式 x^6+x+1
% principlen = 6;  % m=6


[data,pow] =  gentable(principle,principlen);  %构成有限域的运算函数
Pb_BCH = zeros(1,length(SNR));
%% bit error rate in add-awg-noise channel with BCH coding
for i=1:length(SNR)
fprintf('i=%d\n',i);   
error_counter =0;
for j = 1:k:(fix(N/k)*k-1)
    Message_Buffer = Message(j:j+k-1);    %Message_Buffer长度为k
    MessageEncode = BCH_Encoder(k, Message_Buffer, n, Gen); % Encode 
    BCH_bpsk  =(MessageEncode-0.5)*2;     % bpsk mapping
    r_BCH = awgn(BCH_bpsk,SNR(i)+10*log10(2),'measured'); % adding noise 
    r_bpsk = sign(r_BCH);    %slice
    Rx = r_bpsk/2+0.5; % Debpsk mapping
    BCHcode =  BCH_Decoder2(Rx ,t,data,pow);  % correct error
    MessageDecode=mod(deconv(BCHcode,Gen),2);  %Decode
    exx = xor(MessageDecode,Message_Buffer);  % count error
    error_counter =error_counter+sum(exx);   % accumulate
end
    Pb_BCH (i) = error_counter/N;
end
% 
%% 

% semilogy(SNR,Pb_2psk,'r',SNR,Pb_BCH,'b','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('Not encoding','BCH(15,7,2)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% set(gcf, 'PaperPositionMode','auto');
% print -r300 -djpeg BCH2(15,7,2) 

% semilogy(SNR,Pb_2psk,'r',SNR,Pb_BCH,'b','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('Not encoding','BCH(15,5,3)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% set(gcf, 'PaperPositionMode','auto');
% print -r300 -djpeg BCH2(15,5,3) 

% semilogy(SNR,Pb_2psk,'r',SNR,Pb_BCH,'b','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('Not encoding','BCH(31,16,3)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% set(gcf, 'PaperPositionMode','auto');
% print -r300 -djpeg BCH2(31,16,3) 


% semilogy(SNR,Pb_2psk,'r',SNR,Pb_BCH,'b','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('Not encoding','BCH(31,21,2)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% set(gcf, 'PaperPositionMode','auto');
% print -r300 -djpeg BCH2(31,21,2) 

% semilogy(SNR,Pb_BCH,'b',SNR,Pb_1572,'r','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('BCH(15,5,3)','BCH(15,7,2)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% % print -r300 -djpeg BCH2_compare1 

% semilogy(SNR,Pb_BCH,'b',SNR,Pb_3116,'r','linewidth',2 ); hold on;
% xlabel('SNR/dB','FontName','Arial', 'FontSize',22)
% ylabel('bit error rate','FontName','Arial','FontSize',22); 
% title('N = 1e6','FontSize',22);
% grid on;
% hold on;
% % plot(imgCorrectedSingle(line1D,:),'k--','linewidth',3); plot(imgPlanningSingle(line1D,:),'k:','linewidth',3)
% hLegend = legend('BCH(31,16,3)','BCH(31,21,2)','FontSize',22); hold off
% set(hLegend, 'FontSize', 22);
% set(gca, 'FontSize', 22);
% set(gca, 'LineWidth', 3');
% print -r300 -djpeg BCH2_compare2 


%figure(2)
% semilogy(SNR,Pb_BCH ); hold on;   %semilogy: 画对数图
% grid on;
% axis([-3,6,10e-7,1]);
% xlabel('SNR/dB');
% ylabel('bit error rate ');


% load BCH_result.mat
% 
% figure(3)
% semilogy(SNR,Pb_BCH,'b',SNR,Pb_2psk,'r' ); hold on;
% grid on;
% axis([-3,12,10e-7,1]);
% xlabel('SNR/dB');
% ylabel('bit error rate ');
%save('BCH(31,16,3)N1e6');


