
[aggregate_households_net_income, aggregate_labor_taxation, aggregate_pension_taxation, ...
    aggregate_households_capital_taxation]=DBHouseholds_net_income_and_taxation;
AggregateHouseholdsCapitalTaxation(current_month) = aggregate_households_capital_taxation;
AggregateLaborTaxation(current_month) = aggregate_labor_taxation;
AggregatePensionTaxation(current_month) = aggregate_pension_taxation;
AggregateHouseholdsNetIncome(current_month) = aggregate_households_net_income;

[aggregate_capital_net_income, aggregate_AMCs_capital_taxation]=...
    DBAMCs_net_capital_income_and_taxation();
AggregateAMCsCapitalTaxation(current_month) = aggregate_AMCs_capital_taxation;
AggregateAMCsCapitalNetCapitalIncome(current_month) = aggregate_capital_net_income;

PensionFundManager.capital_net_income(current_month) = ...
    (1-Parameters.GovernmentPolicy.CapitalTaxRate)*PensionFundManager.capital_gross_income(current_month);
PensionFundManager.capital_taxation(current_month) = ...
    Parameters.GovernmentPolicy.CapitalTaxRate*PensionFundManager.capital_gross_income(current_month);


%    fprintf('\r\r Beginning of month consumption budget',current_month,current_day)

if Parameters.prompt_print==1
    fprintf('\r\r Aggregate income and taxation')

    fprintf('\r Households:')
    fprintf('\r\t aggregate labor taxation: %f',AggregateLaborTaxation(current_month))
    fprintf('\r\t aggregate pension taxation: %f',AggregatePensionTaxation(current_month))
    fprintf('\r\t aggregate capital taxation: %f',AggregateHouseholdsCapitalTaxation(current_month))
    fprintf('\r\t aggregate net income: %f',AggregateHouseholdsNetIncome(current_month))

    fprintf('\r AMCs:')
    fprintf('\r\t aggregate capital taxation: %f',AggregateAMCsCapitalTaxation(current_month))
    fprintf('\r\t aggregate capital net income: %f',AggregateAMCsCapitalNetIncome(current_month))

    fprintf('\r Pension Fund Manager:')
    fprintf('\r\t capital taxation: %f',PensionFundManager.capital_taxation(current_month))
    fprintf('\r\t capital net income: %f',PensionFundManager.capital_net_income(current_month))

    est(current_month) = yearly_average_cash_flow_yield_estimate;
    fprintf('\r\r yearly_average_cash_flow_yield_estimate: %2.3f',est(current_month))
end

