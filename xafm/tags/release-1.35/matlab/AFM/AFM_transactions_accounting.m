households_transactions_accounting = DBHouseholds_transactions_accounting_aggregation(current_day);
AMCs_transactions_accounting = DBAMCs_transactions_accounting_aggregation(current_day);

if Parameters.prompt_print == 1
    fprintf('\r\r Aggregate transaction accounting:')
    fprintf('\r\t Households: %f',households_transactions_accounting)
    fprintf('\r\t AMCs: %f',AMCs_transactions_accounting)
    fprintf('\r\t Government: %f',...
        Government.portfolio.transactions_accounting(current_day))
    fprintf('\r\t Pension Fund Manager: %f',...
        PensionFundManager.portfolio.transactions_accounting(current_day))
end 