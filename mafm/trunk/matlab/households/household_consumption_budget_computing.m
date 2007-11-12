function[household]=household_consumption_budget_computing(household)

global Parameters wage MonthlyCalendarDates

m = Parameters.current_month;
t = Parameters.current_day;

if household.age<Parameters.Households.RetirementAge

    if rand>=Parameters.Households.ConsumptionLearningProbability   %%%  No learning

        household.x_hat(m) = household.x_hat(m-1);
        household.ni_hat(m) = household.ni_hat(m-1);

        ParametersTmp.X = household.liquid_assets_wealth(t-1)+...
            household.portfolio.bank_account(t-1)+...
            (1-Parameters.Households.UnemploymentProbability)*...
            12*(1-Parameters.GovernmentPolicy.LaborTaxRate)*wage(m);
        ParametersTmp.x_hat = household.x_hat(m);
        ParametersTmp.ni_hat = household.ni_hat(m);
        ParametersTmp.mu = Parameters.Households.UnemploymentProbability;
        ParametersTmp.wage_net = 12*(1-Parameters.Households.UnemploymentProbability)*...
            (1-Parameters.GovernmentPolicy.LaborTaxRate)*wage(m);
        ParametersTmp.MPC = Parameters.Households.MPC;
        ParametersTmp.G = exp(12*Parameters.MonthlyWageGrowthRate);
        ParametersTmp.R = 1 + yearly_average_cash_flow_yield_estimate;
        ParametersTmp.R = max(ParametersTmp.R,1.04);
        
        [C, I, TaxDetraction] = consumption_working_ages_computing(ParametersTmp);

    else  %%% Learning on consumption

        [C, I, x_hat, ni_hat]=household_intertemporal_expected_utility_maximization(household);
        TaxDetraction = Parameters.GovernmentPolicy.LaborTaxRate*I;
        household.x_hat(m) = x_hat;
        household.ni_hat(m) = ni_hat;

    end

    household.consumption_budget(m) = C/12;
    household.pension_fund_saving(m) = I/12;
    household.tax_detraction(m) = TaxDetraction/12;

    household.portfolio.bank_account(t-1) = household.portfolio.bank_account(t-1) + ...
        household.net_income(m) - household.consumption_budget(m) - household.pension_fund_saving(m) + ...
        household.tax_detraction(m);

else
    
    total_wealth = household.liquid_assets_wealth(t-1)+household.portfolio.bank_account(t-1);
    household.consumption_budget(m) = household.net_income(m)+...
        (1/12)*total_wealth/(Parameters.Households.age_max-household.age+1);
    household.pension_fund_saving(m) = 0;
    household.tax_detraction(m) = 0;

    household.portfolio.bank_account(t-1) = household.portfolio.bank_account(t-1) + ...
        household.net_income(m) - household.consumption_budget(m);

    %error('\r Consumption learning not yet implemented')
end

