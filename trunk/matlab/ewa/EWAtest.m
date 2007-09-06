%SCRIPT TEST_AFM_EWA_learning

% Description: 
% EWAtest is a script to test the AFM_EWA_learning routine.

disp('STARTING EWAtest');

disp('EWA parameters used:');
disp('rho=1: experience is counting observations.');
disp('delta=1: the law of simulated effect is used to evaluate non-selected rules.')
disp('phi=0: attraction=performance; to keep things simple.');
Parameters.Households.EWA_learning
disp('Press any key to continue...');
pause;
disp('----------------------------------------------------------------------------');
disp('Running AFM_initialization');
AFM_initialization;

disp('Initialization of Classifier System completed. See CS.txt.');

print_classifiersystem;
disp('Output written to: ./CS.txt');
disp('Read this file to check classifier systems of all households.'); 
disp('----------------------------------------------------------------------------');

disp('Simulation parameters used:');
string=sprintf('NrMonths = %d', NrMonths);disp(string);
string=sprintf('NrDaysInMonth = %d', NrDaysInMonth);disp(string);
string=sprintf('NrMonthsInitialization = %d', NrMonthsInitialization);disp(string);
string=sprintf('NrHouseholds = %d', NrHouseholds);disp(string);
string=sprintf('NrFirms = %d', NrFirms);disp(string);

disp('Press any key to continue...');
pause;

disp('Running AFM_simulation');
AFM_simulation;

disp('----------------------------------------------------------------------------');
disp('After running AFM_simulation');
disp('Consider the first household that is in the asset market');
FinancialMarketParticipantsIDs = fieldnames(DBFinancialMarketParticipants);
household= FinancialMarketParticipantsIDs{1,1};
disp('----------------------------------------------------------------------------');
RuleID = DBHouseholds.(household).classifiersystem.current_rule;
string=sprintf('%s current_rule is given by: %s', household, RuleID);
disp(string);

disp('The current_rule properties are:');
DBHouseholds.(household).classifiersystem.(RuleID)

disp('The same rule properties in the FinancialAdvisor is:');
FinancialAdvisor.classifiersystem.(RuleID)

disp('Note that the FinancialAdvisor does not have a my_performance and choice prob entry.');
disp('----------------------------------------------------------------------------');
disp('The rule properties in the DBPortfolioAllocationRules is:');
DBPortfolioAllocationRules.(RuleID)
disp('----------------------------------------------------------------------------');
disp('Press any key to continue...');
pause;

disp('----------------------------------------------------------------------------');
disp('After running EWAtest');
disp('----------------------------------------------------------------------------');
print_classifiersystem;
disp('Output written to: ./CS.txt');
disp('Read this file to check classifier systems of all households.'); 
disp('----------------------------------------------------------------------------'); 

