function[]=DBHouseholds_pension_fund_quotes_distribution(NewQuotes,AggregatePensionFundSaving)

global Parameters DBHouseholds  

m = Parameters.current_month;

HouseholdsId = fieldnames(DBHouseholds);

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    tmp = NewQuotes*household.pension_fund_saving(m)/AggregatePensionFundSaving;
    household.pension_fund_quotes(m) = household.pension_fund_quotes(m-1) +tmp;
    DBHouseholds.(id) = household;
    clear tmp household
end