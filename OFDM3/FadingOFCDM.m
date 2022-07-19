function BER=FadingOFCDM(M,SNR)
%% Initializations
% M=[4,16,64,256];
N=64;
P=68;
L=4;
Block_Num=100;
S=eye(N);
T=[S(2*N-P+1:N,:);S];
R=[zeros(N,P-N),eye(N)];
IFFT=zeros(N);
for a=1:N
    for b=1:N
        IFFT(a,b)=exp(1i*2*pi*(a-1)*(b-1)/N);
    end 
end
IFFT=IFFT*1/sqrt(N);
FFT=conj(IFFT);

h=(1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
H0=zeros(P); 
H1=zeros(P); 
a=1;
while a<P+1  
    b=1;
    while b<P+1
        if a-b<0 || a-b>L-1
            H0(a,b)=0;
        else
            H0(a,b)=h(a-b+1);
        end
        if P+a-b<0 || P+a-b>L-1
            H1(a,b)=0;
        else
            H1(a,b)=h(P+a-b+1);
        end
        b=b+1;
    end
    a=a+1;
end
D=FFT*R*H0*T*IFFT;
%% Modulation
Bits=randi(0:1,[1,N*Block_Num*log2(M)]);
Bits2=zeros(1,length(Bits)/log2(M));
for i=1:log2(M):length(Bits)
    Bits2(1+(i-1)/log2(M))=bin2dec(num2str(Bits(i:i+log2(M)-1)));
end
if M==4
    Bits3=qammod(Bits2,M)*sqrt(0.5);
end
if M==16
    Bits3=qammod(Bits2,M)*sqrt(1/10);
end
if M==64
    Bits3=qammod(Bits2,M)*sqrt(1/42);
end
%% Channel 
nr=randn(N,1,Block_Num);
ni=randn(N,1,Block_Num);
Noise=(sqrt(2)/2)*(nr+1i*ni);
Symbols=reshape(Bits3,[N,1,Block_Num]);
Symbols2=zeros(size(Symbols));
for count=1:Block_Num
    Symbols2(:,:,count)=pinv(D)*(D*Symbols(:,:,count)+(1/sqrt(SNR))*Noise(:,:,count));
end
%% Demod
if M==4
    Symbols3=qamdemod(Symbols2/sqrt(1/2),M);
end
if M==16
    Symbols3=qamdemod(Symbols2/sqrt(1/10),M);
end
if M==64
    Symbols3=qamdemod(Symbols2/sqrt(1/42),M);
end
Bitsre=zeros(1,N*Block_Num*log2(M));
start=1;
for count=1:Block_Num
    for k=1:N
        dec=dec2bin(Symbols3(k,1,count),log2(M));
        for n=1:length(dec)
            Bitsre(start)=str2double(dec(n));
            start=start+1;
        end
    end
end

BER=sum(Bitsre~=Bits)/(Block_Num*N*log2(M));



















