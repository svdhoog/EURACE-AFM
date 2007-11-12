function[]=DBAMCs_EWA_learning()    


global DBAMCs Parameters

t = Parameters.current_day;
AMCsIds = fieldnames(DBAMCs);

for a=1:numel(AMCsIds);
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    if AMC.beliefs_update(t)==1
        if Parameters.prompt_print==1
            fprintf('\r %s EWA learning: computation of attractions and probabilities, and choice of the new portfolio allocation rule',AMC.id)
        end
        AMC = agent_EWA_updating_attractions(AMC);
        AMC = agent_EWA_updating_choiceprobabilities(AMC);
        AMC = agent_EWA_selecting_strategy(AMC);
        DBAMCs.(id)=AMC;
    end
    clear id AMC probabilities
end


