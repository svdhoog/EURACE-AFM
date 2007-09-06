function[DividendYield]= household_StockExpectedDividendYield(household,stock)

% Description:
% computes expected dividend yield for a stock, given the household investment horizon
% and the resale price set at the last market price.
%
% Input arguments:
% household: struct related to an household
% stock: struct related to a stock
%
% Output arguments:
% DividendYield: double related to the dividend yield
% 
% Version 1.2 of June 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)

global Parameters Days DividendsPaymentDays CalendarDates

t = Parameters.current_day;
id = stock.id;

mem = household.memory;
horiz = household.InvestmentHorizon;

LastMarketPrice = stock.prices(t-1);

CurrentDay = Days(t,1);
HorizonDay = Days(t+horiz,1);
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

else
    DividendYield = 0;
end 