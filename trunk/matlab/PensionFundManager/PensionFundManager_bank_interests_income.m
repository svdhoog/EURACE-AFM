function[total_payout]=PensionFundManager_bank_interests_income()

global Parameters PensionFundManager

m = Parameters.current_month;

total_payout = agent_bank_interests_income_computing(PensionFundManager);
if isnan(PensionFundManager.capital_gross_income(m))
    PensionFundManager.capital_gross_income(m) = total_payout;
else
    PensionFundManager.capital_gross_income(m) = ...
        PensionFundManager.capital_gross_income(m) + total_payout;
end
