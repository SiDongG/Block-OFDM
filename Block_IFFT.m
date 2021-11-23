function [Symbols_2,F_inv]=Block_IFFT(Symbols,N,Num)
%Initialize the Inverse Discrete Fourier Matrix 
F_inv=zeros(N);
for a=1:N
    for b=1:N
        F_inv(a,b)=exp(1i*2*pi*(a-1)*(b-1)/N);
    end 
end
F_inv=F_inv*1/sqrt(N);
Symbols_2=zeros(size(Symbols));
% IDFT matrix normalised by 1/sqrt(N)
for count=1:Num
    sample=F_inv*Symbols(:,:,count); 
    Symbols_2(:,:,count)=sample;
end