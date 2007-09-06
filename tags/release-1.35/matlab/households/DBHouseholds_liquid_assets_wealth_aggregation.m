function[aggregate_value]=DBHouseholds_liquid_assets_wealth_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_value = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    aggregate_value = aggregate_value + household.liquid_assets_wealth(tau);
    clear household
end