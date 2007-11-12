function[ExpectedDividendsStream]=agent_ComputingDividendsStream(agent,stock)

global Parameters Days DividendsDynamicsMonthlyDays DividendsPaymentMonthlyDays

t = Parameters.current_day;
m = Parameters.current_month;

id = stock.id;

horiz = agent.PortfolioAllocationRule.InvestmentHorizon;
HorizonDays = Days(min(t+1,Parameters.NrTotalDays):min(t+horiz,Parameters.NrTotalDays));

DividendsDynamicsMonthlyDaysInInvestmentHorizon = intersect(HorizonDays,DividendsDynamicsMonthlyDays);
Xvect = (1:numel(DividendsDynamicsMonthlyDaysInInvestmentHorizon))';
gr = Parameters.Stocks.(id).DividendsGrowthRate;

LastDividend = stock.dividends(m);

IdxDividendsPaymentDays = ismember(DividendsDynamicsMonthlyDaysInInvestmentHorizon,DividendsPaymentMonthlyDays);
ExpectedDividendsStream  = ...
    exp(randn/agent.dividends_knowledge)*exp(Xvect(find(IdxDividendsPaymentDays))*gr)*LastDividend;