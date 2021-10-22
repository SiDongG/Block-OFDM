function Bitsr=Block_Demod(Symbols) 
Bitsr=zeros(1,6400);
count=1;
while count<length(Symbols)+1
        if real(Symbols(count))>0 && imag(Symbols(count))>0
            Bitsr(count*2-1)=0;
            Bitsr(count*2)=0;
        end
        if real(Symbols(count)) <0 && imag(Symbols(count))>0
            Bitsr(count*2-1)=0;
            Bitsr(count*2)=1;
        end
        if real(Symbols(count)) <0 && imag(Symbols(count))<0
            Bitsr(count*2-1)=1;
            Bitsr(count*2)=1;
        end
        if real(Symbols(count)) >0 && imag(Symbols(count))<0
            Bitsr(count*2-1)=1;
            Bitsr(count*2)=0;
        end
        count=count+1;
end

end