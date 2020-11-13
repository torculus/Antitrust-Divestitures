%%%%%%%%%%%%%%%%%%%%%%%%%%% Setup Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; clc;
% get dataset
table = readtable('data.csv', 'VariableNamingRule', 'preserve');
data = table2array( table(:,2:104) );

q_jrt = data(:,41).*data(:,40); % servings = units * product size
p_jrt = data(:,45).*data(:,50)./data(1,50); % CPI (à la Miller-Weinberg)
n = length(q_jrt);

markSize = data(:,64)*7; % city population * 1 serving/day * 7 days
s_jrt = q_jrt ./ markSize;

% pesky element that's 0 to machine precision
s_jrt(127942) = 0.001;

% Inside and outside good share
marketID = data(:,65); % unique consecutive integer market identifier
productID = data(:,74);

%markSize = zeros(n,1);
%for i=1:max(marketID)
%    markSize(marketID==i) = 2 * max(q_jrt(marketID==i));
%end
%s_jrt = q_jrt ./ markSize;

days_in_mo = data(:,66);
Nprods_in_mkt = zeros(n,1);
inshare = zeros(n,1);

for i=1:max(marketID)
    % set inshare = sum of shares in each market
    inshare(marketID==i) = sum(s_jrt(marketID==i));
    
    % set prods_in_mkt = number of unique products in that market
    Nprods_in_mkt(marketID==i) = length(unique(productID(marketID==i)));
end
inshare = inshare ./days_in_mo;
s_0rt = 1 - inshare;
s_jrt = s_jrt ./days_in_mo;

%Y = zeros(14,1);
%for i=1:max(marketID)
%    r = length(unique(productID(marketID==i)));
%    if r==14
%        Y = [Y unique(productID(marketID==i))];
%    else
%        Y = [Y [unique(productID(marketID==i)); zeros(14-r,1)] ];
%    end
%end

% time fixed effects
timeFE = data(:,3:10); %isQ1 isQ2 isQ3 isQ4 is09 is10 is11 is12
quartFE = data(:,4:6); %isQ2 isQ3 isQ4
yearFE = data(:,8:10); %is10 is11 is12

% State/regional fixed effects
stateFE = data(:,13:15); %isKY isOH isTX

% product fixed effects
prodFE = data(:,18:25); % dummies for products 1-8

% manufacturer fixed effects
manFE = data(:,32:35); % GM, Kellogg, Post, Quaker, (Private omittted)

% category fixed effects
catFE = data(:,38:39); %isKids isAllfam

% product display fixed effects
dispFE = data(:,47); % part of in-store circular, in-store promotional
% display, shelf-tag temporary price reduction

% product characteristics variables
characs = [ones(n,1) data(:,51:58)]; % constant, calories, sugars, carbo,
    %  protein, fat, sodium, fiber, potassium

% demographic variables
%faminc = data(:,59); famsq = faminc.^2;
%child35 = data(:,60);
%child613 = data(:,61);
%child1417 = data(:,62);
%age = data(:,63);

% input prices
W_krt = data(:,67:73); % sugar, paperboard, labor, corn, rice, wheat, oats

%%%%%%%%%%%%%%%%%%%%%%%%% Demand Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%

% get eta_jrt
temp = [W_krt prodFE manFE];
gammaTemp = (temp'*temp)\temp'*p_jrt;
eta_jrt = p_jrt - temp*gammaTemp;
clear temp gammaTemp;

% get BLP instruments
BLPsums = data(:,85:92);
BLPavgs = data(:,93:100);

% get Hausman instruments
Haus1 = data(:,101); % same market, avg price of other products
Haus2 = data(:,102); % same product, avg price of other locations

% Berry's NL share inversion
delta_jrt = log(s_jrt) - log(s_0rt);

X = [p_jrt characs log(s_jrt./inshare)];
Z = [quartFE yearFE prodFE stateFE eta_jrt BLPsums BLPavgs dispFE];

% get 2SLS results
W = (Z'*Z) \ eye(size(Z,2));
beta_2sls = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% re-compute with optimal weight matrix
xi = delta_jrt - X*beta_2sls;
W = ( (Z'*xi)*(xi'*Z) ) \ eye(size(Z,2));
beta_2sls = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

%%%%%%%%%%%%%%%%%%%%%%% group-nest specification

g1 = [1,2,3,6,7,14]; % All-family
g2 = [4,5,10,12,13]; % Kids
g3 = [8,9,11]; % Adult
g1shr = zeros(n,1);
g2shr = zeros(n,1);
g3shr = zeros(n,1);

for i=1:max(marketID)
    % set group shares = sum of shares in each group across markets
    g1shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g1)));
    g2shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g2)));
    g3shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g3)));
end

% form a vector of within-group shares
s_jrtG = zeros(n,1);
cond1 = ismember(productID,g1);
s_jrtG(cond1) = s_jrt(cond1)./g1shr(cond1);
cond2 = ismember(productID,g2);
s_jrtG(cond2) = s_jrt(cond2)./g1shr(cond2);
cond3 = ismember(productID,g3);
s_jrtG(cond3) = s_jrt(cond3)./g1shr(cond3);
clear g1 g2 g3 g1shr g2shr g3shr cond1 cond2 cond3;

X = [p_jrt characs log(s_jrtG)];

W = (Z'*Z) \ eye(size(Z,2));
beta_2G = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% re-compute with optimal weight matrix
xi = delta_jrt - X*beta_2G;
W = ( (Z'*xi)*(xi'*Z) ) \ eye(size(Z,2));
beta_2G = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

%%%%%%%%%%%%%%%%%%%%%% Supply Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%
J = 14; % number of products
alpha = beta_2G(1);
sigma = abs( beta_2G(end) );

params = [alpha; sigma];

% grab data at simulated merger date (2010 month 8)
merge_date = ismember(marketID,970:1020);

% average price, share, group share, and mean utility of each product at
% the simulated merger date
prc = zeros(J,1);
shr = zeros(J,1);
shrG = zeros(J,1);
delta_merge = zeros(J,1);
for i=1:J
    prc(i) = mean(p_jrt(merge_date & productID==i));
    shr(i) = mean(s_jrt(merge_date & productID==i));
    shrG(i) = mean(s_jrtG(merge_date & productID==i));
    delta_merge(i) = mean(delta_jrt(merge_date & productID==i));
end

%xi_merge = delta_merge - alpha * prc;

Dsdp = getShrDeriv(alpha, sigma, shr, shrG);

% pre-merger is = firm 1,2 merging and divesting 1,2
Omega0 = getOmega(120);

% calculate pre-merger marginal costs
mc_hat = prc - (Omega0 .* Dsdp') \ shr;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Divestitures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 13 = product 1 goes to firm 3, 235 = products {2,3} go to firm 5
iter = [1 13 14 15 23 24 25 33 34 35 123 124 125 133 134 135 233 ...
    234 235 10 20 30 130 230];

CS = zeros(length(iter),1);
merger_prices = [];

for i=iter
    Omega = getOmega(i);
    
    % do DEA stuff
    
    p_post = getPpost(mc_hat, Omega, params, Dsdp, shr);
    
    merger_prices = [merger_prices, p_post];
end

%%%%%%%%%%%%%%%%%%%%%% DEA Efficiency Gains %%%%%%%%%%%%%%%%%%%%%%%%%%%

s_fc = [shr(1)+shr(2), 0, 0;
        shr(3), shr(4)+shr(5), 0;
        0, shr(10), shr(9)+shr(11);
        shr(14), shr(12)+shr(13), 0;
        shr(6)+shr(7), 0, shr(8)];

%y_fc = markSize .* s_fc;
y_fc = s_fc;

% regress mc_hat = inputs'*\gamma + Supply FE's + error

temp = [W_krt quartFE yearFE stateFE prodFE];
XS = zeros(J,size(temp,2) );

for i=1:J
    XS(i,:) = mean(temp(merge_date & productID==i,:));
end
clear i;

rho_hat = (XS'*XS)\(XS'*mc_hat);

x_fc = rho_hat .* y_fc;

Eu = 3;

% get new estimated marginal costs with efficiency gains
mc_hat(merging==1,:) = (1 - Eu).* inputs .* gamma_hat .* mc_hat;

ConsSurp = 1/abs(alpha) * sum(exp(delta_hat));




