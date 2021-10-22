function X_2=Block_Receive(X,N,P)
R=[zeros(N,P-N),eye(N)]; % Define the receiving matrix 
i=1; %The index number of Input
j=1; %Output index
while i<length(X)
    X_2(j:j+N-1)=R*X(i:i+P-1).';
    i=i+P;
    j=j+N;
end
