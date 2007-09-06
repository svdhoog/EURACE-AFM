current_month = Parameters.current_month;

AggregateHouseholdsCapitalIncome(current_month) = DBHouseholds_capital_income_aggregation(current_month);
AggregateAMCsCapitalIncome(current_month) = DBHouseholds_capital_income_aggregation(current_month);
AggregateCapitalIncome(current_month) = AggregateHouseholdsCapitalIncome(current_month) +...
    AggregateAMCsCapitalIncome(current_month) + PensionFundManager.capital_income(current_month);

if Parameters.prompt_print==1
    fprintf('\r\r Aggregate capital income')
    fprintf('\r Households: %f',AggregateHouseholdsCapitalIncome(current_month))
    fprintf('\r AMCs capital income: %f',AggregateAMCsCapitalIncome(current_month))
    fprintf('\r Pension Fund Manager capital income: %f',PensionFundManager.capital_income(current_month))
    fprintf('\r\r Aggregate value',AggregateCapitalIncome(current_month))
end

