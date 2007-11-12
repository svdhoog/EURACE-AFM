function[]=DBHouseholds_AssetsWeightsComputing()

global Parameters DBHouseholds 

t = Parameters.current_day;

HouseholdsId = fieldnames(DBHouseholds);

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household = agent_AssetsWeightsComputing(household);
    DBHouseholds.(id) = household;
    clear id household
end