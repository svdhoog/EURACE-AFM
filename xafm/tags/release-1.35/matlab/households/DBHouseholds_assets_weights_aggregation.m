function[weights_mean, weights_all]=DBHouseholds_assets_weights_aggregation(tau)

global Parameters DBHouseholds DBFinancialAssets 

HouseholdsIds = fieldnames(DBHouseholds);
FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssets = numel(FinancialAssetsIds);

weights_mean = zeros(1,NrFinancialAssets);

n = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    if household.beliefs_update(tau)==1
        if sum(strcmp(FinancialAssetsIds,household.assets_ids))~=NrFinancialAssets
            error('An household assets_ids is different from FinancialAssetsIds')
        end
        n = n + 1;
        weights_mean = weights_mean + household.preferences.assets_weights{tau,:};
        weights_all(n,:) = household.preferences.assets_weights{tau,:};
    end

    clear household
end

weights_mean = weights_mean/n;