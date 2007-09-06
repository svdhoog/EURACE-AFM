Government.tax_collection(current_month) = AggregateLaborTaxation(current_month)+...
    AggregatePensionTaxation(current_month)+AggregateHouseholdsCapitalTaxation(current_month)+...
    AggregateAMCsCapitalTaxation(current_month)+...
    +PensionFundManager.capital_taxation(current_month)-AggregateTaxDetraction(current_month);

Government.debt_service(current_month) = aggregate_coupons_payout;
Government.public_expenditure(current_month) = AggregatePublicPensionIncome(current_month);
Government.financial_budget(current_month) = Government.tax_collection(current_month)-...
    Government.public_expenditure(current_month)-Government.debt_service(current_month);
Government.debt(current_month) = Government.debt(current_month-1)+...
    Government.financial_budget(current_month);
Government.portfolio.bank_account(current_day-1) = ...
    Government.portfolio.bank_account(current_day-1)+Government.financial_budget(current_month);

if Parameters.prompt_print==1
    fprintf('\r\r Government monthly accounting:')
    fprintf('\r\t Tax collection: %f',Government.tax_collection(current_month))
    fprintf('\r\t Debt service: %f',Government.debt_service(current_month))
    fprintf('\r\t Public expenditure: %f',Government.public_expenditure(current_month))
    fprintf('\r\t Financial budget: %f',Government.financial_budget(current_month))
    fprintf('\r\t Cumulated debt: %f',Government.debt(current_month))
end 