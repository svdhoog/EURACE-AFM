%function DBPortfolioAllocationRulesAMCs_utilization_print
%Prints a utilization_array and a performance_array containing arrays with the user count and avg. performance for each rule.
%Sander van der Hoog (svdhoog@gmail.com, version 31 August, 2007

function [DBPortfolioAllocationRulesAMCs_utilization_array, DBPortfolioAllocationRulesAMCs_performance_array] = ...
DBPortfolioAllocationRulesAMCs_utilization_print()

global Parameters DBAMCs DBPortfolioAllocationRulesAMCs FinancialAdvisor;

PortfolioAllocationRules = fieldnames(DBPortfolioAllocationRulesAMCs);

AMCsIds = fieldnames(DBAMCs);
if Parameters.prompt_print==1
    fprintf('\r\r AMCs: Current utilization of portfolio allocation rules')
    fprintf('\r Nr AMCs: %d',numel(AMCsIds))
end;

s = 0;
for i=1:numel(PortfolioAllocationRules)
    RuleName = PortfolioAllocationRules{i,1};
    u = FinancialAdvisor.classifiersystem_AMCs.(RuleName).counter;
    DBPortfolioAllocationRulesAMCs_utilization_array(i) = u;
    p = FinancialAdvisor.classifiersystem_AMCs.(RuleName).avgperformance;
    DBPortfolioAllocationRulesAMCs_performance_array(i) = p;
    if Parameters.prompt_print==1
        fprintf('\r\t %s: \t %d',RuleName,u)
    end
    s = s + u;
    clear RuleName u
end
if Parameters.prompt_print==1
    fprintf('\r Total utilization: %d\n',s)
end
