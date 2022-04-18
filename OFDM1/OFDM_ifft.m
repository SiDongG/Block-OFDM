%IFFT
function OFDMsym=OFDM_ifft(Symbols,CPP)
%Subcarrier number=8%
count=1;
count1=1;
while count<length(Symbols)
    sample=ifft(Symbols(count:count+7));
    sample_2=[sample(9-CPP:8),sample];  %Insert Guard
    OFDMsym(count1:count1+CPP+7)=sample_2;
    count=count+8;
    count1=count1+8+CPP;
end

