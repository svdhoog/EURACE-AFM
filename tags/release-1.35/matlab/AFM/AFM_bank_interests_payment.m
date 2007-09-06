if ismember(current_day,BankInterestsPaymentMonthlyDays)
    aggregate_households_bank_interests_payout = DBHouseholds_bank_interests_income;
    aggregate_AMCs_bank_interests_payout = DBAMCs_bank_interests_income;
    PensionFundManager_bank_interests_payout = PensionFundManager_bank_interests_income;
    aggregate_bank_interests_payout = aggregate_households_bank_interests_payout + ...
        aggregate_AMCs_bank_interests_payout+PensionFundManager_bank_interests_payout;
    if Parameters.prompt_print==1
        fprintf('\r\r Bank Interests payment:')
        fprintf('\r\t aggregate payout to households: %f',aggregate_households_bank_interests_payout)
        fprintf('\r\t aggregate payout to AMCs: %f',aggregate_AMCs_bank_interests_payout)
        fprintf('\r\t aggregate payout to the Pension Fund Manager: %f',PensionFundManager_bank_interests_payout)
        fprintf('\r\t overall aggregate: %f',aggregate_bank_interests_payout)
    end
else
    if Parameters.prompt_print==1
        fprintf('\r\r No bank Interests payment')
    end
end
