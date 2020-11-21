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
quartFE = data(:,4:6); %isQ2 isQ3 isQ4 (isQ1 omitted)
yearFE = data(:,8:10); %is10 is11 is12 (is09 omitted)

% State/regional fixed effects
stateFE = data(:,13:15); %isKY isOH isTX (isIN omitted)

% product fixed effects
prodFE = data(:,18:25); % dummies for products 1-8

% manufacturer fixed effects
manFE = data(:,32:35); % GM, Kellogg, Post, Quaker, (Private omittted)

% category fixed effects
catFE = data(:,38:39); %isKids isAllfam (isAdult omitted)

% product display fixed effects
isDisp = data(:,47); % part of in-store circular
isFeat = data(:,48); % in-store promotional display
isTPR = data(:,49); % shelf-tag temporary price reduction

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
gammaTemp = (temp'*temp)\temp'*p_jrt; % p_jrt = temp*gammaTemp + eta_jrt
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

X = [p_jrt characs -log(s_jrt./inshare)];
Z = [quartFE yearFE prodFE stateFE eta_jrt BLPsums BLPavgs isDisp ...
    isFeat isTPR Nprods_in_mkt];

% get 2SLS results
W = (Z'*Z) \ eye(size(Z,2));
beta_2sls = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% re-compute with optimal weight matrix
xi = delta_jrt - X*beta_2sls;
W = ( (Z'*xi)*(xi'*Z) ) \ eye(size(Z,2));
beta_2sls = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% % get summary statistics
% df = n - size(X,2);
% s_hat   = xi'*xi/df; % Asymptotic covariance
% var_hat = s_hat./(X'*Z * W * Z'*X); % Estimated covariance matrix
% stderr  = sqrt(diag(var_hat)); % Standard errors
% t_stat  = beta_2sls./stderr; % t-ratios
% 
% % p-values
% pval_2s = betainc(df./(df+(1.*t_stat.^2)),(df./2),(1./2));

%%%%%%%%%%%%%%%%%%%%%%% group-nest specification

g1 = [1,2,3,6,7,14]; % All-family
g2 = [4,5,10,12,13]; % Kids
g3 = [8,9,11]; % Adult
g1shr = zeros(n,1);
g2shr = zeros(n,1);
g3shr = zeros(n,1);

Nprods_in_grp = zeros(n,1);

for i=1:max(marketID)
    % set group shares = sum of shares in each group across markets
    g1shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g1)));
    g2shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g2)));
    g3shr(marketID==i) = sum(s_jrt(marketID==i & ismember(productID,g3)));
    
    % set Nprods_in_grp = number of unique products in that market & group
    Nprods_in_grp(marketID==i & ismember(productID, g1) ) = ...
        length(unique(productID(marketID==i & ismember(productID,g1))));
    
    Nprods_in_grp(marketID==i & ismember(productID, g2) ) = ...
        length(unique(productID(marketID==i & ismember(productID,g2))));
    
    Nprods_in_grp(marketID==i & ismember(productID, g3) ) = ...
        length(unique(productID(marketID==i & ismember(productID,g3))));
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
Z = [quartFE yearFE prodFE stateFE eta_jrt BLPsums BLPavgs isDisp ...
    isFeat isTPR Nprods_in_grp];

W = (Z'*Z) \ eye(size(Z,2));
beta_2G = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% re-compute with optimal weight matrix
xi = delta_jrt - X*beta_2G;
W = ( (Z'*xi)*(xi'*Z) ) \ eye(size(Z,2));
beta_2G = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*delta_jrt);

% % get summary statistics
% df = n - size(X,2);
% s_hat   = xi'*xi/df; % Asymptotic covariance
% var_hat = s_hat./(X'*Z * W * Z'*X); % Estimated covariance matrix
% stderr  = sqrt(diag(var_hat)); % Standard errors
% t_stat  = beta_2sls./stderr; % t-ratios
% 
% % p-values
% pval_2g = betainc(df./(df+(1.*t_stat.^2)),(df./2),(1./2));

%%%%%%%%%%%%%%%%%%%%%% Supply Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%

J = 14; % number of products
alpha = abs( beta_2sls(1) );
sigma = abs( beta_2sls(end) );

params = [alpha; sigma];

XBPX = delta_jrt + alpha * p_jrt; % X*\beta plus xi

% grab data at simulated merger date (2010 month 8)
merge_date = ismember(marketID,970:1020);

% average price, share, group share, and mean utility of each product at
% the simulated merger date
prc = zeros(J,1);
shr = zeros(J,1);
shrG = zeros(J,1);
xbpx = zeros(J,1);
for i=1:J
    prc(i) = mean(p_jrt(merge_date & productID==i));
    shr(i) = mean(s_jrt(merge_date & productID==i));
    shrG(i) = mean(s_jrtG(merge_date & productID==i));
    xbpx(i) = mean(XBPX(merge_date & productID==i));
end

Dsdp = getShrDeriv(alpha, sigma, shr, shrG);

% get cross-price elasticity matrix
elas = kron(1./shr, prc') .* Dsdp;

% pre-merger is equivalent to firm 1,2 merging and divesting 1,2
Omega0 = getOmega(120);

% estimate pre-merger marginal costs
mc_hat = prc + (Omega0 .* Dsdp') \ shr;

% regress mc_hat = inputs'*\rho + Supply FE's + error
temp = [W_krt manFE prodFE];
R = zeros(J,size(temp,2) );
for i=1:J
    R(i,:) = mean(temp(merge_date & productID==i,:));
end
temp = (R'*R)\(R'*mc_hat);

rho_hat = temp(1:7);
clear i temp;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Divestitures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 13 = product 1 goes to firm 3, 235 = products {2,3} go to firm 5
iteration = [1 13 14 15 23 24 25 33 34 35 123 124 125 133 134 135 ...
    233 234 235 10 20 30 120 130 230]';

li = length(iteration);

merger_prices = zeros(J,li); % merger prices no efficiency gains
merger_pEffic = zeros(J,li); % merger prices with efficiency gains
mc_hat_effic = zeros(J,li); % store new mc with efficiencies

fval = zeros(li,2); % hold the function values from each iteration
flags = zeros(li,2); % hold the flags (1=converge, 0=iteration limit)

M = sum(markSize(merge_date));
g_krt = R(1,1:7);
CS = zeros(li,2);

Eu_store = zeros(li,1);

tic
for n=1:li
    iter = iteration(n);
    Omega = getOmega(iter);
    
    % set up optimization options
    optopts = optimoptions(@fsolve,'MaxIter',1500,'MaxFunEvals',...
        2500,'Disp','off','TolFun',1e-12);
    
    % set up to solve for p: p = mc_hat - (Omega * Dsdp')\shr(p)
    fun = @(p)getCFprices(p, mc_hat, Omega, xbpx, alpha, sigma);
    p0 = 2.5 .*ones(J,1)+3.*(rand(J,1)-0.5); % about 1-4 in each element
    
    % get counterfactual prices
    [CFP_NO_EFFIC,fvalout,flag] = fsolve(fun, p0, optopts);
    fval(n,1) = mean(fvalout);
    flags(n,1) = flag;
    
    merger_prices(:,n) = CFP_NO_EFFIC;
    
    % calculate Consumer Surplus without efficiency gains
    CS(n,1) = 1/abs(alpha) * sum(exp(xbpx - alpha*CFP_NO_EFFIC));
    
    %%%%%%%%%%%%%% DEA Efficiency Gains %%%%%%%%%%%%%%%%%%%%%
    % Note: requires DEAMATLAB toolbox to run
    Yfc = M .* getSfc(iter,shr);
    Xfc = kron(Yfc, rho_hat');
    
    % pool together all of the firm's inputs and outputs
    Yf = [sum(Yfc(1:3)); sum(Yfc(4:6)); sum(Yfc(7:9)); ...
            sum(Yfc(10:12)); sum(Yfc(13:15))];
    Xf = [sum(Xfc(1:3,:)); sum(Xfc(4:6,:)); sum(Xfc(7:9,:)); ...
            sum(Xfc(10:12,:)); sum(Xfc(13:15,:))];
    io = dea(Xf, Yf, 'orient', 'io');
    
    % get the efficiency measure for the merging firms
    Eu = io.eff(2);
    %Eu = 0.95; % 5% marginal cost reduction
    
    Eu_store(n) = Eu;
    
    if iter==1
        merge_prods=[1; 1; 1; 1; 1; zeros(9,1)];
    elseif ismember(iter,[10 13 14 15]) % divesting product 1
        merge_prods=[0; 1; 1; 1; 1; zeros(9,1)];
    elseif ismember(iter,[20 23 24 25]) % divesting 2
        merge_prods=[1; 0; 1; 1; 1; zeros(9,1)];
    elseif ismember(iter,[30 33 34 35]) % divesting 3
        merge_prods=[1; 1; 0; 1; 1; zeros(9,1)];
    elseif ismember(iter,[120 123 124 125]) % divesting 1,2
        merge_prods=[0; 0; 1; 1; 1; zeros(9,1)];
    elseif ismember(iter,[130 133 134 135]) % divesting 1,3
        merge_prods=[0; 1; 0; 1; 1; zeros(9,1)];
    elseif ismember(iter,[230 233 234 235]) % divesting 2,3 
        merge_prods=[1; 0; 0; 1; 1; zeros(9,1)];
    end
    
    % get new estimated marginal costs with efficiency gains
    % mc_hat^* = [change f1; change f2; same; same; same]
    mc_hat_new = mc_hat-(1-Eu).*g_krt*rho_hat.*merge_prods;
    mc_hat_effic(:,n) = mc_hat_new;
    
    fun1 = @(p)getCFprices(p, mc_hat_new, Omega, xbpx, alpha, sigma);
    
    [CFP_EFFIC,fvalout,flag] = fsolve(fun1, p0, optopts);
    fval(n,2) = mean(fvalout);
    flags(n,2) = flag;
    
    merger_pEffic(:,n) = CFP_EFFIC;
    
    % calculate Consumer Surplus with efficiency gains
    CS(n,2) = 1/abs(alpha) * sum(exp(xbpx - alpha*CFP_EFFIC));
end
toc
