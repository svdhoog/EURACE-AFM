function[]=DBAMCs_trading_activity

global Parameters DBAMCs 

t = Parameters.current_day;

NrAMCsActiveTraders = 0;

AMCsIds = fieldnames(DBAMCs);

for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    AMC = agent_trading_activity(AMC);
    NrAMCsActiveTraders = NrAMCsActiveTraders + AMC.trading_activity(t);
    DBAMCs.(id) = AMC;
    clear id AMC
end

if Parameters.prompt_print==1
    fprintf('\r\r Nr AMCs active traders: %d',NrAMCsActiveTraders)
end