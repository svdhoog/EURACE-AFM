function[tmp]=agent_dividends_income_computing(agent)

global Parameters DBFinancialAssets

m = Parameters.current_month;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);


tmp = 0;
for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    if strcmp(DBFinancialAssets.(id).class,'stock')
        dividend = DBFinancialAssets.(id).dividends(m);
        qty = agent.portfolio.(id);
        tmp = tmp+dividend*qty;
        clear id dividend qty
    end
end