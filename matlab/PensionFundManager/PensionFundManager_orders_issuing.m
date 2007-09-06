function[]=PensionFundManager_orders_issuing

global Parameters DBFinancialAssets PensionFundManager

t = Parameters.current_day;

%%% Orders initialization
AssetsIds = fieldnames(DBFinancialAssets);
NrAssetsId = numel(AssetsIds);

if PensionFundManager.trading_activity(t)==1
    for n=1:NrAssetsId
        id = PensionFundManager.assets_ids{n,1};
        asset = DBFinancialAssets.(id);
        LastMarketPrice = asset.prices(t-1);

        LimitPrice = LastMarketPrice;
        qf = floor(PensionFundManager.assets_weights{t,1}(n)*PensionFundManager.portfolio_budget(t)/LimitPrice);
        q0 = PensionFundManager.portfolio.(id);

        PensionFundManager.pending_orders.(id).pLimit = LimitPrice;
        PensionFundManager.pending_orders.(id).q = qf-q0;

        clear asset LimitPrice LastMarketPrice qf q0
    end
end