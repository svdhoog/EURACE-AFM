function[household]=household_ProspectMapping(household)


global Parameters DBFinancialAssets
t = Parameters.current_day;

if household.financial_activity(t)==0
        return
elseif household.financial_activity(t) == 1

    FinancialAssetsIds = fieldnames(DBFinancialAssets);
    NrAssets = numel(FinancialAssetsIds);
    utilityvector = zeros (1,NrAssets+1);
    
    for n=1:NrAssets
        id = FinancialAssetsIds{n,1};
        utilityvector(n) = household.preferences.prospectutility.(id)(t);
    end
    
    utilityvector(NrAssets+1) = household.preferences.prospectutility.SA(t);
    Prospectweights = Prospect_weights_linearmapping(utilityvector);
    
%     for n=1:NrAssets
%         id = FinancialAssetsIds{n,1};
%         household.preferences.prospectweights.(id) = Prospectweights(n);
%     end

%household.preferences.prospectweights.SA = Prospectweights(n+1);
    
household.preferences.prospectweights(t,:) = Prospectweights;
end
  
  