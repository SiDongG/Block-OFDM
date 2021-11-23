clear;clc;close all;

SNRdb = 10:  2 : 20; %SNR Range
siz = size(SNRdb,2); %SNR Range size
MM = 64; %Subcarrier Number
L = 4-1; %Channel Length
P = L + MM;
K = 128; %Block Number
M = 4; % Modulation type: 4QAM
r_num = 10; %Channel realization times
bit_num = log2(M) * MM * K;

raw_s=randsrc(1,bit_num,[0,1]);

Tcp = zeros(P,MM); % construct Tcp
Tcp(P-MM+1:P,:) = eye(MM);
Tcp(1:P-MM,(2*MM-P+1):MM) = eye(P-MM);
Rcp = zeros(MM,P); % construct Rcp
Rcp(:,P-MM+1:P) = eye(MM);

ifftmat = constructifft(MM); % ifft matrix
fftmat = conj(ifftmat); % fftmatrix
dftmat = exp(-1j * 2 * pi .* [0:MM-1].' * [0:L] / MM);

err_zf =zeros(1,siz);
Pe_zf =zeros(1,siz);

for rea=1:r_num
    
    %% Generate Channel h
    h = zeros(1,L+1); %Channel in time domain
    h(1,1:L+1) = (randn(1,L+1) + 1j*randn(1,L+1)).*sqrt(1/(2))/sqrt(L+1);
    h=h.';
    HH=dftmat*h; %Channel in frequency domain
    
    for i=1:K
        h1(:,i)=h(1:L+1);
    end
    
    for SNR_ind  = 1:siz % for different SNR
        
        SNR = db2pow(SNRdb(SNR_ind));
        N0 = 1/SNR;
        
        %% Sample bit into symbols
        bit_idx = 1;
        start = 1;
        for i=1:K
            for rec=1:MM
                s(start)=bin2dec(num2str(raw_s(bit_idx:bit_idx+log2(M)-1)));
                bit_idx=bit_idx+log2(M);
                start=start+1;
            end
        end
        
        %% Convert into block form
        ss=zeros(MM,K);
        for i=1:K
            ss(:,i)=s(1+(i-1)*(MM):i*(MM));
        end
        
        z=qammod(ss,M)*sqrt(0.5);
        
        %% ifft and Tcp
        u = ifftmat * z; % Inverse FFT
        u_bar = Tcp * u; % add Cyclic prefix
        
        %% Go through channel in block form
        x_bar = zeros(P+L,K);
        for jj = 1:K
            x_bar(:,jj) = conv(u_bar(:,jj).',h.').';
        end
        x_bar = x_bar(1:end-L,:);
        
        % Add noise
        eta_std = (randn(P,K) + 1j*randn(P,K));
        sigma = sqrt(N0/2);
        eta = eta_std.*sigma;
        
        x_noisy_bar = x_bar + eta;
        
        %% Rcp and FFT
        x_tilta = Rcp * x_noisy_bar;
        x = fftmat * x_tilta;
        
        %% ZF for channel equalization
        
        DH_vec = dftmat * h1;
        for i=1:K
            sz_hat_zf(:,i) = diag(1./DH_vec(:,i)) * x(:,i); % channel equalization
        end
        %% Demod and Desample
        s_hat_zf=qamdemod(sz_hat_zf/(sqrt(0.5)),M);
        
        %Desample the symbols into bits
        start=1;
        for i=1:K
            for rec=1:MM
                decnum=dec2bin(s_hat_zf(rec,i),log2(M));
                for j=1:log2(M)
                    decoded_rs(start)=str2double(decnum(j));
                    start=start+1;
                end
            end
        end
        
        err_zf(SNR_ind) = err_zf(SNR_ind) + sum(sum(decoded_rs~=raw_s)); % Calculate the total error number
    end
end

Pe_zf = err_zf / (bit_num * r_num); % Calculate the error rate

%% Plot figure

figure(1)
semilogy(SNRdb, Pe_zf, 'bx-');grid on; hold on
xlabel('SNR(dB)')
ylabel('BER')
