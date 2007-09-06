function[total_payout]=PensionFundManager_coupons_income()

global Parameters PensionFundManager DBFinancialAssets 

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

m = Parameters.current_month;

total_payout = 0;
for fa=1:NrFinancialAssetsIds
    idAsset = FinancialAssetsIds{fa,1};
    asset = DBFinancialAssets.(idAsset);
    if strcmp(asset.class,'bond')
        if ismember(Parameters.current_day,asset.CouponsPaymentDays)
            fprintf('\r Payment of coupon for bond %s to the Pension Fund Manager',asset.id)
            coupon_income = agent_coupons_income_computing(PensionFundManager,asset);
            if isnan(PensionFundManager.capital_gross_income(m))
                PensionFundManager.capital_gross_income(m) = coupon_income;
            else
                PensionFundManager.capital_gross_income(m) = ...
                    PensionFundManager.capital_gross_income(m)+coupon_income;
            end
            total_payout = total_payout + coupon_income;
            clear coupon_income
        end
    end
    clear idAsset asset
end





