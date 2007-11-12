if PensionFundManager.quotes(current_month-1)==0
    NewQuotes = 1000;
else
    NewQuotes = PensionFundManager.quotes(current_month-1)*AggregatePensionFundSaving(current_month)/...
        (PensionFundManager.liquid_assets_wealth(t)+...
        PensionFundManager.portfolio.bank_account(t)-AggregatePensionFundSaving(current_month));
end

PensionFundManager.quotes(current_month) = PensionFundManager.quotes(current_month-1)+NewQuotes;

DBHouseholds_pension_fund_quotes_distribution(NewQuotes,AggregatePensionFundSaving(current_month))

PensionFundManager.quote_value(current_month) = ...
    (PensionFundManager.liquid_assets_wealth(t) +...
    PensionFundManager.portfolio.bank_account(t))/PensionFundManager.quotes(current_month);

AggregatePensionFundQuotes(current_month) = DBHouseholds_pension_fund_quotes_aggregation;

fprintf('\r\r Pension Fund Manager new quotes distribution')
fprintf('\r\t Aggregate quotes: %f \t new quotes distribution: %f \t quote value: %f',...
    PensionFundManager.quotes(current_month),NewQuotes,PensionFundManager.quote_value(current_month))
fprintf('\r\t AggregatePensionFundQuotes: %f',AggregatePensionFundQuotes(current_month))

clear NewQuotes