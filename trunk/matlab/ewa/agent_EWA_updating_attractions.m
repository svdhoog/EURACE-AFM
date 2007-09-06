function[agent]=agent_EWA_updating_attractions(agent)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATING OF ATTRACTIONS in the household's internal Learning Classifier System
%
% Input: 
% struct agent with current attractions
%
% Output:
% struct agent with updated attractions
%
% Functionality:
% We loop over all the rules, compare if the RuleID is equal to (id) of the rule and set:
% - Update the experience
% - Update the attractions using the EWA equation:
%
% REF.: Van der Hoog, S. and Deissenberg, C., 2007, Modelling requirements for EURACE.
%       EURACE Working paper WP2.1, version July 24, 2007. pp. 35-38, eqn. 26.
%
% - Compute the sum of attractions
%
% This should be followed by:
% - Assign the choice probabilities: either linear prob. or exponential multinomial logit (see agent_EWA_updating_choiceprobabilities.m)
% - Select a new strategy according to the cumulative pdf function (see agent_EWA_selecting_strategy.m)
% - Set the household's new selected rule in its struct household.PortfolioAllocationRule (see agent_EWA_selecting_strategy.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global FinancialAdvisor Parameters DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs
%fprintf('\r Entering agent_EWA_updating_attractions');

%Set local learning parameters (Do all agents use the same EWA params?)

if strcmp(agent.class,'household')
    rho   = Parameters.Households.EWA_learning.rho;
    delta = Parameters.Households.EWA_learning.delta;
    phi   = Parameters.Households.EWA_learning.phi;
    RuleNames = fieldnames(DBPortfolioAllocationRulesHouseholds);
    FinancialAdvisor_classifiersystem_tmp = FinancialAdvisor.classifiersystem_Households;
elseif strcmp(agent.class,'AMC')
    rho   = agent.EWA_learning.rho;
    delta = agent.EWA_learning.delta;
    phi   = agent.EWA_learning.phi;
    RuleNames = fieldnames(DBPortfolioAllocationRulesAMCs);   
    FinancialAdvisor_classifiersystem_tmp = FinancialAdvisor.classifiersystem_AMCs;
else
    error('The agent class is unknown to EWA learning implementation')
end


%Update the experience weight in the household's private classifiersystem:
experience_old = agent.classifiersystem.experience;
experience_new = rho * experience_old + 1;
agent.classifiersystem.experience = experience_new;

%The list of rule name identifiers:

for j=1:numel(RuleNames)

    RuleID         = RuleNames{j,1};
    current_rule   = agent.classifiersystem.current_rule;
    attr           = agent.classifiersystem.(RuleID).attraction;

    %COPY avgperformance of the rule obtained from the FinancialAdvisor agent:
    avgperformance = FinancialAdvisor_classifiersystem_tmp.(RuleID).avgperformance;
    agent.classifiersystem.(RuleID).avgperformance = avgperformance;

    %Attraction for the used rule:
    if strcmp(current_rule,RuleID)
        agent.classifiersystem.(RuleID).attraction = (rho * experience_old * attr + avgperformance) / experience_new;
    end;
    
    %Attraction for the non-used rules:
    if (~strcmp(current_rule,RuleID))
        agent.classifiersystem.(RuleID).attraction = (rho * experience_old * attr + delta * avgperformance) / experience_new;
    end;
    
    attr = agent.classifiersystem.(RuleID).attraction;
%    fprintf('\r paused in attraction');

    if isinf(attr)
        fprintf('Error in AFM_EWA_learning, line 84: attraction and avgperformance have the values: %2.2f, %2.2f', attr, avgperformance);
    end;
end;

%fprintf('\r Exiting agent_EWA_updating_attractions');
