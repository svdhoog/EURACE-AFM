function[]=LaborWageDynamics

global Parameters wage Noises

m = Parameters.current_month;

CurrentWage_Log = log(wage(m-1)) + Parameters.MonthlyWageGrowthRate +...
    Parameters.WageSigma*Noises.wage_dynamics(m);

wage(m) = exp(CurrentWage_Log);