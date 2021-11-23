clear;clc;close all;
loop_Num=1000;
total=zeros(1,21);  %preallocating for Speed, SNR from 0 to 20
Num=50;P=68;N=64;
ratio=zeros(1,21);
for dB=0:20
    disp(dB);
    SNR=10^(dB/10);
    for loop=1:loop_Num
        [Bits,Symbols]=Block_init(Num,N);   %generate bit-stream and symbol-stream
        [H0,H1]=Block_Channelre(P-N,P);        %generate channel matrix 
        [Symbols_2,F_inv]=Block_IFFT(Symbols,N,Num);     %perform IFFT
        X=Block_CP(H0,H1,Symbols_2,SNR,N,P,Num); %Cyclic Prefix and Noise
        X_2=Block_Receive(X,N,P,Num);            %Receiver matrix,eliminate IBI 
        X_3=Block_FFT(X_2,N,F_inv,Num);                %perform FFT
        X_4=Block_equal(X_3,P,N,H0,F_inv,Num);         %equalization 
        Bitsr=Block_Demod(X_4,Num);              %demodulation into bit-stream
        error=0;
        for count=1:length(Bits)
            if Bits(count)~=Bitsr(count)
                error=error+1;
            end
        end
        ratio(dB+1)=error/(Num*N);
        total(dB+1)=total(dB+1)+ratio(dB+1);
    end
end
total=total/loop_Num;
figure()
semilogy(0:20,total);

xlabel('SNR(dB)');
ylabel('Ber');
