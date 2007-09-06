function[]=DBStocks_NrOutStandingShares_constant

global DBFinancialAssets Parameters

t = Parameters.current_day;

AssetsId = fieldnames(DBFinancialAssets);

for s=1:numel(AssetsId)

    id = AssetsId{s,1};
    asset = DBFinancialAssets.(id);
    
    if strcmp(asset.class,'stock')
        asset.NrOutStandingShares(t) = asset.NrOutStandingShares(t-1);
        DBFinancialAssets.(id) = asset;
   end

    clear id asset
end