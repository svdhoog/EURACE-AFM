function[PriceReturn, FinalPrice]=agent_AssetExpectedPriceReturn(agent,asset,CashFlowYield,...
    volatility,average_return)

global Parameters 

t = Parameters.current_day;

horiz = agent.PortfolioAllocationRule.InvestmentHorizon; % forward time window memory in days

LastMarketPrice = asset.prices(t-1);

% Annualized expected rate of return according to random behavior
RandomRetun = volatility*randn; 

% Annualized expected rate of return according to chartist behavior
ChartistReturn = Parameters.NrDaysInYear*average_return; 

% Annualized expected rate of return according to chartist behavior
FundamentalReturn = CashFlowYield-Parameters.CentralBankPolicy.RiskFreeRate; 

PriceReturn = agent.random_return_weight*RandomRetun + ...
    agent.chartist_return_weight*ChartistReturn + ...
    agent.fundamental_return_weight*FundamentalReturn; %% Annual Rate

if PriceReturn<Parameters.PriceReturn_min
    PriceReturn = Parameters.PriceReturn_min;
end

PriceReturn_horiz = (horiz/Parameters.NrDaysInYear)*PriceReturn;
FinalPrice = LastMarketPrice*(1+PriceReturn_horiz);
