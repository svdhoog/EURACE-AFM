function[]=DBFinancialMarketParticipants_building

global Parameters DBHouseholds DBAMCs Government DBFinancialMarketParticipants PensionFundManager

DBFinancialMarketParticipants = [];

t = Parameters.current_day;

HouseholdsIds = fieldnames(DBHouseholds);
for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    if household.trading_activity(t)==1
        DBFinancialMarketParticipants.(id) = household;
    end
    clear household
end

if Government.trading_activity(t)==1
    DBFinancialMarketParticipants.(Government.id) = Government;
end

if PensionFundManager.trading_activity(t)==1
    DBFinancialMarketParticipants.(PensionFundManager.id) = PensionFundManager;
end

AMCsIds = fieldnames(DBAMCs);
for a=1:numel(AMCsIds)
    id = AMCsIds{a,1};
    AMC = DBAMCs.(id);
    if AMC.trading_activity(t)==1
        DBFinancialMarketParticipants.(id) = AMC;
    end
    clear AMC
end