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
total=zeros(1,length(Start:step:End),3); 
ratio=zeros(1,length(Start:step:End),3);
for SNRdB=Start:step:End
    disp(SNRdB);
    SNR=10^(SNRdB/10);
    for U=1:3
        M=4^U;
        for loop=1:loop_Num
            BER=FadingOFCDM(M,SNR);            
            ratio(1,SNRdB/step-Start/2+1,U)=BER;
            total(1,SNRdB/step-Start/2+1,U)=total(1,SNRdB/step-Start/2+1,U)+ratio(1,SNRdB/step-Start/2+1,U);
        end
    end
end
total=total/loop_Num;
%% Theoretical
BER2=zeros(1,length(Start:step:End),3);
for SNRdB=Start:step:End
    for U=1:3
        M=4^U;
        EbN0dB=SNRdB-10*log10(log2(M));
        sqM=sqrt(M);
        a= 2*(1-power(sqM,-1))/log2(sqM);
        b= 6*log2(sqM)/(M-1);
        rn=b*10.^(EbN0dB/10)/2;
        BER2(1,SNRdB/step-Start/2+1,U) = 0.5*a*(1-sqrt(rn./(rn+1)));
    end
end

figure()
box on; hold on;
plot(Start:step:End,total(:,:,1),'bx-');
plot(Start:step:End,total(:,:,2),'rx-');
plot(Start:step:End,total(:,:,3),'gx-');
plot(Start:step:End,BER2(:,:,1),'b');
plot(Start:step:End,BER2(:,:,2),'r');
plot(Start:step:End,BER2(:,:,3),'g');
set(gca,'Yscale','log');
ylim([1e-5 1]);
xlabel('SNR(dB)');
ylabel('Ber');
legend('OFDM 4QAM','OFDM 16QAM','OFDM 64QAM','1','2','3')