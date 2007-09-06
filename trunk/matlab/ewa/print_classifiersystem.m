%SCRIPT print_classifiersystem.m
%
% Description: 
% print_classifiersystem prints the classifier system per household as a table to an output file.
%
%
% Version 1.0 of July 2007
% For any comments, please contact Sander van de Hoog (svdhoog@gmail.com)

%Output file:
t = Parameters.current_day;
file=sprintf(['../log/CS_t', num2str(t), '.txt']);
FILE = fopen(file,'w');

%Print comments/notes:
    fprintf(FILE,'Logfile: Print-out of all classifier systems. \n');
    fprintf(FILE,'Note 1: The performance and counter columns for the households are copied from the FinancialAdvisors CS. \n');
    fprintf(FILE,'Note 2: The avgperformance column can contain different values for two households, since it contains the copy from the FinancialAdvisors CS at the moment of the households most recent portfolio update. \n\n');

%Print FinancialAdvisor classifier system:
    fprintf(FILE,'=============================================================================================\n');
    fprintf(FILE,'FinancialAdvisor:\n');
    fprintf(FILE,'rule\t performance\t counter\t avgperformance\t my_performance\t attraction\t choice prob\n');
    fprintf(FILE,'=============================================================================================\n'); 

    PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesHouseholds);
    for i=1:numel(PortfolioAllocationRules_names)
             RuleID = PortfolioAllocationRules_names{i,1};    
             performance=FinancialAdvisor.classifiersystem_Households.(RuleID).performance;
             counter=FinancialAdvisor.classifiersystem_Households.(RuleID).counter;
             avgperformance=FinancialAdvisor.classifiersystem_Households.(RuleID).avgperformance;
             my_performance=FinancialAdvisor.classifiersystem_Households.(RuleID).my_performance;
             attraction=FinancialAdvisor.classifiersystem_Households.(RuleID).attraction;
             choiceprob=FinancialAdvisor.classifiersystem_Households.(RuleID).choiceprob;

             fprintf(FILE,'%s\t %f\t %7d\t\t %f\t\t %f\t\t %f\t %f\n', RuleID, performance, counter, avgperformance, my_performance, attraction, choiceprob);
     end;
     fprintf(FILE,'=============================================================================================\n');

    PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesAMCs);
    for i=1:numel(PortfolioAllocationRules_names)
             RuleID = PortfolioAllocationRules_names{i,1};    
             performance=FinancialAdvisor.classifiersystem_AMCs.(RuleID).performance;
             counter=FinancialAdvisor.classifiersystem_AMCs.(RuleID).counter;
             avgperformance=FinancialAdvisor.classifiersystem_AMCs.(RuleID).avgperformance;
             my_performance=FinancialAdvisor.classifiersystem_AMCs.(RuleID).my_performance;
             attraction=FinancialAdvisor.classifiersystem_AMCs.(RuleID).attraction;
             choiceprob=FinancialAdvisor.classifiersystem_AMCs.(RuleID).choiceprob;

             fprintf(FILE,'%s\t %f\t %7d\t\t %f\t\t %f\t\t %f\t %f\n', RuleID, performance, counter, avgperformance, my_performance, attraction, choiceprob);
     end;
     fprintf(FILE,'=============================================================================================\n');


%Print per household classifier system:
 PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesHouseholds);
for h=1:Parameters.NrHouseholds
    id = num2str(h);
    household = sprintf('household_%s',id);
    
    fprintf(FILE,'=============================================================================================\n');
    fprintf(FILE,'Household: %s Current rule: %s\n', household, DBHouseholds.(household).classifiersystem.current_rule);
    fprintf(FILE,'rule\t performance\t counter\t avgperformance\t my_performance\t attraction\t choice prob\n');
    fprintf(FILE,'=============================================================================================\n'); 

    for i=1:numel(PortfolioAllocationRules_names)
             RuleID = PortfolioAllocationRules_names{i,1};    
             performance=FinancialAdvisor.classifiersystem_Households.(RuleID).performance;
             counter=FinancialAdvisor.classifiersystem_Households.(RuleID).counter;
             %performance=DBHouseholds.(household).classifiersystem.(RuleID).performance;
             %counter=DBHouseholds.(household).classifiersystem.(RuleID).counter;
             avgperformance=DBHouseholds.(household).classifiersystem.(RuleID).avgperformance;
             my_performance=DBHouseholds.(household).classifiersystem.(RuleID).my_performance;
             attraction=DBHouseholds.(household).classifiersystem.(RuleID).attraction;
             choiceprob=DBHouseholds.(household).classifiersystem.(RuleID).choiceprob;
             
             fprintf(FILE,'%s\t %f\t %7d\t\t %f\t\t %f\t\t %f\t %f\n', RuleID, performance, counter, avgperformance, my_performance, attraction, choiceprob);
     end;
     fprintf(FILE,'=============================================================================================\n');
 end; 
 
 
%Print per AMC classifier system:
AMCsIds = fieldnames(DBAMCs);
PortfolioAllocationRules_names = fieldnames(DBPortfolioAllocationRulesAMCs);
for a=1:numel(AMCsIds);
    AMC = AMCsIds{a,1};
    
    fprintf(FILE,'=============================================================================================\n');
    fprintf(FILE,'AMC: %s Current rule: %s\n', DBAMCs.(AMC).id, DBAMCs.(AMC).classifiersystem.current_rule);
    fprintf(FILE,'rule\t performance\t counter\t avgperformance\t my_performance\t attraction\t choice prob\n');
    fprintf(FILE,'=============================================================================================\n'); 

    for i=1:numel(PortfolioAllocationRules_names)
             RuleID = PortfolioAllocationRules_names{i,1};    
             performance=FinancialAdvisor.classifiersystem_AMCs.(RuleID).performance;
             counter=FinancialAdvisor.classifiersystem_AMCs.(RuleID).counter;
             %performance=DBAMCs.(AMC).classifiersystem.(RuleID).performance;
             %counter=DBAMCs.(AMC).classifiersystem.(RuleID).counter;
             avgperformance=DBAMCs.(AMC).classifiersystem.(RuleID).avgperformance;
             my_performance=DBAMCs.(AMC).classifiersystem.(RuleID).my_performance;
             attraction=DBAMCs.(AMC).classifiersystem.(RuleID).attraction;
             choiceprob=DBAMCs.(AMC).classifiersystem.(RuleID).choiceprob;
             
             fprintf(FILE,'%s\t %f\t %7d\t\t %f\t\t %f\t\t %f\t %f\n', RuleID, performance, counter, avgperformance, my_performance, attraction, choiceprob);
     end;
     fprintf(FILE,'=============================================================================================\n');
 end; 
fclose(FILE);

clear performance counter avgperformance my_performance attraction choiceprob;
return;
