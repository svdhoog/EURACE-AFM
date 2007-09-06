function[total_payout]=DBAMCs_dividends_income()

global Parameters DBAMCs

m = Parameters.current_month;

AMCsId = fieldnames(DBAMCs);

total_payout = 0;

for a=1:numel(AMCsId)
    id = AMCsId{a,1};
    AMC = DBAMCs.(id);
    AMC.dividends_income(m) = agent_dividends_income_computing(AMC);
    if isnan(AMC.capital_gross_income(m))
        AMC.capital_gross_income(m) = AMC.dividends_income(m);
    else
        AMC.capital_gross_income(m) = ...
            AMC.capital_gross_income(m) + AMC.dividends_income(m);
    end
    DBAMCs.(id) = AMC;
    total_payout = total_payout + AMC.dividends_income(m);
end