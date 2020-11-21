function sfc = getSfc(n, shr)
%getSfc Gets the share of each firm in each category

if n==1 % (no divestiture)
    sfc = [0;0;0;
           
           shr(1)+shr(2)+shr(3); % share of merged in All-fam
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
    sfc = [0;0;0;
           
           shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           shr(1); % 1 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 14 % Quaker = 4, makes products 12,13,14
    sfc = [0;0;0;
           
           shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(14); % 1 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 15 % Private = 5, makes products 6,7,8
    sfc = [0;0;0;
           
           shr(2)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(6)+shr(7); % 1 goes to 5
           0;
           shr(8)];

elseif n == 23
    sfc = [0;0;0;
           
           shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           shr(2); % 2 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 24
    sfc = [0;0;0;
           
           shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(2)+shr(14); % 2 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 25
    sfc = [0;0;0;
           
           shr(1)+shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(2)+shr(6)+shr(7); % 2 goes to 5
           0;
           shr(8)];

elseif n == 33
    sfc = [0;0;0;
           
           shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           shr(3); % 3 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 34
    sfc = [0;0;0;
           
           shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(3)+shr(14); % 3 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 35
    sfc = [0;0;0;
           
           shr(1)+shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(3)+shr(6)+shr(7); % 3 goes to 5
           0;
           shr(8)];

elseif n == 123
    sfc = [0;0;0;
           
           shr(3);
           shr(4)+shr(5);
           0;
           
           shr(1)+shr(2); % 1,2 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 124
    sfc = [0;0;0;
           
           shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(2)+shr(14); % 1,2 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 125
    sfc = [0;0;0;
           
           shr(3);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(2)+shr(6)+shr(7); % 1,2 goes to 5
           0;
           shr(8)];

elseif n == 133
    sfc = [0;0;0;
           
           shr(2);
           shr(4)+shr(5);
           0;
           
           shr(1)+shr(3); % 1,3 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 134
    sfc = [0;0;0;
           
           shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(1)+shr(3)+shr(14); % 1,3 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 135
    sfc = [0;0;0;
           
           shr(2);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(1)+shr(3)+shr(6)+shr(7); % 1,3 goes to 5
           0;
           shr(8)];

elseif n == 233
    sfc = [0;0;0;
           
           shr(1);
           shr(4)+shr(5);
           0;
           
           shr(2)+shr(3); % 2,3 goes to 3
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 234
    sfc = [0;0;0;
           
           shr(1);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(2)+shr(3)+shr(14); % 2,3 goes to 4
           shr(12)+shr(13);
           0;
           
           shr(6)+shr(7);
           0;
           shr(8)];

elseif n == 235
    sfc = [0;0;0;
           
           shr(1);
           shr(4)+shr(5);
           0;
           
           0;
           shr(10);
           shr(9)+shr(11);
           
           shr(14);
           shr(12)+shr(13);
           0;
           
           shr(2)+shr(3)+shr(6)+shr(7); % 2,3 goes to 5
           0;
           shr(8)];

elseif n == 10
    sfc = [shr(1); % firm 0 gets 1
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
    sfc = [shr(2); % firm 0 gets 2
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
    sfc = [shr(3); % firm 0 gets 3
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
    sfc = [shr(1)+shr(2); % firm 0 gets 1,2
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
    sfc = [shr(1)+shr(3); % firm 0 gets 1,3
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
    sfc = [shr(2)+shr(3); % firm 0 gets 2,3
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

