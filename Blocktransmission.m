%suppose channel length is L=1%
%we group serial u(n) into size of P=10, each u(n) is of length 12%
P=5;L=1;l=8;N=4;
u=randi(0:1,[P,l]);
u1=randi(0:1,[P,l]);  %previous block%
h=randn(1,2)+1i*rand(1,2);
nr=randi(0:1,[P,l]);
ni=randi(0:1,[P,l]);
Noise=(sqrt(2)/2)*(nr+1i*ni);
%we define H0 and H1 as, for L=1%
H0=[h(1),0,0,0,0;
    h(2),h(1),0,0,0;       
    0,h(2),h(1),0,0;
    0,0,h(2),h(1),0;
    0,0,0,h(2),h(1)];
   
H1=[0,0,0,0,h(2);
    0,0,0,0,0;       
    0,0,0,0,0;
    0,0,0,0,0;
    0,0,0,0,0];

X0=H0*u+H1*u1+Noise;%without guard%

T=[0,0,0,1;
   1,0,0,0;       
   0,1,0,0;
   0,0,1,0;
   0,0,0,1]; %guard insertion matrix%

ug=randi(0:1,[N,l]);
ug1=randi(0:1,[N,l]);  %previous block for N*1 matrix with guard insertion later%

Xg=H0*T*ug+H1*T*ug1+Noise;%with guard, P is used to transmit N%%

%Option1, insert Guard and remove at the receiver with receiver matrix%
%Define the receive-matrix with which we premultiply%
R=[0,1,0,0,0;
   0,0,1,0,0;       
   0,0,0,1,0;
   0,0,0,0,1;]; %and R*H1 will result in zero%

Xf=R*Xg; %ISI has been eliminated%
h=R*H0*T;%N*N circulant matrix
%Option2, zero-paddled guard insertion matrix%

T2=[1,0,0,0;       
    0,1,0,0;
    0,0,1,0;
    0,0,0,1;
    0,0,0,0;]; %In this case T2*H1=0%

Xi=H0*T2*ug+H1*T2*ug1+Noise; h2=H0*T2;

%We need to time alias this 

R2=[1,0,0,0,1;
   0,1,0,0,0;       
   0,0,1,0,0;
   0,0,0,1,0;];

Xi=R2*Xi;










