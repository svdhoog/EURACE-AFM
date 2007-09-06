function[]=DBHouseholds_trading_activity

global Parameters DBHouseholds 

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

NrHouseholdsActiveTraders = 0;

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    household = agent_trading_activity(household);
    NrHouseholdsActiveTraders = NrHouseholdsActiveTraders + household.trading_activity(t);
    DBHouseholds.(id) = household;
    clear id household
end

if Parameters.prompt_print==1
    fprintf('\r\r Nr Households active traders: %d',NrHouseholdsActiveTraders)
end