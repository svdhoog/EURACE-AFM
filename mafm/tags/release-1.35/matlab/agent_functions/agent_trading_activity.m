function[agent]=agent_trading_activity(agent)

global Parameters DBFinancialAssets

% Description:
% set the the agent trading activity of the current time step equal to 1 in
% the case of beliefs update or in the case of existing pending orders
%
% Version 1.0 August 30th, 2007 
% Marco Raberto

t = Parameters.current_day;

FinancialAssetsIds = fieldnames(DBFinancialAssets);

agent.trading_activity(t) = 0;

if agent.beliefs_update(t)==1
    agent.trading_activity(t) = 1;
    return
else
    for a=1:numel(FinancialAssetsIds)
        AssetId = FinancialAssetsIds{a,1};
        if agent.pending_orders.(AssetId).q~=0
            agent.trading_activity(t) = 1;
            break
        end
        clear AssetId
    end
end