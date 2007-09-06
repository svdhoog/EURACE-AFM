function[aggregate_consumption_budget, aggregate_pension_fund_saving, ...
    aggregate_tax_detraction, aggregate_x_hat, aggregate_ni_hat, NrActiveAgents]=...
    DBHouseholds_consumption_budget_aggregation(tau)

global Parameters DBHouseholds  

HouseholdsIds = fieldnames(DBHouseholds);

aggregate_consumption_budget = 0;
aggregate_pension_fund_saving = 0;
aggregate_tax_detraction = 0;

aggregate_x_hat = 0;
aggregate_ni_hat = 0;
NrActiveAgents = 0;

for a=1:numel(HouseholdsIds)
    id = HouseholdsIds{a,1};
    household = DBHouseholds.(id);
    aggregate_consumption_budget = aggregate_consumption_budget + household.consumption_budget(tau);
    aggregate_pension_fund_saving = aggregate_pension_fund_saving + household.pension_fund_saving(tau);
    aggregate_tax_detraction = aggregate_tax_detraction + household.tax_detraction(tau);
    
    if household.age<Parameters.Households.RetirementAge
        NrActiveAgents = NrActiveAgents+1;
        aggregate_x_hat = aggregate_x_hat + household.x_hat(tau);
        aggregate_ni_hat = aggregate_ni_hat + household.ni_hat(tau);
    end
    clear household
end

aggregate_x_hat = aggregate_x_hat/NrActiveAgents;
aggregate_ni_hat = aggregate_ni_hat/NrActiveAgents;