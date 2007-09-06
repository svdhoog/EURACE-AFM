function[stock]=stock_creation(id)

global Parameters

%%% Data types creation %%%
stock.class = 'stock';
stock.id = id;
stock.NrOutStandingShares = NaN*ones(Parameters.NrTotalDays,1);
stock.NrOutStandingShares(1:Parameters.NrDaysInitialization) = Parameters.Stocks.NrOutStandingShares0;
stock.prices= NaN*ones(Parameters.NrTotalDays,1);
if strcmp(Parameters.ClearingMechanism,'LimitOrderBook')
    stock.Book_intraday_transactions = cell(Parameters.NrTotalDays,1);
end
stock.dividends = NaN*ones(Parameters.NrTotalMonths,1);
stock.dividends(1:Parameters.NrMonthsInitialization) = Parameters.Stocks.Dividends0;

%%% Initialization %%%
if strcmp(Parameters.Stocks.PricesInitializationType,'RandomWalk')
    Ret_tmp = [0; randn(Parameters.NrDaysInitialization-1,1)]/Parameters.Stocks.PricesInitializationScaleFactor;
else
    error('Prices initialization type is undefined')
end
stock.prices(1:Parameters.NrDaysInitialization) = Parameters.Stocks.PricesInit*exp(cumsum(Ret_tmp));
