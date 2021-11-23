function X_4=Block_equal(X_3,P,N,H0,F_inv,Num)
S=eye(N);
T=[S(2*N-P+1:N,:);S]; 
R=[zeros(N,P-N),eye(N)];
H=R*H0*T;  %The actual received block after H1 is eliminated 
F=conj(F_inv);
X_4=zeros(N,1,Num);
D=F*H*F_inv;  %D is the diagonal matrix obtained by pre and post multiplying fft and ifft matrix
for count=1:Num
    X_4(:,:,count)=X_3(:,:,count)./diag(D);
end
