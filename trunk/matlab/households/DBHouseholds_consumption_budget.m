function[]=DBHouseholds_consumption_budget()

global Parameters DBHouseholds  

HouseholdsId = fieldnames(DBHouseholds);

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household = household_consumption_budget_computing(household);
    DBHouseholds.(id) = household;
    clear household
end