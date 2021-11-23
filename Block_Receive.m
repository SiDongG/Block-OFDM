function X_2=Block_Receive(X,N,P,Num)
R=[zeros(N,P-N),eye(N)]; % Define the receiving matrix 
X_2=zeros(N,1,Num);
for a=1:Num
    X_2(:,:,a)=R*X(:,:,a);
end
