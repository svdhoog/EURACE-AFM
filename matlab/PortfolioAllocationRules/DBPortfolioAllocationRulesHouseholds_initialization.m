% %%% Parameters range setting of the MPT PortfolioAllocationRule
 PortfolioAllocationRule_class = 'MPT';
 PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.InvestmentHorizon = ...
     1:Parameters.NrDaysInMonth;
 PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.memory = ...
     Parameters.NrDaysInMonth;
 PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.risk_aversion = 3; %3:4;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Parameters range setting of the PT PortfolioAllocationRule
% PortfolioAllocationRule_class = 'PT';
% PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.InvestmentHorizon = ...
%     1:Parameters.NrDaysInMonth;
% PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.memory = ...
%     Parameters.NrDaysInMonth;
% PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.bins_number = 3;
% PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.LossAversion = 1:2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parameters range setting of the PT PortfolioAllocationRule
%PortfolioAllocationRule_class = 'Rnd';
%PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.InvestmentHorizon = ...
%    1:Parameters.NrDaysInMonth;
%PortfolioAllocationRules.(PortfolioAllocationRule_class).Parameters_grids.memory = ...
%    Parameters.NrDaysInMonth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DBPortfolioAllocationRulesHouseholds = DBPortfolioAllocationRules_creation(PortfolioAllocationRules);

clear PortfolioAllocationRules 