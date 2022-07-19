Block_Num=100;
N=64;
P=68;
L=4;
C=4;
SNR=1;
loop_Num=100;

%%
step=2;
Start=0;
End=20;
total=zeros(1,length(0:2:20),3); 
ratio=zeros(1,length(0:2:20),3);
for dB=0:4:20
    disp(dB);
    SNR=10^(dB/10);
    for U=1:3
        M=4^U;
        for loop=1:loop_Num
            BER=FadingOFCDM(M,SNR);            
            ratio(1,dB/step-Start/2+1,U)=BER;
            total(1,dB/step-Start/2+1,U)=total(1,dB/step-Start/2+1,U)+ratio(1,dB/step-Start/2+1,U);
        end
    end
end
total=total/loop_Num;
figure()
box on; hold on;
plot(Start:step:End,total(:,:,1),'bx-');
plot(Start:step:End,total(:,:,2),'rx-');
plot(Start:step:End,total(:,:,3),'gx-');
set(gca,'Yscale','log');
ylim([1e-6 1]);
xlabel('SNR(dB)');
ylabel('Ber');
legend('OFDM 4QAM','OFDM 16QAM','OFDM 64QAM')