function[aggregate_capital_net_income, aggregate_capital_taxation]=...
    DBAMCs_net_capital_income_and_taxation()

global Parameters DBAMCs  

AMCsIds = fieldnames(DBAMCs);

m = Parameters.current_month;

aggregate_capital_net_income = 0;
aggregate_capital_taxation = 0;

for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);

    if ~isnan(AMC.capital_gross_income(m))
        AMC.capital_net_income(m) = (1-Parameters.GovernmentPolicy.CapitalTaxRate)*AMC.capital_gross_income(m);
        aggregate_capital_net_income = aggregate_capital_net_income + AMC.capital_net_income(m);
        AMC.capital_taxes(m) = Parameters.GovernmentPolicy.CapitalTaxRate*AMC.capital_gross_income(m);
        aggregate_capital_taxation = aggregate_capital_taxation + AMC.capital_taxes(m);
    end

    aggregate_capital_net_income = aggregate_capital_net_income + AMC.capital_net_income(m);

    DBAMCs.(id) = AMC;

    clear AMC
end