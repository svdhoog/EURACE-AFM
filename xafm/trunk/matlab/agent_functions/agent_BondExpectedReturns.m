function[PriceReturn, TotalReturn, CouponYield]=...
    agent_BondExpectedReturns(agent,bond,volatility,average_return)

% Description:
% computes expected price returns and total returns of a bond, 
% given the agent memory and investment horizon
%
% Input arguments:
% agent: struct related to an agent
% bond: struct related to a bond
% volatility: double related to the historical annualized volatility of bond returns
% average_return: double related to the historical annualized average bond returns
%
% Output arguments:
% PriceReturn: double related to bond price return
% TotalReturn: double related to bond total return (price return and coupons)
% 
% Version 1.2 of July 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)

global Parameters Days CalendarDates

t = Parameters.current_day;

horiz = agent.PortfolioAllocationRule.InvestmentHorizon;

LastMarketPrice = bond.prices(t-1);

% Determination of total return
CurrentDay = Days(t,1);
HorizonDay = Days(min(t+horiz,Parameters.NrTotalDays),1); 

IdxCouponsPaymentDaysStream = find((bond.CouponsPaymentDays>CurrentDay)&(bond.CouponsPaymentDays<=HorizonDay));

if ~isempty(IdxCouponsPaymentDaysStream)
    
    CouponsPaymentDaysStream = bond.CouponsPaymentDays(IdxCouponsPaymentDaysStream);
    CashFlowDays = [CurrentDay; CouponsPaymentDaysStream; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);

    ExpectedCouponsStream = bond.NominalYield*bond.FaceValue*ones(length(IdxCouponsPaymentDaysStream),1);
    
    CouponInvestment = [-LastMarketPrice; ExpectedCouponsStream; LastMarketPrice];
    CouponYield = xirr(CouponInvestment,datestr(CashFlowMonths),0,Parameters.IRR.MaxIter);
    if isnan(CouponYield)
        CouponYield = 0;
    end
    
    % Determination of price retun
    [PriceReturn, FinalPrice] = agent_AssetExpectedPriceReturn(agent,bond,CouponYield,...
        volatility,average_return);
    
    TotalInvestment = [-LastMarketPrice; ExpectedCouponsStream; FinalPrice];
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end

else
    CashFlowDays = [CurrentDay; HorizonDay];
    CashFlowMonths = CashFlowDays*floor(30/Parameters.NrDaysInMonth);

    CouponYield = 0;
    
    % Determination of price return
    [PriceReturn, FinalPrice] = agent_AssetExpectedPriceReturn(agent,bond,CouponYield,...
        volatility,average_return);

    TotalInvestment = [-LastMarketPrice; FinalPrice];
    TotalReturn = xirr(TotalInvestment,datestr(CashFlowMonths),PriceReturn,Parameters.IRR.MaxIter);
    if isnan(TotalReturn)
        TotalReturn = PriceReturn;
    end
    
end 