function[]=DBHouseholds_OrdersIssuing()

global Parameters DBHouseholds 

t = Parameters.current_day;

HouseholdsId = fieldnames(DBHouseholds);

NrActiveHouseholds = 0;

for a=1:length(HouseholdsId)
    id = HouseholdsId{a,1};
    household = DBHouseholds.(id);
    if strcmp(Parameters.Prefences,'Prospect_theory')
        household = household_OrdersIssuingProspectRanking(household);
        household = household_ProspectMapping(household);
        household = household_OrdersIssuingProspect(household);
    elseif strcmp(Parameters.Prefences,'Markowitz')
        household = household_OrdersIssuing(household);
    else
        error('Preference type is not defined');
    end
    DBHouseholds.(id) = household;
    NrActiveHouseholds = NrActiveHouseholds + household.financial_activity(t);
    clear id household
end

fprintf('\r\t OrdersIssuing. NrActiveHouseholds: %d',NrActiveHouseholds)
