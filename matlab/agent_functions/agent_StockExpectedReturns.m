function[PriceReturn, TotalReturn, DividendYield]=...
    agent_StockExpectedReturns(agent,stock,volatility,average_return)

% Description:
% computes expected price returns and total returns of a stock, 
% given the agent memory and investment horizon
%
% Input arguments:
% agent: struct related to an agent
% stock: struct related to a stock
% volatility: double related to the historical annualized volatility of stock returns
% average_return: double related to the historical annualized average stock returns
%
% Output arguments:
% PriceReturn: double related to price return
% TotalReturn: double related to total return (price return and dividends)
% 
% Version 1.2 of July 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)

global Parameters Days DividendsPaymentMonthlyDays CalendarDates

t = Parameters.current_day;

horiz = agent.PortfolioAllocationRule.InvestmentHorizon; % forward time window memory in days

LastMarketPrice = stock.prices(t-1);

% Determination of total return
CurrentDay = Days(t,1);
HorizonDay = Days(min(t+horiz,Parameters.NrTotalDays),1);
IdxDividendsPaymentDaysStream = ...
    find((DividendsPaymentMonthlyDays>CurrentDay)&(DividendsPaymentMonthlyDays<=HorizonDay));

if ~isempty(IdxDividendsPaymentDaysStream)
    DividendsPaymentDaysStream = DividendsPaymentMonthlyDays(IdxDividendsPaymentDaysStream);
    CashFlowDays = [CurrentDay; DividendsPaymentDaysStream; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);
    
    ExpectedDividendsStream = agent_ComputingDividendsStream(agent,stock);
    
    DividendsInvestment = [-LastMarketPrice; ExpectedDividendsStream; LastMarketPrice];
    DividendYield = xirr(DividendsInvestment,datestr(CashFlowMonths),0,Parameters.IRR.MaxIter);
    if isnan(DividendYield)
        DividendYield = 0;
    end
    
    % Determination of price return
    [PriceReturn, FinalPrice] = agent_AssetExpectedPriceReturn(agent,stock,DividendYield,...
        volatility,average_return);

    TotalInvestment = [-LastMarketPrice; ExpectedDividendsStream; FinalPrice];
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end
    
else
    CashFlowDays = [CurrentDay; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);
    
    DividendYield = 0;
    
    % Determination of price return
    [PriceReturn, FinalPrice] = agent_AssetExpectedPriceReturn(agent,stock,DividendYield,...
        volatility,average_return);

    TotalInvestment = [-LastMarketPrice; FinalPrice];
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end
    
end 