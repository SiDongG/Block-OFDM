%% Variable Power Variable Rate Adaptive Modulation
%% Parameters 
clear; clc; close all;
N=64; %Number of Subcarrier
L=4; %Channel Length
Block_Num=100; %Block Number
C=4; %Len Cyclic Prefix 
P=N+C;
S=eye(N);
T=[S(2*N-P+1:N,:);S];
R=[zeros(N,P-N),eye(N)];
Pb=1e-4;
K=-1.5/(log(5*Pb)); % Above Cutoff Fade Level Constraint
N_var=1;
M=2; %2QAM for non-adaptive transmission 
SNR=10;
Power=N_var*SNR;
Power_avg=Power/N; % Average Power Constraint
IFFT=zeros(N);
for a=1:N
    for b=1:N
        IFFT(a,b)=exp(1i*2*pi*(a-1)*(b-1)/N);
    end 
end
IFFT=IFFT*1/sqrt(N);
FFT=conj(IFFT);
%% Initialize the channel 
h=10*(1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
H0=zeros(P); %Preallocating for speed, H0 is the P by P matrix have the (i,j)th entry h(i-j)
H1=zeros(P); %Preallocating for speed, H1 is the P by P matrix have the (i,j)th entry h(P+i-j)
a=1;
while a<P+1  %generate the channel matrces
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
%% Subcarrier Classification
D_img=diag(abs(D));

y0=0.2; %Initialize Threshold and iteratively search for power balance
yk=y0/K;
Power_alloc=zeros(size(D_img));
QAM_alloc=zeros(size(D_img));
while abs(sum(Power_alloc)-Power)>Power/20   %Within 5% Accuracy
    for count=1:N
        if (0<=D_img(count)/yk) && (D_img(count)/yk<2)
            Power_alloc(count)=0;
            QAM_alloc(count)=0;
        elseif (2<=D_img(count)/yk) && (D_img(count)/yk<4)
            Power_alloc(count)=Power_avg*(1/(D_img(count)*K));
            QAM_alloc(count)=2;
        elseif (4<=D_img(count)/yk) && (D_img(count)/yk<16)
            Power_alloc(count)=Power_avg*(3/(D_img(count)*K));
            QAM_alloc(count)=4;
        elseif (16<=D_img(count)/yk) && (D_img(count)/yk<64)
            Power_alloc(count)=Power_avg*(15/(D_img(count)*K));
            QAM_alloc(count)=16;
        else
            Power_alloc(count)=Power_avg*(63/(D_img(count)*K));
            QAM_alloc(count)=64;
        end
    end
    if sum(Power_alloc)>Power+Power/20
        yk=yk+0.0001;
    elseif sum(Power_alloc)<Power-Power/20
        yk=yk-0.0001;
    else
        yk=yk;
    end
end

SNR_alloc=zeros(size(D_img));
for i=1:N
    SNR_alloc(i)=Power_alloc(i)*D_img(i)/Power_avg;
end

%% Power and Rate Adaptation Plots 
% bar(D_img)
% hold on;
% plot([0,64],[2*yk,2*yk])
% plot([0,64],[4*yk,4*yk])
% plot([0,64],[16*yk,16*yk])
% figure
% bar(Power_alloc)
% figure
% bar(SNR_alloc)
%% Bits-Generation
Total_Bits=0;
for i=1:N
    if QAM_alloc(i)~=0
        Total_Bits=Total_Bits+log2(QAM_alloc(i));
    end
end
%% Adaptive Modulation and NON-adaptive Modulation 
Nonz=nnz(QAM_alloc);
Symbols_AM=zeros(N,1,Block_Num);
Bits=randi(0:1,[1,N*Block_Num*log2(M)]);
Bits_AM=randi(0:1,[1,Total_Bits*Block_Num]);
Bits2=zeros(1,length(Bits)/log2(M));
for i=1:log2(M):length(Bits)
    Bits2(1+(i-1)/log2(M))=bin2dec(num2str(Bits(i:i+log2(M)-1)));
end
if M==2
    Bits3=qammod(Bits2,M);
end
Symbols=reshape(Bits3,N,1,Block_Num);
Index=1;
for count=1:Block_Num
    for i=1:N
        if QAM_alloc(i)==0
            Symbols_AM(i,:,count)=0;
        elseif QAM_alloc(i)==2
            B=bin2dec(num2str(Bits_AM(Index)));
            Symbols_AM(i,:,count)=qammod(B,2);
            Index=Index+1;
        elseif QAM_alloc(i)==4
            B=bin2dec(num2str(Bits_AM(Index:Index+1)));
            Symbols_AM(i,:,count)=qammod(B,4)*sqrt(0.5);
            Index=Index+2;
        elseif QAM_alloc(i)==16
            B=bin2dec(num2str(Bits_AM(Index:Index+3)));
            Symbols_AM(i,:,count)=qammod(B,16)*sqrt(1/10);
            Index=Index+4;
        else
            B=bin2dec(num2str(Bits_AM(Index:Index+7)));
            Symbols_AM(i,:,count)=qammod(B,64)*sqrt(1/42);
            Index=Index+8;
        end
    end
end
%% Power Adaptation 
Symbols_AM=Power_alloc.*Symbols_AM;
Symbols=Symbols*sum(abs(Symbols_AM(:,:,count)))/N;
%% Channel
nr=randn(N,1,Block_Num);
ni=randn(N,1,Block_Num);
Noise=(sqrt(2)/2)*(nr+1i*ni);
Symbols1_AM=zeros(size(Symbols_AM));
Symbols1=zeros(size(Symbols));
for count=1:Block_Num
    Symbols1_AM(:,:,count)=D*Symbols_AM(:,:,count)+Noise(:,:,count);
    Symbols1(:,:,count)=D*Symbols(:,:,count)+Noise(:,:,count);
end
%% Equalization 
G=pinv(D);
Symbols2_AM=zeros(size(Symbols1_AM));
Symbols2=zeros(size(Symbols1));
for count=1:Block_Num
    Symbols2_AM(:,:,count)=G*Symbols1_AM(:,:,count);
    Symbols2(:,:,count)=G*Symbols1(:,:,count);
end
%% Demodulation
Bitsre=zeros(size(Bits));
if M==2
    Symbols3=qamdemod(Symbols2,M);
end
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
Index=1;
Symbols2_AM=Symbols2_AM./Power_alloc;
Bitsre_AM=zeros(size(Bits_AM));
for count=1:Block_Num
    for i=1:N
        if QAM_alloc(i)==2
            A=qamdemod(Symbols2_AM(i,:,count),2);
            dec=dec2bin(A,1);
            Bitsre_AM(Index)=str2double(dec);
            Index=Index+1;
        elseif QAM_alloc(i)==4
            A=qamdemod(Symbols2_AM(i,:,count),4);
            dec=dec2bin(A,2);
            Bitsre_AM(Index)=str2double(dec(1));
            Bitsre_AM(Index+1)=str2double(dec(2));
            Index=Index+2;
        elseif QAM_alloc(i)==16
            A=qamdemod(Symbols2_AM(i,:,count),16);
            dec=dec2bin(A,4);
            for n=1:length(dec)
                Bitsre_AM(Index+n)=str2double(dec(n));
            end
            Index=Index+4;
        elseif QAM_alloc(i)==64
            A=qamdemod(Symbols2_AM(i,:,count),64);
            dec=dec2bin(A,8);
            for n=1:length(dec)
                Bitsre_AM(Index+n)=str2double(dec(n));
            end
            Index=Index+8;
        else
            disp('')
        end
    end
end

%% Error Counting 
