function Dsdp = getShrDeriv(alpha, sigma, shr, shrG)
%UNTITLED2 Gets the derivative matrix (∂s/∂p)
%   Detailed explanation goes here

J=14;
% categories of each product. All-fam=1, Kids=2, Adults=3
catgs = [1 1 1 2 2 1 1 3 3 2 3 2 2 1];

Dsdp = zeros(J,J);
for j=1:J
    for k=1:J
        if k==j
            Dsdp(j,k) = -alpha*shr(j)* ...
                (1/(1-sigma) - sigma/(1-sigma)*shrG(j) - shr(j) );
        else
            if catgs(j) == catgs(k)
                Dsdp(j,k) = alpha*shr(k)* ...
                    (sigma/(1-sigma)*shrG(j) + shr(j) );
            else
                Dsdp(j,k) = alpha * shr(j)*shr(k);
            end
        end
    end
end

end

