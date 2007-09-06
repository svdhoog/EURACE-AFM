function[]=LaborMarketClearing

global Parameters Days DBHouseholds

m = Parameters.current_month;
HouseholdsIds = fieldnames(DBHouseholds);
for h=1:numel(HouseholdsIds)
    id = HouseholdsIds{h,1};
    household = DBHouseholds.(id);
    household.labor_activity(m) = 0;
    if household.age<Parameters.Households.RetirementAge
        if rand>Parameters.Households.UnemploymentProbability;
            household.labor_activity(m) = 1;
        end
    end
    DBHouseholds.(id) = household;
end
