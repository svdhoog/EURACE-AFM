DBHouseholds_AssetsWeightsComputing;
HouseholdsAggregateAssetsMeanWeights(current_day,:) = DBHouseholds_assets_weights_aggregation(current_day);

DBAMCs_AssetsWeightsComputing;
AMCsAggregateAssetsMeanWeights(current_day,:) = DBAMCs_assets_weights_aggregation(current_day);

PensionFundManager_AssetsWeightsComputing

if Parameters.prompt_print==1
    fprintf('\r\r Aggregate mean weights')
    AssetsIds = fieldnames(DBFinancialAssets);
    NrAssetsIds = numel(AssetsIds);;
    for n=1:NrAssetsIds
        id = AssetsIds{n,1};
        fprintf('\r\t Asset: %s \t Households: %f \t AMC: %f',id,...
            HouseholdsAggregateAssetsMeanWeights(current_day,n),AMCsAggregateAssetsMeanWeights(current_day,n))
    end
    clear id
end