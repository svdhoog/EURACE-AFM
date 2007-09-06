function[]=PensionFundManager_AssetsWeightsComputing

global Parameters DBFinancialAssets PensionFundManager

t = Parameters.current_day;

%%% Orders initialization
AssetsId = fieldnames(DBFinancialAssets);
NrAssetsId = numel(AssetsId);

MarketCapitalization = zeros(1,NrAssetsId);

%%% Computing market capitalization
for n=1:NrAssetsId
    id = AssetsId{n,1};
    PensionFundManager.assets_ids{n,1} = id;

    asset = DBFinancialAssets.(id);
    LastMarketPrice = asset.prices(t-1);
    NrOutStandingShares = DBFinancialAssets.(id).NrOutStandingShares(t);
    MarketCapitalization(n) = NrOutStandingShares*LastMarketPrice;

    clear asset NrOutStandingShares LastMarketPrice
end

GlobalMarketCapitalization = sum(MarketCapitalization);

PensionFundManager.assets_weights{t,1} = MarketCapitalization/GlobalMarketCapitalization;