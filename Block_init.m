function [Bits,Symbols]=Block_init(L) 
Bits=randi(0:1,[1,L]);
count=1;
while count<length(Bits)
        if (Bits(count)==0 && Bits(count+1)==0)
            Symbols((count+1)/2)=(1+1i)/sqrt(2);
        end
        if (Bits(count)==0 && Bits(count+1)==1)
            Symbols((count+1)/2)=(-1+1i)/sqrt(2);
        end
        if (Bits(count)==1 && Bits(count+1)==1)
            Symbols((count+1)/2)=(-1-1i)/sqrt(2);
        end
        if (Bits(count)==1 && Bits(count+1)==0)
            Symbols((count+1)/2)=(1-1i)/sqrt(2);
        end
        count=count+2;
end

end