function[aggregate_value]=DBHouseholds_portfolio_budget_aggregation(tau)

global Parameters DBHouseholds  

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_value = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    aggregate_value = aggregate_value + household.portfolio_budget(t);
    clear household
end