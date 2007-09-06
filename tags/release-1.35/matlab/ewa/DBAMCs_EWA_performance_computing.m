function[]=DBAMCs_EWA_performance_computing()

global DBAMCs Parameters

t = Parameters.current_day;

AMCsIds = fieldnames(DBAMCs);

for a=1:numel(AMCsIds);
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    if strcmp(AMC.learning,'EWA')
        if Parameters.prompt_print==1
            fprintf('\r %s EWA learning: computation of performances',AMC.id)
        end
        AMC = agent_EWA_performance_computing(AMC);
        DBAMCs.(id)=AMC;
    elseif strcmp(AMC.learning,'None')
        if Parameters.prompt_print==1
            fprintf('\rr No learning for %s',AMC.id)
        end
    else
        fprint('\r %s :',AMC.id)
        error('t no kind of learning has been specified for this AMC')
    end
    clear id AMC
end
