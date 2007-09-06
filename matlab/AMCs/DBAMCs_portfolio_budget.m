function[]=DBAMCs_portfolio_budget

global Parameters DBAMCs  

t = Parameters.current_day;

AMCsIds = fieldnames(DBAMCs);

for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);

    AMC.portfolio_budget(t) = AMC.liquid_assets_wealth(t-1) + ...
        AMC.portfolio.bank_account(t-1);
    
    if AMC.portfolio_budget(t)<0
        warning('AMC portfolio_budget less than zero')
        fprintf('\r AMC id: %s',AMC.id)
        AMC.portfolio_budget(t) = 0;
    end

    DBAMCs.(id) = AMC;
    clear AMC
end