% use the GPL here

%%%%%%%%%%%%%%%%%%%%%%%%%%% Setup Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; clc;
% get dataset
table = readtable('data.csv');
data = table2array( table(:,2:67) );

q_jrt = data(:,41).*data(:,40); % servings = units * product size
p_jrt = data(:,45).*100./data(:,50); % CPI (à la Miller-Weinberg)
n = length(q_jrt);

markSize = 0.5*data(:,64)*7; %(50% population) * 1 serving/day * 7 days
s_jrt = q_jrt ./ markSize;

% Inside and outside good share
marketID = data(:,65); % unique consecutive integer market identifier
days_in_mo = data(:,66);
inshare = zeros(n,1);
for i=1:max(marketID)
    % set inshare = sum of shares in each market
    inshare(marketID==i) = sum(s_jrt(marketID==i));
end
inshare = inshare ./ days_in_mo;
s0 = 1 - inshare;

% time fixed effects
timeFE = data(:,3:10); %isQ1 isQ2 isQ3 isQ4 is09 is10 is11 is12
quartFE = data(:,4:6); %isQ2 isQ3 isQ4
yearFE = data(:,8:10); %is10 is11 is12

% State/regional fixed effects
stateFE = data(:,13:15); %isKY isOH isTX

% product fixed effects
prodFE = data(:,19:31); % dummies for products 2-14

% manufacturer fixed effects
manFE = data(:,32:35); % GM, Kellogg, Post, Quaker, (Private omittted)

% category fixed effects
catFE = data(:,38:39); %isKids isAllfam

% misc fixed effects
isFeat = data(:,47);
isDisp = data(:,48);

% product characteristic variables
calories = data(:,51);
sugars = data(:,52);
carbo = data(:,53);
protein = data(:,54);
fat = data(:,55);
sodium = data(:,56);
fiber = data(:,57);
potassium = data(:,58);

characs = [calories sugars carbo protein fat sodium fiber potassium];

% construct "Villas-Boas instruments"
Villas = [calories.*prodFE, sugars.*prodFE, carbo.*prodFE protein.*prodFE];

% demographic variables
faminc = data(:,59); famsq = faminc.^2;
child35 = data(:,60);
child613 = data(:,61);
child1417 = data(:,62);
age = data(:,63);

%%%%%%%%%%%%%%%%%%%%%%%%% Demand Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%
logodds = log(s_jrt) - log(s0);

X = [p_jrt characs];
Z = [quartFE yearFE stateFE manFE catFE prodFE faminc ...
    faminc.*characs famsq age];
% get 2SLS results

beta_ols_IV = (Z'*X)\Z'*logodds;

W = (Z'*Z) \ eye(size(Z,2));
beta_2sls = (X'*Z * W * Z'*X)\(X'*Z * W * Z'*logodds);

%RCNL Demand estimation
%tic
%fd = @(dparams)GMMdemand();
%[dparams_1,fval1,dexit_1,~] = fminsearch(fd,dparams,options1);
%dhours  = toc/60/60;

%%%%%%%%%%%%%%%%%%%%%% Supply Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%









