function[stock]=stock_DividendsDynamics(stock)

global Parameters Noises

m = Parameters.current_month;

id = stock.id;


LastDividend = stock.dividends(m-1);

growth_rate = Parameters.Stocks.(id).DividendsGrowthRate;
s = Parameters.Stocks.(id).DividendsSigma;

NewDividend_Log = log(LastDividend) + growth_rate + s*Noises.(id)(m);
stock.dividends(m) = exp(NewDividend_Log);