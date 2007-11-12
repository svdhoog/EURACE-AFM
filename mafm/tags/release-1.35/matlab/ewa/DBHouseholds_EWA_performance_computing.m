function[]=DBHouseholds_EWA_performance_computing()

global DBHouseholds Parameters

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);

for h=1:numel(HouseholdsIds);
    id = HouseholdsIds{h,1};
    household = DBHouseholds.(id);
    household = agent_EWA_performance_computing(household);
    DBHouseholds.(id)=household;
    clear id household
end
