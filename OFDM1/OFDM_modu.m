%MQAM modulation
function Symbols=OFDM_modu(Bits,SBR)
count=1;
if SBR==2
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
if SBR==3
    while count<length(Bits)
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==0)
            Symbols((count+2)/3)=(3+1i)/sqrt(6);
        end
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==1)
            Symbols((count+2)/3)=(1+1i)/sqrt(6);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==1)
            Symbols((count+2)/3)=(-1+1i)/sqrt(6);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==0)
            Symbols((count+2)/3)=(-3+1i)/sqrt(6);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==0)
            Symbols((count+2)/3)=(-3-1i)/sqrt(6);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==1)
            Symbols((count+2)/3)=(-1-1i)/sqrt(6);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==1)
            Symbols((count+2)/3)=(1-1i)/sqrt(6);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==0)
            Symbols((count+2)/3)=(3-1i)/sqrt(6);
        end
        count=count+3;
    end
end
if SBR==4
    while count<length(Bits)
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==0 && Bits(count+3)==0)
            Symbols((count+3)/4)=(3+3i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==0 && Bits(count+3)==1)
            Symbols((count+3)/4)=(1+3i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==1 && Bits(count+3)==1)
            Symbols((count+3)/4)=(-1+3i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==0 && Bits(count+2)==1 && Bits(count+3)==0)
            Symbols((count+3)/4)=(-3+3i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==1 && Bits(count+3)==0)
            Symbols((count+3)/4)=(-3+1i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==1 && Bits(count+3)==1)
            Symbols((count+3)/4)=(-1+1i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==0 && Bits(count+3)==1)
            Symbols((count+3)/4)=(1+1i)/sqrt(10);
        end
        if (Bits(count)==0 && Bits(count+1)==1 && Bits(count+2)==0 && Bits(count+3)==0)
            Symbols((count+3)/4)=(3+1i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==0 && Bits(count+3)==0)
            Symbols((count+3)/4)=(3-1i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==0 && Bits(count+3)==1)
            Symbols((count+3)/4)=(1-1i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==1 && Bits(count+3)==1)
            Symbols((count+3)/4)=(-1-1i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==1 && Bits(count+2)==1 && Bits(count+3)==0)
            Symbols((count+3)/4)=(-3-1i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==1 && Bits(count+3)==0)
            Symbols((count+3)/4)=(-3-3i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==1 && Bits(count+3)==1)
            Symbols((count+3)/4)=(-1-3i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==0 && Bits(count+3)==1)
            Symbols((count+3)/4)=(1-3i)/sqrt(10);
        end
        if (Bits(count)==1 && Bits(count+1)==0 && Bits(count+2)==0 && Bits(count+3)==0)
            Symbols((count+3)/4)=(3-3i)/sqrt(10);
        end
        count=count+4;
    end
end

        

    