function[agent]=agent_EWA_updating_choiceprobabilities(agent)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATING OF CHOICE PROBABILITIES
% in the agent's internal Learning Classifier System
%
% Input: 
% struct agent with current attractions
%
% Output:
% struct agent with updated choiceprobabilities
%
% Functionality:
% - Assign the choice probabilities: use either linear probabilities or the exponential multinomial logit.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs Parameters
%disp('Entering agent_EWA_updating_choiceprobabilities');


%The list of rule name identifiers:
if strcmp(agent.class,'household')
    beta   = Parameters.Households.EWA_learning.beta;
    RuleNames = fieldnames(DBPortfolioAllocationRulesHouseholds);
elseif strcmp(agent.class,'AMC')
    beta   = agent.EWA_learning.beta;
    RuleNames = fieldnames(DBPortfolioAllocationRulesAMCs);
else
    error('The agent class is unknown to EWA learning implementation')
end

sum_attr = 0;
for j=1:numel(RuleNames)
    RuleID = RuleNames{j,1};
    attr   = agent.classifiersystem.(RuleID).attraction;
            
    %Add attraction to the current sum:    
    %Using discrete choice prob (multinomial logit):
    if isinf(exp(beta * attr))
        disp('agent_EWA_updating_choiceprobabilities, line 44: Error: exp(beta * attr) equals inf.');
        pause;
    end;
    sum_attr = sum_attr + exp(beta * attr);
end;%loop over rules

%Assigning the choice probabilities after computing sum_attr:
choiceprob=[];

for j=1:numel(RuleNames)
    RuleID = RuleNames{j,1};
    attr   = agent.classifiersystem.(RuleID).attraction;
                
    %Use exponential logit probabilities (this yields more skewed probabilities)
    prob   = exp(beta * attr)/sum_attr;
    if isinf(prob)
        disp('agent_EWA_updating_choiceprobabilities, line 62: Error: prob is inf.');
        pause;
    end;
    
    if isnan(prob)
        disp('agent_EWA_updating_choiceprobabilities, line 67: probability is not properly assigned, attr and sum_attr have the values:');
        attr
        sum_attr
        pause;
    end;
    
    agent.classifiersystem.(RuleID).choiceprob = prob;
end;%loop over all rules 
%disp('Exiting agent_EWA_updating_choiceprobabilities');
