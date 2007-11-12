function[]=Government_orders_issuing

global Parameters DBFinancialAssets Government NrBondsOutStanding

t = Parameters.current_day;

GovBondId = 'GovBond';

%%% Orders initialization
AssetsId = fieldnames(DBFinancialAssets);
NrAssetsId = numel(AssetsId);;
for n=1:NrAssetsId
    id = AssetsId{n,1};
    Government.orders.(id) = [NaN, NaN];
end

%%% Gov bond orders
LastGovBondMarketPrice = DBFinancialAssets.(GovBondId).prices(t-1);
GovAssetsValue = Government.portfolio.bank_account(t-1) + ...
    Government.portfolio.(GovBondId)*LastGovBondMarketPrice;

LimitPrice = 0.95*LastGovBondMarketPrice;

if GovAssetsValue<0
    Government.trading_activity(t) = 1;
    GovBond_issue = floor(abs(GovAssetsValue)/LimitPrice);
    DBFinancialAssets.(GovBondId).NrOutStandingShares(t) = ...
        DBFinancialAssets.(GovBondId).NrOutStandingShares(t-1) + GovBond_issue;
    Government.portfolio.GovBond = Government.portfolio.GovBond + GovBond_issue;
    Government.pending_orders.(GovBondId).pLimit = LimitPrice;
    Government.pending_orders.(GovBondId).q = -Government.portfolio.GovBond;
else
    DBFinancialAssets.(GovBondId).NrOutStandingShares(t) = ...
        DBFinancialAssets.(GovBondId).NrOutStandingShares(t-1);
    Government.trading_activity(t) = 0;
    GovBond_issue = 0;
end

if Parameters.prompt_print==1
    fprintf('\r\r Government')
    fprintf('\r\t GovAssetsValue: %f \t Issue of new bond: %d',GovAssetsValue,GovBond_issue)
end