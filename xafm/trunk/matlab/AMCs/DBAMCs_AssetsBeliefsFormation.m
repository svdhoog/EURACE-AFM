function[]=DBAMCs_AssetsBeliefsFormation()

global Parameters DBAMCs Days DividendsPaymentDays

t = Parameters.current_day;

AMCsIds = fieldnames(DBAMCs);

for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    AMC = AMC_AssetsBeliefsFormation(AMC);
    DBAMCs.(id) = AMC;
    clear AMC
end


