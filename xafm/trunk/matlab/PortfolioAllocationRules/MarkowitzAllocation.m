function[RiskyWts, RiskyFraction]=MarkowitzAllocation(Parameters,RiskyPortfolioReturns,RiskyPortfolioRisks,...
    RiskyPortfolioWts,RiskAversion)

RisklessRate = Parameters.CentralBankPolicy.RiskFreeRate;

w_min = Parameters.Households.AllocationWeightsMin;
w_max = Parameters.Households.AllocationWeightsMax;
w_d = Parameters.Households.AllocationWeightsDelta;

w = w_min:w_d:w_max;

U = repmat(RiskyPortfolioReturns,[1 numel(w)]).*repmat(w,[numel(RiskyPortfolioReturns), 1])+...
     repmat(RisklessRate,[numel(RiskyPortfolioReturns) numel(w)]).*repmat((1-w),[numel(RiskyPortfolioReturns), 1])-...
    0.5*RiskAversion*((repmat(RiskyPortfolioRisks,[1 numel(w)]).*repmat(w,[numel(RiskyPortfolioRisks), 1])).^2);

[M_row, idxMax_row] = max(U);

[M, IdxM] = max(M_row);

Idx_tmp = idxMax_row(IdxM);
 
% fprintf('\r Idx_tmp: %d',Idx_tmp)
% fprintf('\r Nr rows RiskyPortfolioWts: %d',size(RiskyPortfolioWts,1))

if Idx_tmp>size(RiskyPortfolioWts,1)
    fprintf('\r Errore')
    Idx_tmp = 1; 
end

RiskyWts = RiskyPortfolioWts(Idx_tmp,:);

RiskyFraction = w(IdxM);