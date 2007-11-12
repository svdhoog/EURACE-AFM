%function DBPortfolioAllocationRulesHouseholds_utilization_print
%Prints a utilization_array and a performance_array containing arrays with the user count and avg. performance for each rule.
%Sander van der Hoog (svdhoog@gmail.com, version 31 August, 2007

function [DBPortfolioAllocationRulesHouseholds_utilization_array, DBPortfolioAllocationRulesHouseholds_performance_array] = ...
DBPortfolioAllocationRulesHouseholds_utilization_print()

global Parameters DBHouseholds DBPortfolioAllocationRulesHouseholds FinancialAdvisor;

PortfolioAllocationRules = fieldnames(DBPortfolioAllocationRulesHouseholds);

HouseholdsIds = fieldnames(DBHouseholds);
if Parameters.prompt_print==1
    fprintf('\r\r Households: Current utilization of portfolio allocation rules');
    fprintf('\r Nr Households: %d',numel(HouseholdsIds));
end

s = 0;
for i=1:numel(PortfolioAllocationRules)
    RuleName = PortfolioAllocationRules{i,1};
    u = FinancialAdvisor.classifiersystem_Households.(RuleName).counter;
    DBPortfolioAllocationRulesHouseholds_utilization_array(i) = u;
    p = FinancialAdvisor.classifiersystem_Households.(RuleName).avgperformance;
    DBPortfolioAllocationRulesHouseholds_performance_array(i) = p;
    if Parameters.prompt_print==1
        fprintf('\r\t %s: \t %d',RuleName,u)
    end
    s = s + u;
    clear RuleName u
end
if Parameters.prompt_print==1
    fprintf('\r Total utilization: %d\n',s)
end
