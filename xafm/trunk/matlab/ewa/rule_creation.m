function[rule]=rule_creation(id)

% Description:
% create the struct `rule' for use in a classifier system
%
% Input arguments:
% id: string identifying the rule
%
% Output arguments:
% rule: the struct has been created and is added to the rule set

global DBPortfolioAllocationRules

%%% Data types creation %%%
rule.class = 'PortfolioAllocationRule_metrics';
rule.id = id;
rule.performance = 0;       %total performance in agent population
rule.counter = 0;           %number of users of the rule
rule.avgperformance = 0;    %avg. performance
rule.my_performance = 0;    %performance of agent
rule.attraction = 1;        %attraction
rule.choiceprob = 0;        %choice probability 
