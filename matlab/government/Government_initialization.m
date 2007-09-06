
Government.class = 'Government';
Government.id = 'Government';

Government.financial_budget = NaN*ones(Parameters.NrTotalMonths,1);
Government.tax_collection = NaN*ones(Parameters.NrTotalMonths,1);
Government.public_expenditure = NaN*ones(Parameters.NrTotalMonths,1);
Government.debt_service = NaN*ones(Parameters.NrTotalMonths,1);
Government.debt = zeros(Parameters.NrTotalMonths,1);

Government.trading_activity = NaN*ones(Parameters.NrTotalDays,1);

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

Government.portfolio.dummy = 'Dummmy';
for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    Government.portfolio.(id) = 0;
end
Government.portfolio = rmfield(Government.portfolio,'dummy');

Government.portfolio.transactions_accounting = zeros(Parameters.NrTotalDays,1);
Government.portfolio.bank_account = NaN*ones(Parameters.NrTotalDays,1);
Government.portfolio.bank_account(1:NrDaysInitialization) = 0;
