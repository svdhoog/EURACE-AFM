function[]=DBHouseholds_wealth_accounting

global Parameters DBHouseholds  

t = Parameters.current_day;

HouseholdsId = fieldnames(DBHouseholds);

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);

    household.liquid_assets_wealth(t) = agent_liquid_assets_wealth_computing(t,household);
    
    household.portfolio.bank_account(t) = household.portfolio.bank_account(t-1) + ...
        household.portfolio.transactions_accounting(t);
    
    DBHouseholds.(id) = household;
    clear household
end