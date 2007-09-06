function[aggregate_value]=DBHouseholds_capital_income_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_value = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    aggregate_value = aggregate_value + household.capital_gross_income(tau);
    clear household
end