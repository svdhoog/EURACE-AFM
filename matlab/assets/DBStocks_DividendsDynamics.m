function[]=DBStocks_DividendsDynamics()

global Parameters DBFinancialAssets

m = Parameters.current_month;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
for fa = 1:numel(FinancialAssetsIds)
    id = FinancialAssetsIds{fa,1};
    FinancialAsset = DBFinancialAssets.(id);
    if strcmp(FinancialAsset.class,'stock')
        stock = FinancialAsset;
        stock = stock_DividendsDynamics(stock);
        DBFinancialAssets.(id) = stock;
    end
    clear FinancialAsset stock
end

if Parameters.prompt_print==1
    fprintf('\r\r Dividends dynamics updated')
end