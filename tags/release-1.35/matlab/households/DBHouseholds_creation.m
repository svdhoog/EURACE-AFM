function[]=DBHouseholds_creation(Parameters)

% Description:
% create the struct DBHouseholds
%
% Input arguments:
% Parameters: struct containing all the Parameters of the simulation

% Output arguments: None
% (the function writes on the global variable DBHouseholds)
% 
% Version 1.0 of June 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)
%
% CHANGES:
% 14/07/2007: Merged with ewa_learning files

global DBFinancialAssets DBHouseholds DBFinancialAdvisor

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

DBHouseholds.dummy = 'Dummy';

for fa=1:NrFinancialAssetsIds
    id = FinancialAssetsIds{fa,1};
    asset = DBFinancialAssets.(id);
    if rem(asset.NrOutStandingShares(Parameters.NrDaysInitialization),Parameters.NrHouseholds)==0
        NrShares_percapita.(id) = ...
            asset.NrOutStandingShares(Parameters.NrDaysInitialization)/Parameters.NrHouseholds;
    else
        error('The number of outstanding shares of the asset is not equally divisible')
    end
    clear asset id
end

%Create the household's entry in the DB
for h=1:Parameters.NrHouseholds
    id = num2str(h);
    household = household_creation(id,NrShares_percapita);
    DBHouseholds = addDB(DBHouseholds,household);
    clear household
end

DBHouseholds = rmfield(DBHouseholds,'dummy');
clear id idi idj RuleNames RuleID; 
  
    
     

