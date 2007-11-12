if ismember(current_day,WagePaymentMonthlyDays)
    LaborMarketClearing
    [aggregate_labor_income, aggregate_public_pension_income, aggregate_private_pension_income] = ...
        DBHouseholds_labor_pension_income;
    AggregateLaborIncome(current_month) = aggregate_labor_income;
    AggregatePublicPensionIncome(current_month) = aggregate_public_pension_income;
    AggregatePrivatePensionIncome(current_month) = aggregate_private_pension_income;
    if Parameters.prompt_print==1
        fprintf('\r\r Households labor and pension income')
        fprintf('\r\t labor income: %f',AggregateLaborIncome(current_month))
        fprintf('\r\t public pension income: %f',AggregatePublicPensionIncome(current_month))
        fprintf('\r\t private pension income: %f',AggregatePrivatePensionIncome(current_month))
    end
else
    if Parameters.prompt_print==1
        fprintf('\r No labor or pension income')
    end
end
