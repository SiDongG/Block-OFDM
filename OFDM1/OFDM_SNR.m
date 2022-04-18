%MQAM SNR simulation
CPP=2;
loop=0;
total1=0;
ratio=0;
while loop<20
    dB=0;
    while dB<11
        Bits=OFDM_init(6400);
        S=OFDM_modu(Bits,2);
        S1=OFDM_ifft(S,CPP);
        SNR10=10^(dB/10);
        [H,S2]=OFDM_channel(S1,CPP,1/SNR10);
        S3=OFDM_fft(H,S2);
        R=OFDM_demod(S3,2);
        count=1;
        error=0;
        while count<length(R)+1
            if R(count)~=Bits(count)
                error=error+1;
            end
            count=count+1;
        end
        ratio(dB+1)=error/6400;
        dB=dB+1;
    end
    total1=total1+ratio;
    loop=loop+1;
end
total1=total1/20;
semilogy(0:10,total1);
hold on

    