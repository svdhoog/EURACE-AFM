clc
clear all
close all

%%% Tes n.1  %%%
agent.beliefs_update = [0 0 0 1 0 0 0]';
agent.liquid_assets_wealth = [100 100 100 100 110 110 110];
agent.PortfolioAllocationRule.InvestmentHorizon = 5;

current_time = 8;
assets_portfolio_return  = agent_liquid_assets_wealth_return(current_time,agent);
assets_portfolio_return_right = 0.1/4;
fprintf('\r Test value: %f \t correct value: %f',assets_portfolio_return,assets_portfolio_return_right)
if assets_portfolio_return==assets_portfolio_return_right
    fprintf('\t Test OK !')
else
    fprintf('\t Test broken !')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Tes n.2  %%%
agent.beliefs_update = [0 0 0 1 0 0 0]';
agent.liquid_assets_wealth = [100 100 100 100 110 110 99];
agent.PortfolioAllocationRule.InvestmentHorizon = 2;

current_time = 8;
assets_portfolio_return  = agent_liquid_assets_wealth_return(current_time,agent);
assets_portfolio_return_right = -0.1/2;
fprintf('\r Test value: %f \t correct value: %f',assets_portfolio_return,assets_portfolio_return_right)
if assets_portfolio_return==assets_portfolio_return_right
    fprintf('\t Test OK !')
else
    fprintf('\t Test broken !')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Tes n.3  %%%
agent.beliefs_update = [0 0 0 1 1 1 1]';
agent.liquid_assets_wealth = [100 100 100 100 100 100 101];
agent.PortfolioAllocationRule.InvestmentHorizon = 5;

current_time = 8;
assets_portfolio_return  = agent_liquid_assets_wealth_return(current_time,agent);
assets_portfolio_return_right = 0.01;
fprintf('\r Test value: %f \t correct value: %f',assets_portfolio_return,assets_portfolio_return_right)
if assets_portfolio_return==assets_portfolio_return_right
    fprintf('\t Test OK !')
else
    fprintf('\t Test broken !')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Tes n.4  %%%
agent.beliefs_update = [0 0 0 1 1 1 0]';
agent.liquid_assets_wealth = [100 100 100 100 100 100 101];
agent.PortfolioAllocationRule.InvestmentHorizon = 5;

current_time = 8;
assets_portfolio_return  = agent_liquid_assets_wealth_return(current_time,agent);
assets_portfolio_return_right = 0.005;
fprintf('\r Test value: %f \t correct value: %f',assets_portfolio_return,assets_portfolio_return_right)
if assets_portfolio_return==assets_portfolio_return_right
    fprintf('\t Test OK !')
else
    fprintf('\t Test broken !')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

