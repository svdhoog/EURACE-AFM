DBHouseholds_AssetsBeliefsFormation;
[HouseholdsAggregatePriceReturns(current_day,:), HouseholdsAggregateCashFlowYields(current_day,:),...
    HouseholdsAggregateTotalReturns(current_day,:), HouseholdsAgregateVolatilities(current_day,:), ...
    NrHouseholds_updating_beliefs(current_day)] = DBHouseholds_beliefs_aggregation(current_day);

DBAMCs_AssetsBeliefsFormation;
[AMCsAggregatePriceReturns(current_day,:), AMCsAggregateCashFlowYields(current_day,:),...
    AMCsAggregateTotalReturns(current_day,:), AMCsAgregateVolatilities(current_day,:), ...
    NrAMCs_updating_beliefs(current_day)] = DBAMCs_beliefs_aggregation(current_day);

if Parameters.prompt_print==1
    fprintf('\r\r Agents updating their beliefs')
    fprintf('\r\t Households: %d',NrHouseholds_updating_beliefs(current_day))
    fprintf('\r\t AMCs: %d',NrAMCs_updating_beliefs(current_day))

    AssetsIds = fieldnames(DBFinancialAssets);
    NrAssetsIds = numel(AssetsIds);

    fprintf('\r\r Average beliefs')
    fprintf('\r\t Asset \t price returns \t cash flow yield \t total returns \t volatility')
    
    fprintf('\r\t\t Households:')
    for n=1:NrAssetsIds
        id = AssetsIds{n,1};
        fprintf('\r\t %s \t\t %f \t\t %f \t\t %f \t\t %f',id,HouseholdsAggregatePriceReturns(current_day,n),...
            HouseholdsAggregateCashFlowYields(current_day,n),HouseholdsAggregateTotalReturns(current_day,n),...
            HouseholdsAgregateVolatilities(current_day,n))
        clear id
    end

    fprintf('\r\t\t AMC:')
    if Parameters.NrAMCs>0
        for n=1:NrAssetsIds
            id = AssetsIds{n,1};
            fprintf('\r\t Asset: %s \t %f \t %f \t %f \t %f',id,AMCsAggregatePriceReturns(current_day,n),...
                AMCsAggregateCashFlowYields(current_day,n),AMCsAggregateTotalReturns(current_day,n),...
                AMCsAgregateVolatilities(current_day,n))
            clear id
        end
    end
end