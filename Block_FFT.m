function X_3=Block_FFT(X_2,N,IFFT,Num)
%Initialze the FFT matrix 
F=conj(IFFT);
X_3=zeros(N,1,Num);
% DFT matrix normalised by 1/sqrt(N)
for count=1:Num
    X_3(:,:,count)=F*X_2(:,:,count);
end