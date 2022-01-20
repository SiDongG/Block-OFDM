function X=Block_CP(H0,H1,Symbols_2,SNR,N,P,Num)
nr=randn(P,1,Num);
ni=randn(P,1,Num);
Noise=(sqrt(2)/2)*(nr+1i*ni);  %Generate Complex Noise the size as the bit-stream
S=eye(N);  %N=P-L_C
T=[S(2*N-P+1:N,:);S]; %Generates the guard-insertion matrix
X=zeros(P,1,Num);
for a=1:Num
    Insertion1=T*Symbols_2(:,:,a);
    if a==1
        Insertion2=zeros(P,1);
    else
        Insertion2=T*Symbols_2(:,:,a-1);
    end
    X(:,:,a)=H0*Insertion1+H1*Insertion2+(1/sqrt(SNR))*Noise(:,:,a);
end


