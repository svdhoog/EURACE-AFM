function[tmp]=DBHouseholds_bank_account_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

tmp = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    tmp = tmp + household.portfolio.bank_account(tau);
    clear household
end