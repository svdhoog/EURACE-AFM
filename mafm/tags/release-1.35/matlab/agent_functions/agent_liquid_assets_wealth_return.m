function[assets_portfolio_return]=agent_liquid_assets_wealth_return(tau,agent)

% Description:
% This function computes the assets portfolio return over the previous
% InvestmentHorizon days or since the last day of trading activity if
% the agent has updated its portfolio in between the last activity and
% the InvestmentHorizon.

horiz = agent.PortfolioAllocationRule.InvestmentHorizon;

IdxFinancialActivity = find(agent.trading_activity(1:(tau-1))==1);

if isempty(IdxFinancialActivity)
    NrDaysHoldingPeriod = horiz;
else
    NrDaysFromLastTrade = tau-IdxFinancialActivity(end);
    NrDaysHoldingPeriod = min(horiz,NrDaysFromLastTrade);
end

LastLiquidAssetsWealth = agent.liquid_assets_wealth(tau-1);
PreviousLiquidAssetsWealth = agent.liquid_assets_wealth(tau-1-NrDaysHoldingPeriod);

if PreviousLiquidAssetsWealth==0
    assets_portfolio_return = 0;
elseif PreviousLiquidAssetsWealth>0   
    assets_portfolio_return = (1/NrDaysHoldingPeriod)*...
        (LastLiquidAssetsWealth-PreviousLiquidAssetsWealth)/PreviousLiquidAssetsWealth;
else
    error('PreviousLiquidAssetsWealth can not be negative')
end 