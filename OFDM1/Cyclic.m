% Cyclic guard length variable
loop=0;
total=0;
ratio=0;
while loop<1000
    CPP=0;
    while CPP<8
        Bits=OFDM_init(9600);
        S=OFDM_modu(Bits,2);
        S1=OFDM_ifft(S,CPP);
        [H,S2]=OFDM_channel(S1,CPP,0.05);
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
        ratio(CPP+1)=error/9600;   %BER for one realization
        CPP=CPP+1; 
    end
    total=total+ratio;
    loop=loop+1;
end
total=total/1000;  %Average over all channel realizations
plot(0:7,total)