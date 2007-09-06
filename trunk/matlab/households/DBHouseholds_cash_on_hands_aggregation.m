function[tmp]=DBHouseholds_cash_on_hands_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

tmp = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    tmp = tmp + household.cash_on_hands(tau);
    clear household
end