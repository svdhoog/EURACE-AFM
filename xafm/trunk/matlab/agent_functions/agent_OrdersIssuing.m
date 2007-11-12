function[agent]=agent_OrdersIssuing(agent)

% Version 1.1 August 30, 2007
% For any question , please contact Marco Raberto

global Parameters DBFinancialAssets

t = Parameters.current_day;

if agent.beliefs_update(t) == 1
    %fprintf('\r household: %s',household.id)

    AssetsId = agent.assets_ids;
    NrAssetsId = numel(AssetsId);

    p0 = zeros(1,NrAssetsId);
    q0 = zeros(1,NrAssetsId);
    qf = zeros(1,NrAssetsId);

    for n=1:NrAssetsId
        id = AssetsId{n,1};
        q0(n) = agent.portfolio.(id);
        p0(n) = DBFinancialAssets.(id).prices(t-1);
        clear id
    end

    ExpectedPriceReturns = agent.beliefs.AssetsExpectedPriceReturns;
    ExpectedPriceLimitReturns = (1/Parameters.NrDaysInYear)*ExpectedPriceReturns;

    pLimit = p0.*(1+ExpectedPriceLimitReturns);
    %pLimit = p0.*(1 + household.preferences.mean_hist_returns);
    for n=1:NrAssetsId
        if pLimit(n)<realmin
            pLimit(n) = realmin;
        end
    end

    wf = agent.preferences.assets_weights{t,:};
    wealth0 = agent.portfolio_budget(t);
    qf = floor(wf.*wealth0./pLimit);
    qf = max(0,qf);

    for n=1:NrAssetsId
        id = AssetsId{n,1};
        agent.pending_orders.(id).pLimit = pLimit(n);
        agent.pending_orders.(id).q = qf(n)-q0(n);
    end

end