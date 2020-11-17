function sfc = getSfc(n, shr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if n==1 % (no divestiture)
    sfc = [shr(1)+shr(2)+shr(3); % share of merged in All-fam
           shr(4)+shr(5); % share of merged in Kids
           0; % share of merged in Adult
           
           0; % share of Post in All-fam
           shr(10);
           shr(9)+shr(11);
           
           shr(14); % share of Quaker in All-fam
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7); % share of Private in All-fam
           0;
           shr(8)];

elseif n == 13 % Post = 3, makes products 9,10,11
    sfc = [shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           shr(1);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 14 % Quaker = 4, makes products 12,13,14
    sfc = [shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 15 % Private = 5, makes products 6,7,8
    sfc = [shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 23
    sfc = [shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           shr(2);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 24
    sfc = [shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(2)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 25
    sfc = [shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(2)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 33
    sfc = [shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           shr(3);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 34
    sfc = [shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(3)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 35
    sfc = [shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(3)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 123
    sfc = [shr(3);
           shr(4)+shr(5);
           0;
           
           shr(1)+shr(2);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 124
    sfc = [shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(2)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 125
    sfc = [shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(2)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 133
    sfc = [shr(2);
           shr(4)+shr(5);
           0;
           
           shr(1)+shr(3);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 134
    sfc = [shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(3)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 135
    sfc = [shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(3)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 233
    sfc = [shr(1);
           shr(4)+shr(5);
           0;
           
           shr(2)+shr(3);
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 234
    sfc = [shr(1);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(2)+shr(3)+shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 235
    sfc = [shr(1);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(2)+shr(3)+shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 10
    sfc = [shr(1); % firm 0
           0;
           0;
           
           shr(2)+shr(3); % merged firm
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 20
    sfc = [shr(2); % firm 0
           0;
           0;
           
           shr(1)+shr(3); % merged firm
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 30
    sfc = [shr(3); % firm 0
           0;
           0;
           
           shr(1)+shr(2); % merged firm
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 120 % same as pre-merger
    sfc = [shr(1)+shr(2);
           0;
           0;
           
           shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 130
    sfc = [shr(1)+shr(3); % firm 0
           0;
           0;
           
           shr(2); % merged firm
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 230
    sfc = [shr(2)+shr(3); % firm 0
           0;
           0;
           
           shr(1); % merged firm
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];
end

end

