function [shr] = getShareHat(delta, sigma)
%SHARE Calculates the estimated nested logit market shares for prods 1:J
J = 14;
shr = zeros(J,1);

Dgrt = zeros(4,1);
Dgrt(1) = exp(delta(1)/(1-sigma))+exp(delta(2)/(1-sigma))+...
            exp(delta(3)/(1-sigma))+exp(delta(6)/(1-sigma))+...
            exp(delta(7)/(1-sigma))+exp(delta(14)/(1-sigma));
        
Dgrt(2) = exp(delta(4)/(1-sigma))+exp(delta(5)/(1-sigma))+...
            exp(delta(10)/(1-sigma))+exp(delta(12)/(1-sigma))+...
            exp(delta(13)/(1-sigma));
        
Dgrt(3) = exp(delta(8)/(1-sigma))+exp(delta(9)/(1-sigma))+...
            exp(delta(11)/(1-sigma));
        
Dgrt(4) = 1; % outside good delta_0rt = 0

D = sum( Dgrt.^(1-sigma) );

% categories of each product. All-fam=1, Kids=2, Adults=3
catgs = [1 1 1 2 2 1 1 3 3 2 3 2 2 1];

for j=1:J
    
    g = catgs(j);
    
    denom = Dgrt(g)^sigma * D;
    
    shr(j) = exp( delta(j)/(1-sigma) ) / denom;
end

end

