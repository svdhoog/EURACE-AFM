function[agent]=agent_EWA_performance_computing(agent)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RULE PERFORMANCE ACCOUNTING in the Learning Classifier System of the Agent.
% - Compute the performance obtained by the agent using the current rule 
%   The performance of the current rule is measured by the per-day average capital gain over a fixed time-horizon.
%   The performance of a non-selected rule is measured by the optimal capital gain over the fixed time-horizon.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global TESTMODE FinancialAdvisor
%disp('Entering agent_EWA_performance_computing');
current_time=evalin('base','t');
       
RuleID = agent.PortfolioAllocationRule.id;

%Compute the performance obtained by the current household using the current rule RuleID:
%liquid_assets_wealth >0, it consists of the total value of the asset portfolio, at current prices.
if (~TESTMODE)
    my_performance = agent_liquid_assets_wealth_return(current_time,agent);
else
    my_performance = rand()*100;
end

agent.classifiersystem.(RuleID).my_performance=my_performance;
