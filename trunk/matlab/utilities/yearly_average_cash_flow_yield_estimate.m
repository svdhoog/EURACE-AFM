function[est]= yearly_average_cash_flow_yield_estimate()

global Parameters DBFinancialAssets

t = Parameters.current_day;
m = Parameters.current_month;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(FinancialAssetsIds);

est = 0;
for n=1:NrAssets
    id = FinancialAssetsIds{n,1};
    asset = DBFinancialAssets.(id);
    LastPrice = asset.prices(t-1);
    if strcmp(asset.class,'stock')
        cashflow = asset.dividends(m-1);
    else
        cashflow = asset.FaceValue*asset.NominalYield;
    end
    est = est + 2*cashflow/LastPrice;
end
    
