function[age_avg]=DBHouseholds_age_advancement

global Parameters DBHouseholds PensionFundManager

HouseholdsId = fieldnames(DBHouseholds);

age_avg = 0;

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household.age = household.age + 1;
    age_avg = age_avg+household.age;
    DBHouseholds.(id) = household;
    clear tmp household
end

age_avg = age_avg/Parameters.NrHouseholds;