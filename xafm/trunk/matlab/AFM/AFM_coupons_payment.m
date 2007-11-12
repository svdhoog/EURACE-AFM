aggregate_households_coupons_payout = DBHouseholds_coupons_income;
aggregate_AMCs_coupons_payout = DBAMCs_coupons_income;
PensionFundManager_coupons_payout = PensionFundManager_coupons_income;
aggregate_coupons_payout = aggregate_households_coupons_payout + ...
    aggregate_AMCs_coupons_payout+PensionFundManager_coupons_payout;
if aggregate_coupons_payout>0
    if Parameters.prompt_print==1
        fprintf('\r\r Bond coupons payment ')
        fprintf('\r\t aggregate payout to households: %f',aggregate_households_coupons_payout)
        fprintf('\r\t aggregate payout to AMCs: %f',aggregate_AMCs_coupons_payout)
        fprintf('\r\t aggregate payout to the Pension Fund Manager: %f',PensionFundManager_coupons_payout)
        fprintf('\r\t overall aggregate: %f',aggregate_coupons_payout)
    end
else
    if Parameters.prompt_print==1
        fprintf('\r\r No bond coupons payout')
    end
end
