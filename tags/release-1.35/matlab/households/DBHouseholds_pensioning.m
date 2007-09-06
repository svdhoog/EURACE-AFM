function[NrHouseholds_active, NrHouseholds_pensioned]=DBHouseholds_pensioning

global Parameters DBHouseholds PensionFundManager wage

HouseholdsIds = fieldnames(DBHouseholds);

m = Parameters.current_month;

NrHouseholds_pensioned = 0;
NrHouseholds_active = 0;

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    if (household.age>=Parameters.Households.RetirementAge)
        NrHouseholds_pensioned = NrHouseholds_pensioned + 1;
        if household.pension_state==0 %% transition to pension now
            household.pension_state = 1;
            household.private_pension = ...
                (1/12)*Parameters.PensionFundManager.PaymentRate*...
                household.pension_fund_quotes(m-1)*PensionFundManager.quote_value(m-1);
            household.public_pension = ...
                Parameters.GovernmentPolicy.LastWagePublicPensionSubstitutionRate*wage(m-1);
        end
    else
        NrHouseholds_active = NrHouseholds_active + 1;
    end
    DBHouseholds.(id) = household;
    clear tmp household
end