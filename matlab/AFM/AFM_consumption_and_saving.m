
DBHouseholds_consumption_budget
AggregateCashOnHands(current_month) = DBHouseholds_cash_on_hands_aggregation(current_month);
[AggregateConsumptionBudget(current_month), AggregatePensionFundSaving(current_month),...
    AggregateTaxDetraction(current_month), Aggregate_x_hat(current_month),...
    Aggregate_ni_hat(current_month), NrActiveAgents(current_month)]= ...
    DBHouseholds_consumption_budget_aggregation(current_month);

PensionFundManager.portfolio.bank_account(current_day-1) = ...
    PensionFundManager.portfolio.bank_account(current_day-1)+...
    PensionFundManager.capital_net_income(current_month)+...
    AggregatePensionFundSaving(current_month) - AggregatePrivatePensionIncome(current_month);


if Parameters.prompt_print==1
    fprintf('\r\r Consumption and saving by households:')
    fprintf('\r\t CashOnHands: %f',AggregateCashOnHands(current_month))
    fprintf('\r\t ConsumptionBudget: %f',AggregateConsumptionBudget(current_month))
    fprintf('\r\t PensionFundSaving: %f',AggregatePensionFundSaving(current_month))
    fprintf('\r\t TaxDetraction: %f',AggregateTaxDetraction(current_month))
    fprintf('\r\t Nr households available for a job: %d \t x_hat: %f \t ni_hat: %f',...
        NrActiveAgents(current_month),...
        Aggregate_x_hat(current_month),Aggregate_ni_hat(current_month))
end
