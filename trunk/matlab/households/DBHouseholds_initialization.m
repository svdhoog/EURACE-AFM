% Initialize Parameters for Households
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)
 

Parameters.NrHouseholds = NrHouseholds;
Parameters.Households.StocksEndowmentType = 'Equal';
Parameters.Households.reservation_wage_min = -1; 
Parameters.Households.reservation_wage_max = -1;

Parameters.Households.NrPortfoliosEF = 50;

Parameters.Households.ni_hat0 = 0.0;

Parameters.Households.AllocationWeightsMin = 0;
Parameters.Households.AllocationWeightsMax = 1;
Parameters.Households.AllocationWeightsDelta = 0.0001;

Parameters.Households.DividendsKnowledgeMin = 1;
Parameters.Households.DividendsKnowledgeMax = 5;

%%% Households learning parameters %%%

if(~BATCHMODE)
    %Memory: rho=0: experience fixed to 1; rho>0: experience=rho*(experience)+1, an observation counter;
    Parameters.Households.EWA_learning.rho=1;

    %Law of simulated effect: delta=0: for non-used rules: attr = phi*(experience)*(attr), delta>0: attr = phi*(experience)*(attr) + delta*(performance)
    %For used rules delta does not matter: attr = phi*(experience)*(attr) + (performance)
    Parameters.Households.EWA_learning.delta=1;

    %Depreciation rate of attraction: phi=0: attr=(performance), phi>0: attr = phi*(experience)*(attr) + (performance)
    Parameters.Households.EWA_learning.phi=0;

    %Learning speed: beta=0: random choice, beta=Inf: all select best performing rule
    Parameters.Households.EWA_learning.beta=1.0;
end;

DBHouseholds_creation(Parameters); 