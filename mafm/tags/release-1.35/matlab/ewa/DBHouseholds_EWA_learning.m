function[]=DBHouseholds_EWA_learning()    


global DBHouseholds Parameters

t = Parameters.current_day;
HouseholdsIds = fieldnames(DBHouseholds);

for h=1:numel(HouseholdsIds);
    id = HouseholdsIds{h,1};
    household = DBHouseholds.(id);
    if household.beliefs_update(t)==1
        household = agent_EWA_updating_attractions(household);
        household = agent_EWA_updating_choiceprobabilities(household);
        household = agent_EWA_selecting_strategy(household);
        DBHouseholds.(id)=household;
    end
    clear id household probabilities
end


