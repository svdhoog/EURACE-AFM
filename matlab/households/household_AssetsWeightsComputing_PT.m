function[household]=household_AssetsWeightsComputing_PT(household)

global Parameters DBFinancialAssets

t = Parameters.current_day;
m = Parameters.current_month;

mem = household.PortfolioAllocationRule.memory;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(FinancialAssetsIds);

bins_number = min(household.PortfolioAllocationRule.bins_number,mem);
loss_aversion = household.PortfolioAllocationRule.LossAversion;
Value_function = zeros(1,bins_number);

utility = zeros(1,NrAssets+1);

for n=1:NrAssets
    id = household.assets_ids{n,1};
    asset = DBFinancialAssets.(id);
    
    Py_returns = household.preferences.asset_prospect.(id).prob;
    Px_returns = household.preferences.asset_prospect.(id).value;

    Idx_Px_returns_pos = find(Px_returns>=0);
    Idx_Px_returns_neg = find(Px_returns<0);

    Value_function(Idx_Px_returns_pos) = Px_returns(Idx_Px_returns_pos);
    Value_function(Idx_Px_returns_neg) = loss_aversion*Px_returns(Idx_Px_returns_neg);

    utility_tmp = sum(Py_returns.*Value_function);
    
    household.preferences.assets_prospect_utility{t,1}(1,n) = utility_tmp;
    
    utility(n) = utility_tmp;
    
    clear Value_function Px_returns Py_returns utility_tmp
    
end

%utility(NrAssets+1) = Parameters.CentralBankPolicy.RiskFreeRate/Parameters.NrDaysInYear;
utility(NrAssets+1) = Parameters.CentralBankPolicy.RiskFreeRate;

wf_overall= Prospect_weights_linearmapping(utility);
wf = wf_overall(1:NrAssets);

household.preferences.assets_weights{t,1} = wf;

if abs(sum(wf_overall)-1)>1e-3
    error('The sum of weights is different from 1')
end

ExpectedTotalReturns = household.beliefs.AssetsExpectedTotalReturns;

ExpectedTotalReturns_overall = [ExpectedTotalReturns, Parameters.CentralBankPolicy.RiskFreeRate]; %% Annual rate
ExpectedTotalReturns_overall = (1+ExpectedTotalReturns_overall).^(1/12)-1; %% monthly return
household.beliefs.portfolio_return_expected(m+1) = wf_overall*ExpectedTotalReturns_overall';