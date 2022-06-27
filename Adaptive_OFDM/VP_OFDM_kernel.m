%% Variable Power Kernel 
clear; clc; close all;
N=16; %Number of Subcarrier
L=4; %Channel Length
Block_Num=100; %Block Number
C=4; %Len Cyclic Prefix 
M=4; %4-QAM
P=N+C;
Pb=1e-3;
N_var=1;
loop_Num=10;

%%
total=zeros(1,11,2);  %preallocating for Speed, SNR from 0 to 20
ratio=zeros(1,11,2);
for dB=0:2:20
    disp(dB);
    SNR=10^(dB/10);
    for loop=1:loop_Num
        [Ratio_AM,Ratio]=VP_OFDM(N,L,Block_Num,C,SNR);
        ratio(1,dB/2+1,1)=Ratio;
        total(1,dB/2+1,1)=total(1,dB/2+1,1)+ratio(1,dB/2+1,1);
        ratio(1,dB/2+1,2)=Ratio_AM;
        total(1,dB/2+1,2)=total(1,dB/2+1,2)+ratio(1,dB/2+1,2);
    end
end
total=total/loop_Num;
figure()
box on; hold on;
plot(0:2:20,total(:,:,1),'bx-');
plot(0:2:20,total(:,:,2),'rx-');
set(gca,'Yscale','log');
ylim([1e-4 1]);
xlabel('SNR(dB)');
ylabel('Ber');
legend('OFDM-AM','OFDM')