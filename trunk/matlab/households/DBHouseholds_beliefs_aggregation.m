function[PriceReturns_avg, CashFlowYields_avg, TotalReturns_avg, Volatilities_avg, ...
    NrHouseholds_updating_beliefs]=DBHouseholds_beliefs_aggregation(tau)

global Parameters DBHouseholds DBFinancialAssets 

HouseholdsIds = fieldnames(DBHouseholds);
FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssets = numel(FinancialAssetsIds);

weights_mean = zeros(1,NrFinancialAssets);

NrHouseholds_updating_beliefs = 0;
PriceReturns_tmp = zeros(1,NrFinancialAssets);
TotalReturns_tmp = zeros(1,NrFinancialAssets);
CashFlowYields_tmp = zeros(1,NrFinancialAssets);
Volatilities_tmp = zeros(1,NrFinancialAssets);

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    if household.beliefs_update(tau)==1
        if sum(strcmp(FinancialAssetsIds,household.assets_ids))~=NrFinancialAssets
            error('A household assets_ids is different from FinancialAssetsIds')
        end
        NrHouseholds_updating_beliefs = NrHouseholds_updating_beliefs + 1;
        PriceReturns_tmp = PriceReturns_tmp + household.beliefs.AssetsExpectedPriceReturns;
        CashFlowYields_tmp = CashFlowYields_tmp + household.beliefs.AssetsExpectedCashFlowYield;
        TotalReturns_tmp = TotalReturns_tmp + household.beliefs.AssetsExpectedTotalReturns;
        Volatilities_tmp = Volatilities_tmp + household.beliefs.AssetsVolatilities;
    end
    clear household
end

PriceReturns_avg = PriceReturns_tmp/NrHouseholds_updating_beliefs;
CashFlowYields_avg = CashFlowYields_tmp/NrHouseholds_updating_beliefs;
TotalReturns_avg = TotalReturns_tmp/NrHouseholds_updating_beliefs;
Volatilities_avg = Volatilities_tmp/NrHouseholds_updating_beliefs; 