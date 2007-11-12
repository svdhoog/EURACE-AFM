function[aggregate_value]=DBHouseholds_pension_fund_quotes_aggregation

global Parameters DBHouseholds  

m = Parameters.current_month;

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_value = 0;
for a=1:length(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    aggregate_value = aggregate_value + household.pension_fund_quotes(m);
    DBHouseholds.(id) = household;
    clear household
end