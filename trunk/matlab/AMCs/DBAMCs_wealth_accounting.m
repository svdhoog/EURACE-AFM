function[]=DBAMCs_wealth_accounting

global Parameters DBAMCs  

t = Parameters.current_day;

AMCsIds = fieldnames(DBAMCs);

for a=1:length(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);

    AMC.liquid_assets_wealth(t) = agent_liquid_assets_wealth_computing(t,AMC);
    
    AMC.portfolio.bank_account(t) = AMC.portfolio.bank_account(t-1) + ...
        AMC.portfolio.transactions_accounting(t);

    DBAMCs.(id) = AMC;
    clear AMC
end