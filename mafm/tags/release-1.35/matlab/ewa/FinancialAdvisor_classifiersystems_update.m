function[]=FinancialAdvisor_classifiersystems_update()

global DBHouseholds DBAMCs FinancialAdvisor 
global DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs 
global Parameters

t = Parameters.current_day;

% Reset all performances and user counters for all RuleIDs in the FinancialAdvisor classifier system for Households:
PortfolioAllocationRulesHouseholds_names   = fieldnames(DBPortfolioAllocationRulesHouseholds);
for i=1:numel(PortfolioAllocationRulesHouseholds_names)
    RuleID = PortfolioAllocationRulesHouseholds_names{i,1};    
    FinancialAdvisor.classifiersystem_Households.(RuleID).performance = 0;
    FinancialAdvisor.classifiersystem_Households.(RuleID).counter = 0;
    FinancialAdvisor.classifiersystem_Households.(RuleID).avgperformance = 0;
    clear RuleID
end;

% Reset all performances and user counters for all RuleIDs in the FinancialAdvisor classifier system for AMCs:
PortfolioAllocationRulesAMCs_names   = fieldnames(DBPortfolioAllocationRulesAMCs);
for i=1:numel(PortfolioAllocationRulesAMCs_names)
    RuleID = PortfolioAllocationRulesAMCs_names{i,1};    
    FinancialAdvisor.classifiersystem_AMCs.(RuleID).performance = 0;
    FinancialAdvisor.classifiersystem_AMCs.(RuleID).counter = 0;
    FinancialAdvisor.classifiersystem_AMCs.(RuleID).avgperformance = 0;
    clear RuleID
end;

%The FinancialAdvisor collect the performance of households:
if strcmp(Parameters.Households.Learning,'EWA')
    HouseholdsIds = fieldnames(DBHouseholds);
    for h=1:numel(HouseholdsIds);
        id = HouseholdsIds{h,1};
        household = DBHouseholds.(id);
        current_rule = household.classifiersystem.current_rule;
        my_performance = household.classifiersystem.(current_rule).my_performance;

        FinancialAdvisor.classifiersystem_Households.(current_rule).performance = ...
            FinancialAdvisor.classifiersystem_Households.(current_rule).performance + my_performance;
        FinancialAdvisor.classifiersystem_Households.(current_rule).counter     = ...
            FinancialAdvisor.classifiersystem_Households.(current_rule).counter + 1;
        %Normalise the performance to account for multiple agents using the same rule:
        FinancialAdvisor.classifiersystem_Households.(current_rule).avgperformance = ...
            FinancialAdvisor.classifiersystem_Households.(current_rule).performance/FinancialAdvisor.classifiersystem_Households.(current_rule).counter;

        clear current_rule my_performance
        clear id household
    end
end


%The FinancialAdvisor collect the performance of AMCs:
AMCsIds = fieldnames(DBAMCs);
for a=1:numel(AMCsIds);
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);

    if strcmp(AMC.learning,'EWA')
        current_rule = AMC.classifiersystem.current_rule;
        my_performance = AMC.classifiersystem.(current_rule).my_performance;

        %The FinancialAdvisor collect the formance:
        FinancialAdvisor.classifiersystem_AMCs.(current_rule).performance = ...
            FinancialAdvisor.classifiersystem_AMCs.(current_rule).performance + my_performance;
        FinancialAdvisor.classifiersystem_AMCs.(current_rule).counter = ...
            FinancialAdvisor.classifiersystem_AMCs.(current_rule).counter + 1;
        %Normalise the performance to account for multiple agents using the same rule:
        FinancialAdvisor.classifiersystem_AMCs.(current_rule).avgperformance = ...
            FinancialAdvisor.classifiersystem_AMCs.(current_rule).performance/FinancialAdvisor.classifiersystem_AMCs.(current_rule).counter;

    end
    clear current_rule my_performance
    clear id AMC
end