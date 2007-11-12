function[aggregate_value]=DBAMCs_capital_income_aggregation(tau)

global Parameters DBAMCs  

AMCsIds = fieldnames(DBAMCs);

aggregate_value = 0;
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    aggregate_value = aggregate_value + AMC.capital_gross_income(tau);
    clear AMC
end