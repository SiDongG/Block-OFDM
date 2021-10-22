function X=Block_CP(H0,H1,Symbols_2,SNR,N,P)
L=length(Symbols_2);
nr=randn(1,2*L);
ni=randn(1,2*L);
%Noise=(1/sqrt(SNR))*(sqrt(2)/2)*(nr+1i*ni); %Generate Noise Sequence
%Noise=[0,0,-0.1501 + 0.6437i,-0.0823 - 0.1157i,-0.5120 - 0.1117i,-1.3094 + 0.5673i,-0.4807 - 0.4447i,-0.5509 - 0.2991i,0.4435 + 0.7797i,0.9355 - 0.9163i];
Noise=(sqrt(2)/2)*(nr+1i*ni);
S=eye(N);
T=[S(2*N-P+1:N,:);S]; %Generates the guard-insertion matrix
i=1; %The index number of Input
j=1; %Output index
while i<length(Symbols_2)
    Insertion1=T*Symbols_2(i:i+N-1).';
    if i==1
        Insertion2=zeros(P,1);
    else
        Insertion2=T*Symbols_2(i-N:i-1).';
    end
    sample=H0*Insertion1+H1*Insertion2+(1/sqrt(SNR))*Noise(j:j+P-1).';
    X(j:j+P-1)=sample;
    i=i+N;
    j=j+P;
end


