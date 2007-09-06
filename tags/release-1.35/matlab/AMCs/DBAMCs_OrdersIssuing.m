function[]=DBAMCs_OrdersIssuing()

global Parameters DBAMCs 

t = Parameters.current_day;

AMCsId = fieldnames(DBAMCs);

for a=1:length(AMCsId)
    id = AMCsId{a,1};
    AMC = DBAMCs.(id);
    AMC = agent_OrdersIssuing(AMC);
    DBAMCs.(id) = AMC;
    clear id AMC
end