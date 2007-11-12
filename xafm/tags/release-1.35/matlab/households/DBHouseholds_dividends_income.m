function[total_payout]=DBHouseholds_dividends_income()

global Parameters DBHouseholds

m = Parameters.current_month;

HouseholdsId = fieldnames(DBHouseholds);

total_payout = 0;

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household.dividends_income(m) = agent_dividends_income_computing(household);
    if isnan(household.capital_gross_income(m))
        household.capital_gross_income(m) = household.dividends_income(m);
    else
        household.capital_gross_income(m) = ...
            household.capital_gross_income(m) + household.dividends_income(m);
    end
    DBHouseholds.(id) = household;
    total_payout = total_payout + household.dividends_income(m);
end