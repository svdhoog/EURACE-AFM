function[firm]=firm_creation(id)

global Parameters

firm.class = 'firm';
firm.id = ['F', id];

%%% Parameters of the optimization process
firm.Qd_est = zeros(1,2*Parameters.Firms.PriceDecisionGridNr+1);
firm.P_grid = zeros(1,2*Parameters.Firms.PriceDecisionGridNr+1);
firm.Nd_grid = zeros(1,2*Parameters.Firms.PriceDecisionGridNr+1);
firm.Profits_real_grid = zeros(1,2*Parameters.Firms.PriceDecisionGridNr+1);

% firm.Qs = NaN*ones(Parameters.NrTotalDays,1);
% firm.Qd = NaN*ones(Parameters.NrTotalDays,1);
% firm.Q = NaN*ones(Parameters.NrTotalDays,1);
% firm.P = Parameters.Firms.P0*ones(Parameters.NrTotalDays,1);

firm.technology = ones(Parameters.NrTotalDays,1);

% MonopolisticFirm.Nd = Parameters.N0*ones(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.profits = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.profits_operating = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.revenues = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.costs_wage = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.costs_debt = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.costs_finance = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.net_worth = zeros(Parameters.Stocks.PricesInitializationLength,1);
% MonopolisticFirm.debt = zeros(Parameters.Stocks.PricesInitializationLength,1);
% 
% MonopolisticFirm.demand_elasticity_estimate = zeros(Parameters.Stocks.PricesInitializationLength,1);

%Firm.capacity_max = zeros(Parameters.InitializationTimeSpan,1);

