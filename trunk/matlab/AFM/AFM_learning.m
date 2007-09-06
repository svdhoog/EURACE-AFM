if strcmp(Parameters.Households.Learning,'EWA')
    if Parameters.prompt_print==1
        fprintf('\r\r Households EWA learning: computation of performances')
    end
    DBHouseholds_EWA_performance_computing
elseif strcmp(Parameters.Households.Learning,'None')
    if Parameters.prompt_print==1
        fprintf('\r\r No learning for Households')
    end
else
    error('No kind of learning has been specified for households')
end

DBAMCs_EWA_performance_computing

FinancialAdvisor_classifiersystems_update

if Parameters.classifiersystem_print == 1
    print_classifiersystem
end

if strcmp(Parameters.Households.Learning,'EWA')
    if Parameters.prompt_print==1
        fprintf('\r Households EWA learning')
        fprintf('\t computation of attractions and probabilities, and choice of the new portfolio allocation rule')
    end
    DBHouseholds_EWA_learning
    [DBPortfolioAllocationRulesHouseholds_utilization_array(t,:), DBPortfolioAllocationRulesHouseholds_performance_array(t,:)] = ...
    DBPortfolioAllocationRulesHouseholds_utilization_print;
end

if Parameters.prompt_print==1
    fprintf('\r AMCs EWA learning');
    fprintf('\t computation of attractions and probabilities, and choice of the new portfolio allocation rule');
    DBAMCs_EWA_learning
    [DBPortfolioAllocationRulesAMCs_utilization_array(t,:), DBPortfolioAllocationRulesAMCs_performance_array(t,:)] = ...
    DBPortfolioAllocationRulesAMCs_utilization_print;
end
