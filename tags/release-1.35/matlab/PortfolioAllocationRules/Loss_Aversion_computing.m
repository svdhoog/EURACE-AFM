function [lambda] =  Loss_Aversion_computing(household)

% Tiene conto dell'ultima esperienza in relazione a perdite e guadagni. Solo
% però se c'è stata una perdita. 

global Parameters
t = Parameters.current_day;

Priorgains =  (household.total_liquid_wealth(t-1)- household.total_liquid_wealth(t-2))/...
    household.total_liquid_wealth(t-2);
if Priorgains < 0
    lambda = Parameters.LambdaValueFunction - Parameters.LambdaSensitivityFactor*Priorgains;
else
    lambda = Parameters.LambdaValueFunction;
end
