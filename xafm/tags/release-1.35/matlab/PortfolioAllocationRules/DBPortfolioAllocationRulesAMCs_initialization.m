%%% Parameters range setting of the MPT PortfolioAllocationRule
PortfolioAllocationRule_class = 'MPT';
PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.InvestmentHorizon = 1;
PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.memory = ...
    Parameters.NrDaysInMonth;
PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.risk_aversion = 3; %2:5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DBPortfolioAllocationRulesAMCs = DBPortfolioAllocationRules_creation(PortfolioAllocationRules);

clear PortfolioAllocationRules 