function[aggregate_value_labor, aggregate_value_public_pension, aggregate_value_private_pension]=...
    DBHouseholds_labor_pension_income()

global DBHouseholds Parameters wage Government

m = Parameters.current_month;

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_value_labor = 0;
aggregate_value_public_pension = 0;
aggregate_value_private_pension = 0;

for a=1:length(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    if household.pension_state==0
        household.labor_gross_income(m) = household.labor_activity(m)*wage(m);
        aggregate_value_labor = aggregate_value_labor + household.labor_gross_income(m);
    else
        household.public_pension_gross_income(m) = household.public_pension;
        aggregate_value_public_pension = aggregate_value_public_pension + ...
            household.public_pension_gross_income(m);
      
        if ~isnan(household.private_pension)
            household.private_pension_gross_income(m) = household.private_pension;
        else
            household.private_pension_gross_income(m) = 0;
        end
        aggregate_value_private_pension = aggregate_value_private_pension + ...
            household.private_pension_gross_income(m);

    end
    DBHouseholds.(id) = household;
    clear household
end

