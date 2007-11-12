function[aggregate_net_income, aggregate_labor_taxation, aggregate_pension_taxation, aggregate_capital_taxation]=...
    DBHouseholds_net_income_and_taxation()

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

m = Parameters.current_month;

aggregate_net_income = 0;
aggregate_labor_taxation = 0;
aggregate_pension_taxation = 0;
aggregate_capital_taxation = 0;

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);

    if household.age<Parameters.Households.RetirementAge
        household.net_income(m) = (1-Parameters.GovernmentPolicy.LaborTaxRate)*household.labor_gross_income(m);
        household.labor_taxes(m) = Parameters.GovernmentPolicy.LaborTaxRate*household.labor_gross_income(m);
        aggregate_labor_taxation = aggregate_labor_taxation + household.labor_taxes(m);

    else
        household.net_income(m) = (1-Parameters.GovernmentPolicy.LaborTaxRate)*...
            (household.public_pension_gross_income(m)+household.private_pension_gross_income(m));
        household.pension_taxes(m) = Parameters.GovernmentPolicy.LaborTaxRate*...
            (household.public_pension_gross_income(m)+household.private_pension_gross_income(m));
        aggregate_pension_taxation = aggregate_pension_taxation + household.pension_taxes(m);

    end

    if ~isnan(household.capital_gross_income(m))
        household.net_income(m) = household.net_income(m)+...
            (1-Parameters.GovernmentPolicy.CapitalTaxRate)*household.capital_gross_income(m);
        household.capital_taxes(m) = Parameters.GovernmentPolicy.CapitalTaxRate*household.capital_gross_income(m);
        aggregate_capital_taxation = aggregate_capital_taxation + household.capital_taxes(m);
    end

    aggregate_net_income = aggregate_net_income + household.net_income(m);

    DBHouseholds.(id) = household;

    clear household
end