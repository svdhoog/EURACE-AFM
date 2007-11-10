function[agent]=agent_EWA_selecting_strategy(agent, probabilities)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECTING A STRATEGY ACCORDING TO THE CHOICE PROBABILITIES
% in the agent's internal Learning Classifier System
%
% Input: 
% p: probability distribution over the rules
%
% Output:
% struct agent with an updated field household.PortfolioAllocationRule
%
% Functionality:
% - Select a new strategy according to the cumulative pdf function
% - Set the agent's new selected rule in its struct household.PortfolioAllocationRule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs TESTMODE

%fprintf('\r Entering agent_EWA_selecting_strategies');

%probabilities
%fprintf('\r In selecting');
%pause;

if strcmp(agent.class,'household')
    RuleNames = fieldnames(DBPortfolioAllocationRulesHouseholds);
elseif strcmp(agent.class,'AMC')
    RuleNames = fieldnames(DBPortfolioAllocationRulesAMCs);   
else
    error('The agent class is unknown to EWA learning implementation')
end

NrRuleNames = numel(RuleNames);
probabilities = zeros(1,NrRuleNames);

for i=1:NrRuleNames
    RuleName = RuleNames{i,1};
    probabilities(i) = agent.classifiersystem.(RuleName).choiceprob;
end

if abs(sum(probabilities)-1)>1e-3
    fprintf('\r sum of choice probabilities: %d',sum(probabilities))
    error('The sum of choice probabilities is different from 1')
end
%Selecting a new strategy according to the cumulative pdf function:
cpdf = cumsum(probabilities);

%%Random number generator:
%To reset to a different seed each time:
rand('state',sum(100*clock));

%Draw a uniform random:
u=rand;

nr_selected_rule=nan;

%Case 1: u<F(1)
if (0<=u & u<cpdf(1))
    nr_selected_rule=1;
end;

%Case 2: Now travers the cpdf until u > F(j-1): F(j-1)<= u < F(j) 
for j=2:numel(cpdf)
    if (cpdf(j-1)<= u & u<cpdf(j))
        nr_selected_rule=j;
        break;
    end;
end;

%Case 3: F(J)<= u
if (cpdf(end)<= u)
    nr_selected_rule=numel(cpdf);
end;

%Test:
if( isnan(nr_selected_rule))
    fprintf('\r Error in agent_EWA_selecting_strategy: No rule selected from choice probabilities');
    fprintf('\r Random draw: %2.2f, min: %2.2f, max: %2.2f, elements: %d', u, cpdf(1), cpdf(end), numel(cpdf));
end;

%Get the id of the selected rule:
RuleName_selected = RuleNames{nr_selected_rule,1};
if strcmp(agent.class,'household')
    PortfolioAllocationRule_selected = DBPortfolioAllocationRulesHouseholds.(RuleName_selected);
elseif strcmp(agent.class,'AMC')
    PortfolioAllocationRule_selected = DBPortfolioAllocationRulesAMCs.(RuleName_selected);  
else
    error('The agent class is unknown to EWA learning implementation')
end

%Set the household's newly selected rule: copy the rule from the rule database
agent.PortfolioAllocationRule = PortfolioAllocationRule_selected;

%In the classifiersystem we set only the name:
old_rule=agent.classifiersystem.current_rule;
agent.classifiersystem.current_rule = RuleName_selected;

%Clear the my_performance field in the old rule:
agent.classifiersystem.(old_rule).my_performance=0;

if TESTMODE
    if ~strcmp(old_rule, agent.classifiersystem.current_rule)
        fprintf('\r Rule change for %s: %s -> %s', agent.id, old_rule, agent.classifiersystem.current_rule);
        %fprintf('\r paused in line 77, agent_EWA_selecting_strategy');
        %pause;
    end;
end;

%fprintf('\r Exiting agent_EWA_selecting_strategies'); 