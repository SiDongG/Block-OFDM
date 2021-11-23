function y = constructifft(N)
y = zeros(N,N);
for k = 0:N-1
    for n = 0:N-1
        y(k+1,n+1) = exp(1j*2*pi*k*n/N);
    end
end
y = y./sqrt(N);
end