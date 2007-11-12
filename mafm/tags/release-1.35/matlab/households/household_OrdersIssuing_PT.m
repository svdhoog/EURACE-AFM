function[household]=household_OrdersIssuing(household)

global Parameters DBFinancialAssets

t = Parameters.current_day;

horiz = household.InvestmentHorizon;

if household.financial_activity(t)==0
    AssetsId = fieldnames(DBFinancialAssets);
    NrAssetsId = numel(AssetsId);;
   
    for n=1:NrAssetsId
        id = AssetsId{n,1};
        household.orders.(id) = [NaN, NaN];
    end
    return
elseif household.financial_activity(t) == 1
    %fprintf('\r household: %s',household.id)
    
    AssetsId = household.assets_ids;
    NrAssetsId = numel(AssetsId);

    p0 = zeros(1,NrAssetsId);
    q0 = zeros(1,NrAssetsId);
    qf = zeros(1,NrAssetsId);

    for n=1:NrAssetsId
        id = AssetsId{n,1};
        q0(n) = household.portfolio.(id);
        p0(n) = DBFinancialAssets.(id).prices(t-1);
        clear id
    end
    
    ExpectedPriceReturns = household.beliefs.AssetsExpectedPriceReturns;
    ExpectedPriceLimitReturns = (1+ExpectedPriceReturns).^(1/12)-1;
    
    pLimit = p0.*(1+ExpectedPriceLimitReturns);
    for n=1:NrAssetsId
        if pLimit(n)<realmin
            pLimit(n) = realmin;
        end
    end
    
    wf = household.weights(t,:);
    wealth0 = household.portfolio_budget(t);
    qf = floor(wf.*wealth0./pLimit);
    qf = max(0,qf);
    
    for n=1:NrAssetsId
        id = AssetsId{n,1};
        household.orders.(id) = [pLimit(n), qf(n)-q0(n)];
    end

else
    error('Household financial activity is unspecified') 
    
end


   

