AggregateHouseholdsCapitalIncome(current_month) = DBHouseholds_capital_income_aggregation(current_month);
AggregateAMCsCapitalIncome(current_month) = DBAMCs_capital_income_aggregation(current_month);
AggregateCapitalIncome(current_month) = AggregateHouseholdsCapitalIncome(current_month) +...
    AggregateAMCsCapitalIncome(current_month) + PensionFundManager.capital_gross_income(current_month);

if Parameters.prompt_print==1
    fprintf('\r\r Aggregate capital income')
    fprintf('\r\t Households: %f',AggregateHouseholdsCapitalIncome(current_month))
    fprintf('\r\t AMCs: %f',AggregateAMCsCapitalIncome(current_month))
    fprintf('\r\t Pension Fund Manager: %f',PensionFundManager.capital_gross_income(current_month))
    fprintf('\r\t Overall aggregate: %f',AggregateCapitalIncome(current_month))
end