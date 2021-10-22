function Symbols_2=Block_IFFT(Symbols,N)
%Initialize the Inverse Discrete Fourier Matrix 
count=1;
i=1;
F_inv=zeros(N);
while i<N+1
    j=1;
    while j<N+1
        F_inv(i,j)=exp(1i*2*pi*(i-1)*(j-1)/N);
        j=j+1;
    end
    i=i+1;  
end
F_inv=F_inv*1/sqrt(N);
% IDFT matrix not normalised by 1/sqrt(N)
while count<length(Symbols)
    sample=(1/sqrt(N))*F_inv*Symbols(count:count+N-1).'; %Normalise the IFFT by including the 1/N coefficient 
    Symbols_2(count:count+N-1)=sample;
    count=count+N;
end