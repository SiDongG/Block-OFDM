%FFT
function OFDMsym_re=OFDM_fft(H,Symbols)
count=1;
while count<length(Symbols)
    sample=fft(Symbols(count:count+7))./H; %Zero-forcing equalizer
    S(count:count+7)=sample;
    count=count+8;
end
OFDMsym_re=S;
