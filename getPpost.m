function p_post = getPpost(mc_hat, Omega, params, Dsdp, shr)
%UNTITLED Gets the counterfactual post-merger prices for prods 1:14
%   Detailed explanation goes here

tol = 1e-8;
maxiter = 1e6;

alpha = params(1); sigma = params(2);

p = mc_hat;

for iter=1:maxiter
    %delta = x'*beta-alpha*p+xi;
    %shr = getShareHat(delta, sigma);
    
    %g1shr = shr(1)+shr(2)+shr(3)+shr(6)+shr(7)+shr(14);
    %g2shr = shr(4)+shr(5)+shr(10)+shr(13)+shr(14);
    %g3shr = shr(8)+shr(9)+shr(11);
    
    %shrG = [shr(1)/g1shr; shr(2)/g1shr; shr(3)/g1shr; shr(4)/g2shr;
    %    shr(5)/g2shr; shr(6)/g1shr; shr(7)/g1shr; shr(8)/g3shr;
    %    shr(9)/g3shr; shr(10)/g2shr; shr(11)/g3shr; shr(12)/g2shr;
    %    shr(13)/g2shr; shr(14)/g1shr];
    
    %Dsdp = getShrDeriv(alpha, sigma, shr, shrG);
    
    % value function iteration loop
    p1 = mc_hat + (Omega .* Dsdp') \ shr;
    
    if norm(p1 - p) <= tol
        break
    else
        p = p1;
    end
end

if iter >= maxiter
    disp('Warning: maximum number of iterations exceeded');
end

p_post = p1;
end

