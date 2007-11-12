function[aggregate_value]=DBAMCs_liquid_assets_wealth_aggregation(tau)

global Parameters DBAMCs  

AMCsIds = fieldnames(DBAMCs);

aggregate_value = 0;
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    aggregate_value = aggregate_value + AMC.liquid_assets_wealth(tau);
    clear AMC
end