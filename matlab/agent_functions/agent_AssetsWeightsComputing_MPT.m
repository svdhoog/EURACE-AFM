function[agent]=agent_AssetsWeightsComputing_MPT(agent)

global Parameters DBFinancialAssets

t = Parameters.current_day;
m = Parameters.current_month;

AssetsId = agent.assets_ids;
NrAssetsId = numel(AssetsId);

ExpectedTotalReturns = agent.beliefs.AssetsExpectedTotalReturns;
ExpectedCovariances = agent.beliefs.AssetsExpectedCovariances;

AssetBounds = [zeros(1,NrAssetsId); ones(1,NrAssetsId)];

[EFPortfolios_risk, EFPortfolios_return, EFPortfolios_wts]=...
    frontconNew(ExpectedTotalReturns,ExpectedCovariances,...
    Parameters.MPT.NrEFPortfolios,[],AssetBounds);

EFPortfolios_risk_nr = numel(EFPortfolios_risk);
EFPortfolios_return_nr = numel(EFPortfolios_return);
    
if EFPortfolios_return_nr~=Parameters.MPT.NrEFPortfolios
    %        fprintf('\r %s \r',household.id)
    warning('Nr EFPortfolios_return: %d \r',EFPortfolios_return_nr)
    EFPortfolios_return = repmat(EFPortfolios_return,[Parameters.MPT.NrEFPortfolios, 1]);
    EFPortfolios_wts = repmat(EFPortfolios_wts,[Parameters.MPT.NrEFPortfolios, 1]);
    if EFPortfolios_return_nr>1
        fprintf('Fatto strano')
    end
end


if EFPortfolios_risk_nr~=Parameters.MPT.NrEFPortfolios

    warning('Nr EFPortfolios_risk: %d \r',EFPortfolios_risk_nr)
    if EFPortfolios_risk_nr>1
        fprintf('Fatto strano')
    end
    EFPortfolios_risk = repmat(EFPortfolios_risk,[Parameters.MPT.NrEFPortfolios, 1]);
end
           
[RiskyWts, RiskyFraction]=MarkowitzAllocation(Parameters,EFPortfolios_return,EFPortfolios_risk,...
    EFPortfolios_wts,agent.PortfolioAllocationRule.risk_aversion);
    
wf = RiskyFraction*RiskyWts;
if numel(wf)~=NrAssetsId
    error('Dimension of weights is not correct')
end
agent.preferences.assets_weights{t,1} = wf;

LiquidityFraction = (1-RiskyFraction);
wf_overall = [wf, LiquidityFraction];
if abs(sum(wf_overall)-1)>1e-3
    error('The sum of weights is different from 1')
end
    
ExpectedTotalReturns_overall = [ExpectedTotalReturns, Parameters.CentralBankPolicy.RiskFreeRate]; %% Annual rate
ExpectedTotalReturns_overall = ExpectedTotalReturns_overall/12; %% monthly return
agent.beliefs.portfolio_return_expected(m+1) = wf_overall*ExpectedTotalReturns_overall';