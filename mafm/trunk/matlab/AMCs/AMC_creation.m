function[AMC]=AMC_creation(id)

global DBFinancialAssets FinancialAdvisor Parameters DBPortfolioAllocationRulesAMCs

AMC.class = 'AMC';
AMC.id = [AMC.class, '_', id];

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

AMC.portfolio.dummy = 'Dummmy';
for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    AMC.portfolio.(id) = Parameters.AMCs.NrSharesPerAsstet0;
    AMC.pending_orders.(id).q = 0;
    AMC.pending_orders.(id).pLimit = NaN;
end
AMC.portfolio = rmfield(AMC.portfolio,'dummy');

AMC.portfolio.bank_account = NaN*ones(Parameters.NrTotalDays,1);

AMC.portfolio.bank_account(1:Parameters.NrDaysInitialization) = Parameters.AMCs.BankAccount0;

AMC.portfolio.transactions_accounting = zeros(Parameters.NrTotalDays,1);

AMC.beliefs.portfolio_return_expected = zeros(Parameters.NrTotalMonths,1);

AMC.beliefs_update = NaN*ones(Parameters.NrTotalDays,1);
AMC.trading_activity = NaN*ones(Parameters.NrTotalDays,1);

AMC.dividends_income = NaN*ones(Parameters.NrTotalMonths,1);
AMC.bank_interests_income = NaN*ones(Parameters.NrTotalMonths,1);
AMC.coupons_income = NaN*ones(Parameters.NrTotalMonths,1);
AMC.capital_gross_income = NaN*ones(Parameters.NrTotalMonths,1);
AMC.capital_net_income = NaN*ones(Parameters.NrTotalMonths,1);

AMC.net_income = NaN*ones(Parameters.NrTotalMonths,1);
AMC.capital_taxes = NaN*ones(Parameters.NrTotalMonths,1);

AMC.beliefs.portfolio_return = zeros(Parameters.NrTotalMonths,1);

AMC.portfolio_budget = NaN*ones(Parameters.NrTotalDays,1);
AMC.liquid_assets_wealth = NaN*ones(Parameters.NrTotalDays,1);
AMC.liquid_assets_wealth(1:Parameters.NrDaysInitialization) = ...
    agent_liquid_assets_wealth_computing(Parameters.NrDaysInitialization,AMC);

AMC.dividends_knowledge = inf;

AMC.random_return_weight = 1;
AMC.chartist_return_weight = 0;
AMC.fundamental_return_weight = 0;

AMC.classifiersystem = FinancialAdvisor.classifiersystem_AMCs;

% Adding the field experience:
PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesAMCs);
NrPortfolioAllocationRules = numel(PortfolioAllocationRules_names);
IdxPortfolioAllocationRule_chosen = unidrnd(NrPortfolioAllocationRules);
NamePortfolioAllocationRule_chosen = PortfolioAllocationRules_names{IdxPortfolioAllocationRule_chosen,1};
%
% %%Setting the field PortfolioAllocationRule:
AMC.PortfolioAllocationRule = DBPortfolioAllocationRulesAMCs.(NamePortfolioAllocationRule_chosen);
%
% %%Setting the field current_rule: 
AMC.classifiersystem.current_rule = AMC.PortfolioAllocationRule.id;