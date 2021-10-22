loop=0;
total=zeros(1,21);
ratio=0;
SNR=0;
Length=6400;
P=20;%68;
N=16;%64;
while SNR<21
    loop=0;
    while loop<2000
        [Bits,Symbols]=Block_init(Length);
        [H0,H1]=Block_Channel(P-N,P);
        Symbols_2=Block_IFFT(Symbols,N);
        X=Block_CP(H0,H1,Symbols_2,SNR,N,P);
        X_2=Block_Receive(X,N,P);
        X_3=Block_FFT(X_2,N);
        X_4=Block_equal(X_3,P,N,H0);
        Bitsr=Block_Demod(X_4);
        count=1;
        error=0;
        while count<length(Bits)+1
            if Bits(count)~=Bitsr(count)
                error=error+1;
            end
            count=count+1;
        end
        ratio(SNR+1)=error/Length;
        loop=loop+1;
        total(SNR+1)=total(SNR+1)+ratio(SNR+1);
    end
    SNR=SNR+1;
end
total=total/2000;
figure()
semilogy(0:20,total);
