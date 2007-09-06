function[weights_mean, weights_all]=DBAMCs_assets_weights_aggregation(tau)

global Parameters DBAMCs DBFinancialAssets 

AMCsIds = fieldnames(DBAMCs);
FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssets = numel(FinancialAssetsIds);

weights_mean = zeros(1,NrFinancialAssets);

n = 0;
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    if AMC.beliefs_update(tau)==1
        if sum(strcmp(FinancialAssetsIds,AMC.assets_ids))~=NrFinancialAssets
            error('An AMC assets_ids is different from FinancialAssetsIds')
        end
        n = n + 1;
        weights_mean = weights_mean + AMC.preferences.assets_weights{tau,:};
        weights_all(n,:) = AMC.preferences.assets_weights{tau,:};
    end

    clear AMC
end

weights_mean = weights_mean/n;