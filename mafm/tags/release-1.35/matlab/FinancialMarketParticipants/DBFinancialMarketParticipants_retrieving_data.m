function[]=DBFinancialMarketParticipants_retrieving_data

global Parameters DBHouseholds DBAMCs Government DBFinancialMarketParticipants PensionFundManager

t = Parameters.current_day;

FinancialMarketParticipantsIds = fieldnames(DBFinancialMarketParticipants);

for a=1:numel(FinancialMarketParticipantsIds)
    id = FinancialMarketParticipantsIds{a,1};
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    
    if strcmp(FinancialMarketParticipant.class,'household')
        DBHouseholds.(id) = FinancialMarketParticipant;
    elseif strcmp(FinancialMarketParticipant.class,'government')
        Government = FinancialMarketParticipant;
    elseif strcmp(FinancialMarketParticipant.class,'PensionFundManager')
        PensionFundManager = FinancialMarketParticipant;
    elseif strcmp(FinancialMarketParticipant.class,'AMC')
        DBAMCs.(id) = FinancialMarketParticipant;
    else
        error('FinancialMarketParticipant is of an unknown type')
    end
    clear id FinancialMarketParticipant
end