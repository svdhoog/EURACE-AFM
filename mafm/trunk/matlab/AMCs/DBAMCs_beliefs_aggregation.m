function[PriceReturns_avg, CashFlowYields_avg, TotalReturns_avg, Volatilities_avg, ...
    NrAMCs_updatng_beliefs]= DBAMCs_beliefs_aggregation(tau)

global Parameters DBAMCs DBFinancialAssets 

AMCsIds = fieldnames(DBAMCs);
FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssets = numel(FinancialAssetsIds);

NrAMCs_updatng_beliefs = 0;
PriceReturns_tmp = zeros(1,NrFinancialAssets);
CashFlowYields_tmp = zeros(1,NrFinancialAssets);
TotalReturns_tmp = zeros(1,NrFinancialAssets);
Volatilities_tmp = zeros(1,NrFinancialAssets);

for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    if AMC.beliefs_update(tau)==1
        if sum(strcmp(FinancialAssetsIds,AMC.assets_ids))~=NrFinancialAssets
            error('An AMC assets_ids is different from FinancialAssetsIds')
        end
        NrAMCs_updatng_beliefs = NrAMCs_updatng_beliefs + 1;
        PriceReturns_tmp = PriceReturns_tmp + AMC.beliefs.AssetsExpectedPriceReturns;
        CashFlowYields_tmp = CashFlowYields_tmp + AMC.beliefs.AssetsExpectedCashFlowYield;
        TotalReturns_tmp = TotalReturns_tmp + AMC.beliefs.AssetsExpectedTotalReturns;
        Volatilities_tmp = Volatilities_tmp + AMC.beliefs.AssetsVolatilities;
    end
    clear AMC
end
        
if NrAMCs_updatng_beliefs>0
    PriceReturns_avg = PriceReturns_tmp/NrAMCs_updatng_beliefs;
    CashFlowYields_avg = CashFlowYields_tmp/NrAMCs_updatng_beliefs;
    TotalReturns_avg = TotalReturns_tmp/NrAMCs_updatng_beliefs;
    Volatilities_avg = Volatilities_tmp/NrAMCs_updatng_beliefs;
else
    PriceReturns_avg = NaN;
    CashFlowYields_avg = NaN;
    TotalReturns_avg = NaN;
    Volatilities_avg = NaN;
end