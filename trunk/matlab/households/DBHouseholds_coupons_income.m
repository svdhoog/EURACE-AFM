function[total_payout]=DBHouseholds_coupons_income()

global Parameters DBHouseholds DBFinancialAssets 

HouseholdsIds = fieldnames(DBHouseholds);

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

m = Parameters.current_month;

total_payout = 0;
for fa=1:NrFinancialAssetsIds
    idAsset = FinancialAssetsIds{fa,1};
    asset = DBFinancialAssets.(idAsset);
    if strcmp(asset.class,'bond')
        if ismember(Parameters.current_day,asset.CouponsPaymentDays)
            fprintf('\r Payment of coupon for bond %s to households',asset.id)
            for a=1:numel(HouseholdsIds)
                idHousehold = HouseholdsIds{a,1};
                household = DBHouseholds.(idHousehold);
                coupons_income = agent_coupons_income_computing(household,asset);
                if isnan(household.coupons_income(m))
                    household.coupons_income(m) = coupons_income;
                else
                    household.coupons_income(m) = household.coupons_income(m)+coupons_income;
                end
                if isnan(household.capital_gross_income(m))
                    household.capital_gross_income(m) = coupons_income;
                else
                    household.capital_gross_income(m) = household.capital_gross_income(m)+coupons_income;
                end
                total_payout = total_payout + coupons_income;
                DBHouseholds.(idHousehold) = household;
                clear idHousehold household coupons_income
            end
            clear idAsset asset 
        end
    end
end



