function X_3=Block_FFT(X_2,N)
%Initialze the FFT matrix 
i=1;
F=zeros(N);
while i<N+1
    j=1;
    while j<N+1
        F(i,j)=exp(-1i*2*pi*(i-1)*(j-1)/N);
        j=j+1;
    end
    i=i+1;  
end
%F=F*1/sqrt(N);
count=1; %Index Number
while count<length(X_2)
    sample=F*X_2(count:count+N-1).'; %Normalise the FFT by including the 1/N coefficient 
    X_3(count:count+N-1)=sample;
    count=count+N;
end