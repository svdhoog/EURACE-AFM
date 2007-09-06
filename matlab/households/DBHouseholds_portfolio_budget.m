function[]=DBHouseholds_portfolio_budget

global Parameters DBHouseholds  

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);

    household.portfolio_budget(t) = household.liquid_assets_wealth(t-1) + ...
        household.portfolio.bank_account(t-1);
    
    if household.portfolio_budget(t)<0
        warning('household.portfolio_budget less than zero')
        fprintf('\r household id: %s',household.id)
        household.portfolio_budget(t) = 0;
    end

    DBHouseholds.(id) = household;
    clear household
end