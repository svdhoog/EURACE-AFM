
PensionFundManager.class = 'PensionFundManager';
PensionFundManager.id = 'PensionFundManager';

PensionFundManager.quotes = zeros(Parameters.NrTotalMonths,1);
PensionFundManager.quotes(1) = 0;
PensionFundManager.quote_value = zeros(Parameters.NrTotalMonths,1);
PensionFundManager.subscrptions = NaN*ones(Parameters.NrTotalMonths,1);
PensionFundManager.capital_net_income = zeros(Parameters.NrTotalMonths,1);
PensionFundManager.capital_gross_income = zeros(Parameters.NrTotalMonths,1);
PensionFundManager.private_pension_expenditure = NaN*ones(Parameters.NrTotalMonths,1);

PensionFundManager.trading_activity = NaN*ones(Parameters.NrTotalDays,1);
PensionFundManager.portfolio.transactions_accounting = zeros(Parameters.NrTotalDays,1);
PensionFundManager.portfolio.bank_account = NaN*ones(Parameters.NrTotalDays,1);
PensionFundManager.portfolio.bank_account(1:NrDaysInitialization) = 0;

PensionFundManager.liquid_assets_wealth = NaN*ones(Parameters.NrTotalDays,1);
PensionFundManager.portfolio_budget = NaN*ones(Parameters.NrTotalDays,1);


FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

PensionFundManager.portfolio.dummy = 'Dummmy';
for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    PensionFundManager.portfolio.(id) = 0;
end
PensionFundManager.portfolio = rmfield(PensionFundManager.portfolio,'dummy');


PensionFundManager.liquid_assets_wealth(NrDaysInitialization) = ...
    agent_liquid_assets_wealth_computing(NrDaysInitialization,PensionFundManager);
