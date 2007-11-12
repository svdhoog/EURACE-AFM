function[]=DBHouseholds_AssetsBeliefsFormation()

global Parameters DBHouseholds Days DividendsPaymentDays

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

NrFinancialTraders = 0;
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    household = household_AssetsBeliefsFormation(household);
    DBHouseholds.(id) = household;
    clear household
end


