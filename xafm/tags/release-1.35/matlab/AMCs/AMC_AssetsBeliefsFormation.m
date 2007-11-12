function[AMC]=AMC_AssetsBeliefsFormation(AMC)

global Parameters DBFinancialAssets Days 

t = Parameters.current_day;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(FinancialAssetsIds);

mem = AMC.PortfolioAllocationRule.memory;
horiz = AMC.PortfolioAllocationRule.InvestmentHorizon;

% Note: the logical condition (if true, the AMC updates its beliefs)
logical_condition = (rand<=horiz);

if ~logical_condition
    % the AMC does not update its beliefs
    AMC.beliefs_update(t) = 0;
    return
else
    % the AMC updates its beliefs
    AMC.beliefs_update(t) = 1;

    % dimensioning of variables
    HistoricalDailyPrices = zeros(mem,NrAssets);
    HistoricalDailyReturns = zeros(mem-1,NrAssets);
    HistoricalDailyReturns_avg = zeros(1,NrAssets);

    for n=1:NrAssets
        id = FinancialAssetsIds{n,1};
        asset = DBFinancialAssets.(id);
        AMC.assets_ids{n,1} = id;
        if t>mem
            % if t>mem, historical data are sufficient with respect to AMC
            % memory to compute returns
            HistoricalDailyPrices(:,n) = asset.prices(t-mem:t-1);
        end
        clear id asset
    end

    % Determination of historical returns
    if t>mem
        HistoricalDailyReturns = diff(HistoricalDailyPrices)./HistoricalDailyPrices(1:end-1,:);
        HistoricalDailyReturns_avg = mean(HistoricalDailyReturns,1);
    else
        % if historical data are not sufficient, so HistoricalAverageAnnualReturns 
        % and HistoricalAnnualizedDailyReturns_avg are set to default values, i.e. to zero
    end

    if t>mem
        AMC.beliefs.AssetsExpectedCovariances = Parameters.NrDaysInYear*cov(HistoricalDailyReturns);
    else
        AMC.beliefs.AssetsExpectedCovariances = zeros(NrAssets,NrAssets);
        AMC.beliefs.AssetsExpectedCovariances = (Parameters.AssetsBeliefsDefaultStd^2)*eye(NrAssets);
    end

    AMC.beliefs.AssetsExpectedPriceReturns = zeros(1,NrAssets);
    AMC.beliefs.AssetsExpectedTotalReturns = zeros(1,NrAssets);
    AMC.beliefs.AssetsExpectedCashFlowYield = zeros(1,NrAssets);

    for n=1:NrAssets
        id = AMC.assets_ids{n,1};
        asset = DBFinancialAssets.(id);
        volatility_tmp = sqrt(AMC.beliefs.AssetsExpectedCovariances(n,n));
        volatility = max(Parameters.AssetsBeliefsDefaultStd,volatility_tmp);
        %volatility = volatility_tmp;
        AMC.beliefs.AssetsVolatilities(n) = volatility;
        if volatility>1
            fprintf('\r volatility is greater than 1')
        end
        average_return = HistoricalDailyReturns_avg(n);
        if strcmp(asset.class,'stock')
            [PriceReturn, TotalReturn, DividendYield] = ...
                agent_StockExpectedReturns(AMC,asset,volatility,average_return);
            AMC.beliefs.AssetsExpectedPriceReturns(n) = PriceReturn;
            AMC.beliefs.AssetsExpectedTotalReturns(n) = TotalReturn;
            AMC.beliefs.AssetsExpectedCashFlowYield(n) = DividendYield;
        elseif strcmp(asset.class,'bond')
            [PriceReturn, TotalReturn, CouponYield] = ...
                agent_BondExpectedReturns(AMC,asset,volatility,average_return);
            AMC.beliefs.AssetsExpectedPriceReturns(n) = PriceReturn;
            AMC.beliefs.AssetsExpectedTotalReturns(n) = TotalReturn;
            AMC.beliefs.AssetsExpectedCashFlowYield(n) = CouponYield;
        else
            error('The asset type is unknown')
        end
        clear id asset volatility PriceReturn DividendsReturn CouponsYield TotalReturn
    end

end 