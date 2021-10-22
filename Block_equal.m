function X_4=Block_equal(X_3,P,N,H0)
S=eye(N);
T=[S(2*N-P+1:N,:);S]; 
R=[zeros(N,P-N),eye(N)];
H=R*H0*T;

i=1;
F=zeros(N);
F_inv=zeros(N);
while i<N+1
    j=1;
    while j<N+1
        F(i,j)=exp(-1i*2*pi*(i-1)*(j-1)/N);
        F_inv(i,j)=exp(1i*2*pi*(i-1)*(j-1)/N);
        j=j+1;
    end
    i=i+1;  
end
F=F*1/sqrt(N);
F_inv=F_inv*1/sqrt(N);

D=F*H*F_inv;  %Normalise with N
count=1;
while count<length(X_3)
    sample=X_3(count:count+N-1); %Zero-forcing equalizer
    K(count:count+N-1)=sample./diag(D).';%pinv(D)*sample.';
    count=count+N;
end
X_4=K;
end