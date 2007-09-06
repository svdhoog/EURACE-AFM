if ismember(current_day,DividendsPaymentMonthlyDays)

    aggregate_households_dividends_payout = DBHouseholds_dividends_income;
    aggregate_AMCs_dividends_payout = DBAMCs_dividends_income;
    pension_fund_manager_dividends_payout = PensionFundManager_dividends_income;
    aggregate_dividends_payout = aggregate_households_dividends_payout + ...
        aggregate_AMCs_dividends_payout+pension_fund_manager_dividends_payout;
    if Parameters.prompt_print==1
        fprintf('\r\r Aggregate stock dividends payment: ')
        fprintf('\r\t aggregate payout to households: %f',...
            aggregate_households_dividends_payout)
        fprintf('\r\t aggregate payout to AMCs: %f',...
            aggregate_AMCs_dividends_payout)
        fprintf('\r\t aggregate payout to the Pension Fund Manager: %f',...
            pension_fund_manager_dividends_payout)
        fprintf('\r\t overall aggregate: %f',aggregate_dividends_payout)
    end
else
    if Parameters.prompt_print==1
        fprintf('\r\r No stock dividends payment ')
    end
end
