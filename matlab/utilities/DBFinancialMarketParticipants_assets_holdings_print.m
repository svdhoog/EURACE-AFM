function[]=DBFinancialMarketParticipants_assets_holdings_print(AssetId)

global Parameters DBFinancialMarketParticipants

t = Parameters.current_day;

FinancialMarketParticipantsIds = fieldnames(DBFinancialMarketParticipants);

fprintf('\r\r FinancialMarketParticipants asset holdings of asset: %s',AssetId)

for i=1:numel(FinancialMarketParticipantsIds)
    id = FinancialMarketParticipantsIds{i,1};
    qty = DBFinancialMarketParticipants.(id).portfolio.S1;
    trade = DBFinancialMarketParticipants.(id).portfolio.transactions_accounting(t);
    fprintf('\r %s \t holdings of S1: %d \t transaction: %f',id,qty,trade)
    clear id qty trade
end