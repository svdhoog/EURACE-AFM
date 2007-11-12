function[PriceReturn, TotalReturn, CashFlowYield]=...
    household_AssetExpectedReturns(household,asset,volatility,average_return)

% Description:
% computes expected price returns and total returns of an asset, 
% either stock, bond, or derivative, given the household memory and investment horizon
%
% Input arguments:
% household: struct related to an household
% asset: struct related to an asset
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

global Parameters Days DividendsPaymentDays CalendarDates

t = Parameters.current_day;

horiz = household.InvestmentHorizon; % forward time window memory in days

LastMarketPrice = asset.prices(t-1);

% Determination of total return
CurrentDay = Days(t,1);
HorizonDay = Days(min(t+horiz,Parameters.NrTotalDays),1);
IdxDividendsPaymentDaysStream = ...
    find((DividendsPaymentDays>CurrentDay)&(DividendsPaymentDays<=HorizonDay));

if ~isempty(IdxDividendsPaymentDaysStream)
    DividendsPaymentDaysStream = DividendsPaymentDays(IdxDividendsPaymentDaysStream);
    CashFlowDays = [CurrentDay; DividendsPaymentDaysStream; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);
    
    ExpectedDividendsStream = household_ComputingDividendsStream(household,stock);
    
    DividendsInvestment = [-LastMarketPrice; ExpectedDividendsStream; LastMarketPrice];
    DividendYield = xirr(DividendsInvestment,datestr(CashFlowMonths),0,Parameters.IRR.MaxIter);
    if isnan(DividendYield)
        DividendYield = 0;
    end
    
    % Determination of price return
    [PriceReturn, FinalPrice] = household_AssetExpectedPriceReturn(household,stock,...
        volatility,average_return,DividendYield);

    TotalInvestment = [-LastMarketPrice; ExpectedDividendsStream; FinalPrice];
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end
    
else
    CashFlowDays = [CurrentDay; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);
    
    TotalInvestment = [-LastMarketPrice; FinalPrice];

    DividendYield = 0;
    
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end
    
end 