DBHouseholds_portfolio_budget
AggregateHouseholdsPortfolioBudget(current_day)=DBHouseholds_portfolio_budget_aggregation(current_day);

DBAMCs_portfolio_budget
AggregateAMCsPortfolioBudget(current_day)=DBAMCs_portfolio_budget_aggregation(current_day);


PensionFundManager.portfolio_budget(current_day) = ...
    PensionFundManager.liquid_assets_wealth(current_day-1)+...
    PensionFundManager.portfolio.bank_account(current_day-1);


if Parameters.prompt_print==1
    fprintf('\r\r Portfolio budget:')
    fprintf('\r\t Households: %f',AggregateHouseholdsPortfolioBudget(current_day))
    fprintf('\r\t AMCs: %f',AggregateAMCsPortfolioBudget(current_day))
    fprintf('\r\t Pension Fund Manager: %f',PensionFundManager.portfolio_budget(current_day))
end