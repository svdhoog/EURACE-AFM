function[]=DBHouseholds_OrdersIssuing()

global Parameters DBHouseholds 

t = Parameters.current_day;

AMCsId = fieldnames(DBHouseholds);

NrActiveHouseholds = 0;

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    household = household_OrdersIssuing(household);
    DBHouseholds.(id) = household;
    NrActiveHouseholds = NrActiveHouseholds + household.financial_activity(t);
    clear id household
end

fprintf('\r\t OrdersIssuing. NrActiveHouseholds: %d',NrActiveHouseholds)
