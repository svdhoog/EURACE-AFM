function[tmp]=DBHouseholds_transactions_accounting_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsId = fieldnames(DBHouseholds);

tmp = 0;
for a=1:numel(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    tmp = tmp + household.portfolio.transactions_accounting(tau);
    clear household
end 