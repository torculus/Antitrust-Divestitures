function [zero] = getCFprices(p, mc_hat, Omega, xbpx, alpha, sigma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

shr = getShareHat(alpha*p + xbpx, sigma);

g1shr = shr(1)+shr(2)+shr(3)+shr(6)+shr(7)+shr(14);
g2shr = shr(4)+shr(5)+shr(10)+shr(12)+shr(13);
g3shr = shr(8)+shr(9)+shr(11);

shrG = [shr(1)/g1shr; shr(2)/g1shr; shr(3)/g1shr; shr(4)/g2shr;
        shr(5)/g2shr; shr(6)/g1shr; shr(7)/g1shr; shr(8)/g3shr;
        shr(9)/g3shr; shr(10)/g2shr; shr(11)/g3shr; shr(12)/g2shr;
        shr(13)/g2shr; shr(14)/g1shr];

Dsdp = getShrDeriv(alpha,sigma,shr,shrG);

zero = p - mc_hat - (Omega .* Dsdp')\shr;
end

