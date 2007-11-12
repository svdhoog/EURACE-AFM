function[total_payout]=DBHouseholds_bank_interests_income()

global Parameters DBHouseholds

m = Parameters.current_month;

HouseholdsId = fieldnames(DBHouseholds);

total_payout = 0;

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household.bank_interests_income(m) = agent_bank_interests_income_computing(household);
    if isnan(household.capital_gross_income(m))
        household.capital_gross_income(m) = household.bank_interests_income(m);
    else
        household.capital_gross_income(m) = ...
            household.capital_gross_income(m) + household.bank_interests_income(m);
    end
    DBHouseholds.(id) = household;
    total_payout = total_payout + household.bank_interests_income(m);
end