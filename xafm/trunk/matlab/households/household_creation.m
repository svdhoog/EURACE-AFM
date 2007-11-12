function[household]=household_creation(id,NrShares_percapita)

% Description:
% create the struct household
%
% Input arguments:
% id: string related to the household id
% NrShares_percapita: struct related to nr shares for each asset given the
% households at the beginning of the simulation
%
% Output arguments:
% household: struct related to the initialized household
% 
% Version 1.0 of June 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)

global Parameters DBFinancialAssets DBPortfolioAllocationRulesHouseholds FinancialAdvisor  

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

household.class = 'household';
household.id = [household.class, '_', id];
household.portfolio.dummy = 'Dummmy';

FinancialWealth_tmp = 0;
for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    household.portfolio.(id) = NrShares_percapita.(id);
    household.pending_orders.(id).q = 0;
    household.pending_orders.(id).pLimit = NaN;
    FinancialWealth_tmp = FinancialWealth_tmp + ...
        NrShares_percapita.(id)*DBFinancialAssets.(id).prices(1:Parameters.NrDaysInitialization,end);
end

household.private_pension = 0;
household.public_pension = 0;
household.pension_state = 0;

household.portfolio = rmfield(household.portfolio,'dummy');

household.portfolio.bank_account = NaN*ones(Parameters.NrTotalDays,1);
wealth_tmp = agent_liquid_assets_wealth_computing(Parameters.NrDaysInitialization,household);
household.portfolio.bank_account(1:Parameters.NrDaysInitialization) = ...
    (wealth_tmp/NrFinancialAssetsIds)*ones(Parameters.NrDaysInitialization,1);

household.portfolio.transactions_accounting = zeros(Parameters.NrTotalDays,1);

household.beliefs.portfolio_return_expected = zeros(Parameters.NrTotalMonths,1);

household.labor_activity = NaN*ones(Parameters.NrTotalMonths,1);
household.beliefs_update = NaN*ones(Parameters.NrTotalDays,1);
household.trading_activity = NaN*ones(Parameters.NrTotalDays,1);

household.labor_gross_income = NaN*ones(Parameters.NrTotalMonths,1);
household.public_pension_gross_income = NaN*ones(Parameters.NrTotalMonths,1);

household.dividends_income = NaN*ones(Parameters.NrTotalMonths,1);
household.bank_interests_income = NaN*ones(Parameters.NrTotalMonths,1);
household.coupons_income = NaN*ones(Parameters.NrTotalMonths,1);
household.capital_gross_income = NaN*ones(Parameters.NrTotalMonths,1);

household.net_income = NaN*ones(Parameters.NrTotalMonths,1);
household.labor_taxes = NaN*ones(Parameters.NrTotalMonths,1);
household.capital_taxes = NaN*ones(Parameters.NrTotalMonths,1);

household.beliefs.wage_net = NaN*ones(Parameters.NrTotalMonths,1);
household.beliefs.portfolio_return = zeros(Parameters.NrTotalMonths,1);

household.cash_on_hands = NaN*ones(Parameters.NrTotalMonths,1);
household.consumption_budget = NaN*ones(Parameters.NrTotalMonths,1);

household.portfolio_budget = NaN*ones(Parameters.NrTotalDays,1);
household.liquid_assets_wealth = NaN*ones(Parameters.NrTotalDays,1);
household.liquid_assets_wealth(1:Parameters.NrDaysInitialization) = ...
    agent_liquid_assets_wealth_computing(Parameters.NrDaysInitialization,household);

household.pension_fund_saving = NaN*ones(Parameters.NrTotalMonths,1);
household.pension_fund_quotes = zeros(Parameters.NrTotalMonths,1);

household.tax_detraction = NaN*ones(Parameters.NrTotalMonths,1);

household.x_hat = zeros(Parameters.NrTotalMonths,1);
household.x_hat(1:Parameters.NrMonthsInitialization) = Parameters.Households.x_hat0;

household.ni_hat = zeros(Parameters.NrTotalMonths,1);
household.ni_hat(1:Parameters.NrMonthsInitialization) = Parameters.Households.ni_hat0;

if Parameters.Households.AgeDimension==1
    household.age = floor(lognrnd(log(Parameters.Households.age_avg),Parameters.Households.age_logn_std,1));
    if household.age<Parameters.Households.age_min
        household.age = Parameters.Households.age_min + ...
            floor(rand*(Parameters.Households.age_max-Parameters.Households.age_min));
    elseif household.age>Parameters.Households.age_max
        household.age = Parameters.Households.age_min + ...
            floor(rand*(Parameters.Households.age_max-Parameters.Households.age_min));
    end
elseif Parameters.Households.AgeDimension==0
    household.age = Parameters.Households.age_avg;
end

household.bequests = NaN*ones(Parameters.NrTotalMonths,1);

household.preferences.assets_weights = cell(Parameters.NrTotalDays,1);

rrw = Parameters.Households.RandomBehaviorProbability;
crw = Parameters.Households.ChartistBehaviorProbability;

if (rrw+crw)>1
    error('The Sum of random and chartist behavior probability is greater than 1')
end

tmp = rand;

if tmp<=rrw
    household.random_return_weight = 1;
    household.chartist_return_weight = 0;
    household.fundamental_return_weight = 0;
elseif (tmp>rrw)&(tmp<=(rrw+crw))
    household.random_return_weight = 0;
    household.chartist_return_weight = 1;
    household.fundamental_return_weight = 0;
else
    household.random_return_weight = 0;
    household.chartist_return_weight = 0;
    household.fundamental_return_weight = 1;
end


household.DividendsGrowthRateEstimationError = 0.8+unidrnd(3)/10;

household.labor_activity = NaN*ones(Parameters.NrTotalMonths,1);

FinancialWealth_tmp = FinancialWealth_tmp + household.portfolio.bank_account(1:Parameters.NrDaysInitialization);
household.FinancialWealth = FinancialWealth_tmp;

household.reservation_wage = Parameters.Households.reservation_wage_min +...
    rand*(Parameters.Households.reservation_wage_max-Parameters.Households.reservation_wage_min);

household.dividends_knowledge = ...
    Parameters.Households.DividendsKnowledgeMin-1+...
    unidrnd(Parameters.Households.DividendsKnowledgeMax-Parameters.Households.DividendsKnowledgeMin+1);

household.beliefs.AssetsExpectedPriceReturns = zeros(1,NrFinancialAssetsIds);
household.beliefs.AssetsExpectedTotalReturns = zeros(1,NrFinancialAssetsIds);
household.beliefs.AssetsExpectedCashFlowYield = zeros(1,NrFinancialAssetsIds);
household.beliefs.AssetsVolatilities = Parameters.AssetsBeliefsDefaultStd*ones(1,NrFinancialAssetsIds);
household.beliefs.AssetsExpectedCovariances = (Parameters.AssetsBeliefsDefaultStd^2)*eye(NrFinancialAssetsIds);

%%% PortfolioAllocationRule assignement
household.classifiersystem = FinancialAdvisor.classifiersystem_Households;

% Adding the field experience:
PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesHouseholds);
NrPortfolioAllocationRules = numel(PortfolioAllocationRules_names);
IdxPortfolioAllocationRule_chosen = unidrnd(NrPortfolioAllocationRules);
NamePortfolioAllocationRule_chosen = PortfolioAllocationRules_names{IdxPortfolioAllocationRule_chosen,1};
%
% %%Setting the field PortfolioAllocationRule:
household.PortfolioAllocationRule = DBPortfolioAllocationRulesHouseholds.(NamePortfolioAllocationRule_chosen);
%
% %%Setting the field current_rule: 
household.classifiersystem.current_rule = household.PortfolioAllocationRule.id;
