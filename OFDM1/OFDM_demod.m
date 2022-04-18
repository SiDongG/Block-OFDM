%Demodulation MQAM
function Bits=OFDM_demod(Symbols,SBR)
count=1;
if SBR==2
    while count<length(Symbols)+1
        if real(Symbols(count))>0 && imag(Symbols(count))>0
            Bits(count*2-1)=0;
            Bits(count*2)=0;
        end
        if real(Symbols(count)) <0 && imag(Symbols(count))>0
            Bits(count*2-1)=0;
            Bits(count*2)=1;
        end
        if real(Symbols(count)) <0 && imag(Symbols(count))<0
            Bits(count*2-1)=1;
            Bits(count*2)=1;
        end
        if real(Symbols(count)) >0 && imag(Symbols(count))<0
            Bits(count*2-1)=1;
            Bits(count*2)=0;
        end
        count=count+1;
    end
end
if SBR==3
    while count<length(Symbols)+1
        if real(Symbols(count))>2/sqrt(6) && imag(Symbols(count))>0
            Bits(count*3-2)=0;
            Bits(count*3-1)=0;
            Bits(count*3)=0;
        end
        if real(Symbols(count))>0 && imag(Symbols(count))>0 && real(Symbols(count))<2/sqrt(6)
            Bits(count*3-2)=0;
            Bits(count*3-1)=0;
            Bits(count*3)=1;
        end
        if real(Symbols(count))>-2/sqrt(6) && imag(Symbols(count))>0 && real(Symbols(count))<0
            Bits(count*3-2)=0;
            Bits(count*3-1)=1;
            Bits(count*3)=1;
        end
        if real(Symbols(count))<-2/sqrt(6) && imag(Symbols(count))>0
            Bits(count*3-2)=0;
            Bits(count*3-1)=1;
            Bits(count*3)=0;
        end
        if real(Symbols(count))>2/sqrt(6) && imag(Symbols(count))<0
            Bits(count*3-2)=1;
            Bits(count*3-1)=0;
            Bits(count*3)=0;
        end
        if real(Symbols(count))>0 && imag(Symbols(count))<0 && real(Symbols(count))<2/sqrt(6)
            Bits(count*3-2)=1;
            Bits(count*3-1)=0;
            Bits(count*3)=1;
        end
        if real(Symbols(count))>-2/sqrt(6) && imag(Symbols(count))<0 && real(Symbols(count))<0
            Bits(count*3-2)=1;
            Bits(count*3-1)=1;
            Bits(count*3)=1;
        end
        if real(Symbols(count))<-2/sqrt(6) && imag(Symbols(count))<0
            Bits(count*3-2)=1;
            Bits(count*3-1)=1;
            Bits(count*3)=0;
        end
        count=count+1;
    end
end
if SBR==4
    while count<length(Symbols)+1
        if real(Symbols(count))>2/sqrt(10) && imag(Symbols(count))>2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=0;
            Bits(count*4-1)=0;
            Bits(count*4)=0;
        end
        if real(Symbols(count))>0 && imag(Symbols(count))>2/sqrt(10) && real(Symbols(count))<2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=0;
            Bits(count*4-1)=0;
            Bits(count*4)=1;
        end
        if real(Symbols(count))>-2/sqrt(10) && imag(Symbols(count))>2/sqrt(10) && real(Symbols(count))<0
            Bits(count*4-3)=0;
            Bits(count*4-2)=0;
            Bits(count*4-1)=1;
            Bits(count*4)=1;
        end
        if real(Symbols(count))<-2/sqrt(10) && imag(Symbols(count))>2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=0;
            Bits(count*4-1)=1;
            Bits(count*4)=0;
        end
        if real(Symbols(count))<-2/sqrt(10) && imag(Symbols(count))>0 && imag(Symbols(count))<2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=1;
            Bits(count*4-1)=1;
            Bits(count*4)=0;
        end
        if real(Symbols(count))<0 && imag(Symbols(count))>0 && real(Symbols(count))>-2/sqrt(10) && imag(Symbols(count))<2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=1;
            Bits(count*4-1)=1;
            Bits(count*4)=1;
        end
        if real(Symbols(count))>0 && imag(Symbols(count))>0 && real(Symbols(count))<2/sqrt(10) && imag(Symbols(count))<2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=1;
            Bits(count*4-1)=0;
            Bits(count*4)=1;
        end
        if real(Symbols(count))>2/sqrt(10) && imag(Symbols(count))>0 && imag(Symbols(count))<2/sqrt(10)
            Bits(count*4-3)=0;
            Bits(count*4-2)=1;
            Bits(count*4-1)=0;
            Bits(count*4)=0;
        end
        if real(Symbols(count))>2/sqrt(10) && imag(Symbols(count))<0 && imag(Symbols(count))>-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=1;
            Bits(count*4-1)=0;
            Bits(count*4)=0;
        end
        if real(Symbols(count))<2/sqrt(10) && imag(Symbols(count))>-2/sqrt(10) && real(Symbols(count))>0 && imag(Symbols(count))<0 
            Bits(count*4-3)=1;
            Bits(count*4-2)=1;
            Bits(count*4-1)=0;
            Bits(count*4)=1;
        end
        if real(Symbols(count))<0 && imag(Symbols(count))<0 && real(Symbols(count))>-2/sqrt(10) && imag(Symbols(count))>-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=1;
            Bits(count*4-1)=1;
            Bits(count*4)=1;
        end
        if real(Symbols(count))<-2/sqrt(10) && imag(Symbols(count))<0 && imag(Symbols(count))>-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=1;
            Bits(count*4-1)=1;
            Bits(count*4)=0;
        end
        if real(Symbols(count))<-2/sqrt(10) && imag(Symbols(count))<-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=0;
            Bits(count*4-1)=1;
            Bits(count*4)=0;
        end
        if real(Symbols(count))>-2/sqrt(10) && real(Symbols(count))<0 && imag(Symbols(count))<-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=0;
            Bits(count*4-1)=1;
            Bits(count*4)=1;
        end
        if real(Symbols(count))>0 && real(Symbols(count))<2/sqrt(10) && imag(Symbols(count))<-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=0;
            Bits(count*4-1)=0;
            Bits(count*4)=1;
        end
        if real(Symbols(count))>2/sqrt(10) && imag(Symbols(count))<-2/sqrt(10)
            Bits(count*4-3)=1;
            Bits(count*4-2)=0;
            Bits(count*4-1)=0;
            Bits(count*4)=0;
        end
        count=count+1;
    end
end
        