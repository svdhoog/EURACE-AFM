function[agent]=agent_AssetsWeightsComputing_Rnd(agent)

global Parameters

t = Parameters.current_day;
m = Parameters.current_month;

AssetsId = agent.assets_ids;
NrAssetsId = numel(AssetsId);

wf_tmp = rand(1,NrAssetsId);

ExpectedTotalReturns = agent.beliefs.AssetsExpectedTotalReturns;

agent.preferences.assets_weights{t,1}=(NrAssetsId/(NrAssetsId+1))*wf_tmp/sum(wf_tmp);
s = sum(agent.preferences.assets_weights{t,1});

wf_overall = [agent.preferences.assets_weights{t,1}, 1-s];

ExpectedTotalReturns_overall = [ExpectedTotalReturns, Parameters.CentralBankPolicy.RiskFreeRate]; %% Annual rate
ExpectedTotalReturns_overall = ExpectedTotalReturns_overall/12; %% monthly return
agent.beliefs.portfolio_return_expected(m+1) = wf_overall*ExpectedTotalReturns_overall';