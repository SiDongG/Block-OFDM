%ISI white noise channel
function [H,S2,h,Noise]=OFDM_channel(Symbols,CPP,V)
h=randn(1,2)+1i*rand(1,2);
%h=[-0.8629 + 1.8039i,-0.4592 - 0.4544i];
count=1;
count1=1;
while count<length(Symbols)
    a=conv(h,Symbols(count:count+7+CPP));
    SP(count1:count1+7)=a(CPP+1:CPP+8);
    count=count+8+CPP;
    count1=count1+8;
end
nr=randn(1,length(SP));
ni=randn(1,length(SP));
Noise=(sqrt(2)/2)*(nr+1i*ni);
%Noise=[-0.1501 + 0.6437i,-0.0823 - 0.1157i,-0.5120 - 0.1117i,-1.3094 + 0.5673i,-0.4807 - 0.4447i,-0.5509 - 0.2991i,0.4435 + 0.7797i,0.9355 - 0.9163i];
S2=V*Noise+SP;%sqrt(8/(8+CPP))*SP; %Received Signal
%S=SP;
H=fft(h,8); %Estimated Channel Response



