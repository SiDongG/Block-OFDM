%% Variable Power Adaptive Modulation, Waterfilling 
%% Parameters 
clear; clc; close all;
N=16; %Number of Subcarrier
L=4; %Channel Length
Block_Num=100; %Block Number
C=4; %Len Cyclic Prefix 
M=4; %4-QAM
P=N+C;
S=eye(N);
T=[S(2*N-P+1:N,:);S];
R=[zeros(N,P-N),eye(N)];
Pb=1e-3;
N_var=1;
SNR=100;
% K=-1.5/(log(5*Pb)); %Total fade depth Power Constraint 
% yk=0.5;y0=yk*K;
Power=N_var*SNR;%Average Power Constraint 
IFFT=zeros(N);
for a=1:N
    for b=1:N
        IFFT(a,b)=exp(1i*2*pi*(a-1)*(b-1)/N);
    end 
end
IFFT=IFFT*1/sqrt(N);
FFT=conj(IFFT);
%% Initialize the channel 
h=(1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
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
%% Power Allocation
D_img=diag(abs(D));
Avg=mean(D_img);
% y0=1/(1+1/(sum(D_img)));
% yk=y0/K;
% syms y
% S=vpasolve(sum(max(0,1./y-1./D_img))==P,y);
y0=0.8; %Initialize Threshold and iteratively search for power balance
Power_alloc=zeros(size(D_img));
while abs(sum(Power_alloc)-Power)>2
    for count=1:N
        if D_img(count)>=y0
            Power_alloc(count)=Power*(1/y0-1/(D_img(count)));
        else
            Power_alloc(count)=0;
        end
    end
    if sum(Power_alloc)>Power+2
        y0=y0+0.001;
    elseif sum(Power_alloc)<Power-2
        y0=y0-0.001;
    else
        y0=y0;
    end
    disp(sum(Power_alloc))
end

% bar(D_img)
% hold on;
% plot([0,16],[y0,y0])
% figure
% bar(Power_alloc)
%% Bits generation 
Bits=randi(0:1,[1,N*Block_Num*log2(M)]);
Bits2=zeros(1,length(Bits)/log2(M));
for i=1:log2(M):length(Bits)
    Bits2(1+(i-1)/log2(M))=bin2dec(num2str(Bits(i:i+log2(M)-1)));
end
%% Adaptive Modulation 
if M==4
    Bits3=qammod(Bits2,M)*sqrt(0.5);
end
Symbols=reshape(Bits3,N,1,Block_Num);
Symbols1_AM=Power_alloc.*Symbols;
%% Channel 
Symbols2_AM=zeros(size(Symbols1_AM));
Symbols2=zeros(size(Symbols));
Symbols=(sum(abs(Symbols1_AM(:,:,1)))/sum(abs(Symbols(:,:,1))))*Symbols;
nr=randn(N,1,Block_Num);
ni=randn(N,1,Block_Num);
Noise=(sqrt(2)/2)*(nr+1i*ni);
for count=1:Block_Num
    Symbols2_AM(:,:,count)=D*Symbols1_AM(:,:,count)+Noise(:,:,count);
    Symbols2(:,:,count)=D*Symbols(:,:,count)+Noise(:,:,count);
end
%% ZF Equalization 
G=pinv(D);
Symbols3_AM=zeros(size(Symbols2_AM));
Symbols3=zeros(size(Symbols2));
for count=1:Block_Num
    Symbols3_AM(:,:,count)=G*Symbols2_AM(:,:,count);
    Symbols3(:,:,count)=G*Symbols2(:,:,count);
end
%% Demodulation
Bitsre=zeros(size(Bits));
Bits_AM=zeros(size(Bits));
Symbols4_AM=zeros(size(Symbols3_AM));
Symbols4=zeros(size(Symbols3));
if M==4
    Symbols4_AM=qamdemod(Symbols3_AM,M);
    Symbols4=qamdemod(Symbols3,M);
end














