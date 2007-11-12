function[tmp]=DBAMCs_bank_account_aggregation(tau)

global Parameters DBAMCs  

AMCsIds = fieldnames(DBAMCs);

tmp = 0;
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    tmp = tmp + AMC.portfolio.bank_account(tau);
    clear AMC
end