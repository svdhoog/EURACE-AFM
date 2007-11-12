function[total_payout]=DBAMCs_coupons_income()

global Parameters DBAMCs DBFinancialAssets 

AMCsIds = fieldnames(DBAMCs);

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrFinancialAssetsIds = numel(FinancialAssetsIds);

m = Parameters.current_month;

total_payout = 0;
for fa=1:NrFinancialAssetsIds
    idAsset = FinancialAssetsIds{fa,1};
    asset = DBFinancialAssets.(idAsset);
    if strcmp(asset.class,'bond')
        if ismember(Parameters.current_day,asset.CouponsPaymentDays)
            for a=1:numel(AMCsIds)
                idAMC = AMCsIds{a,1};
                AMC = DBAMCs.(idAMC);
                coupons_income = agent_coupons_income_computing(AMC,asset);
                if isnan(AMC.coupons_income(m))
                    AMC.coupons_income(m) = coupons_income;
                else
                    AMC.coupons_income(m) = AMC.coupons_income(m)+coupons_income;
                end
                if isnan(AMC.capital_gross_income(m))
                    AMC.capital_gross_income(m) = coupons_income;
                else
                    AMC.capital_gross_income(m) = AMC.capital_gross_income(m)+coupons_income;
                end
                total_payout = total_payout + coupons_income;
                DBAMCs.(idAMC) = AMC;
                clear idAMC AMC coupons_income
            end
            clear idAsset asset 
        end
    end
end



