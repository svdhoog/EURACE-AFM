function[wealth]=agent_liquid_assets_wealth_computing(tau,agent)

global DBFinancialAssets

AssetsIds = fieldnames(DBFinancialAssets);

tmp = 0;
for n=1:numel(AssetsIds)
    id = AssetsIds{n,1};
    Qty = agent.portfolio.(id);
    price = DBFinancialAssets.(id).prices(tau);
    tmp = tmp + Qty*price;
    clear id Qty price
end

wealth = tmp;
    
    