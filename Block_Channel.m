function [H0,H1]=Block_Channel(L_C,P)
%P=68; %Block Size%
h=(1/sqrt(2*(L_C+1)))*(randn(1,L_C)+1i*randn(1,L_C)); %Channel Length=2
%h=[-0.8629 + 1.8039i,-0.4592 - 0.4544i]
%h=randn(1,2)+1i*rand(1,2);
H0=zeros(P);
H1=zeros(P);
i=1;
while i<P+1
    j=1;
    while j<P+1
        if i-j<0 || i-j>L_C-1
            H0(i,j)=0;
        else
            H0(i,j)=h(i-j+1);
        end
        if P+i-j<0 || P+i-j>L_C-1
            H1(i,j)=0;
        else
            H1(i,j)=h(P+i-j+1);
        end
        j=j+1;
    end
    i=i+1;
end

end