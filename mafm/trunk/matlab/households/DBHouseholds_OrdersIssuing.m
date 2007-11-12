function[]=DBHouseholds_OrdersIssuing()

global Parameters DBHouseholds 

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

NrActiveHouseholds = 0;

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    household = agent_OrdersIssuing(household);
    DBHouseholds.(id) = household;
    clear id household
end