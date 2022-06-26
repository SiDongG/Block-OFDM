%% Variable Power Adaptive Modulation, Waterfilling 
%% Parameters 
clear; clc; close all;
N=16; %Number of Subcarrier
L=4; %Channel Length
Block_Num=100; %Block Number
C=4; %Len Cyclic Prefix 
M=16; %16-QAM
P=N+C;
S=eye(N);
T=[S(2*N-P+1:N,:);S];
R=[zeros(N,P-N),eye(N)];
Pb=1e-3;
K=-1.5/(log(5*Pb)); %Total fade depth Power Constraint 
yk=0.5;y0=yk*K;
Power=10;%Total Power Constraint 

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
%% Subcarrier Classification
D_img=diag(abs(D));
Avg=mean(D_img);
Ratio=D_img/yk;
Power_alloc=zeros(size(D_img));
for count=1:N
    if D_img(count)>=yk
        Power_alloc(count)=Power*(1/y0-1/(D_img(count)*K));
    else
        Power_alloc(count)=0;
    end
end

sum(Power_alloc)
bar(D_img)
hold on;
plot([0,18],[0.5,0.5])
figure
bar(Power_alloc)



