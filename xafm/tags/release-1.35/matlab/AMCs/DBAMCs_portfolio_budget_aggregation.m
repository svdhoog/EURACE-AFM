function[aggregate_value]=DBAMCs_portfolio_budget_aggregation(tau)

global Parameters DBAMCs  

t = Parameters.current_day;

AMCsIds = fieldnames(DBAMCs);

aggregate_value = 0;
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    aggregate_value = aggregate_value + AMC.portfolio_budget(t);
    clear AMC
end