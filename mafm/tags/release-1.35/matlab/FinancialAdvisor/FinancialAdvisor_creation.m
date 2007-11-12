function[]=FinancialAdvisor_creation() 

% Description:
% create the struct FinancialAdvisor

global FinancialAdvisor DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs

FinancialAdvisor.class = 'FinancialAdvisor';
FinancialAdvisor.id = [FinancialAdvisor.class, '_', num2str(1)];

PortfolioAllocationRulesHouseholds_names = fieldnames(DBPortfolioAllocationRulesHouseholds);
FinancialAdvisor.classifiersystem_Households = classifiersystem_creation(PortfolioAllocationRulesHouseholds_names); 

PortfolioAllocationRulesAMCs_names = fieldnames(DBPortfolioAllocationRulesAMCs);
FinancialAdvisor.classifiersystem_AMCs = classifiersystem_creation(PortfolioAllocationRulesAMCs_names); 
