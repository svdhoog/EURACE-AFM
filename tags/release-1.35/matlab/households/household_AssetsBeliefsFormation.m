function[household]=household_AssetsBeliefsFormation(household)

% Description:
% computes household beliefs related to assets' expected price returns, 
% total returns, cash flow yields and variance-covariance matrix of returns, 
% given the household memory and investment horizon
%
% Input arguments:
% household: struct related to an household
%
% Output arguments:
% household: struct related to an household
%
% Note1: the expected variance-covariance matrix of returns is computed on historical data
%        expected price returns are computed according to the chartist or random behavior
%        expected total returns are computed according to price returns and
%        expected asset cash flows by means of the IRR concept
%        
% Note2: the household updates its beliefs only if it is willing to trade in the financial market.
%       The willingness to trade in the financial market is set by an exogeneous probability
%       given by 1/household.InvestmentHorizon (see logical_condition_1).
%       Besides, the household is forced to trade if its bank account is negative (see logical_condition_2).
%
% Note3: all returns have been annualized
% 
% Version 1.2 of July 2007
%
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)


global Parameters DBFinancialAssets Days 

t = Parameters.current_day;

FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(FinancialAssetsIds);

mem = household.PortfolioAllocationRule.memory;
horiz = household.PortfolioAllocationRule.InvestmentHorizon;

% Note: the
% logical condition (if true, the household update its beliefs)
logical_condition = (rand<=(1/horiz));

if ~logical_condition
    % the household does not update its beliefs
    household.beliefs_update(t) = 0;
    return
else
    % the household updates its beliefs
    household.beliefs_update(t) = 1;

    % dimensioning of variables
    HistoricalDailyPrices = zeros(mem,NrAssets);
    HistoricalDailyReturns = zeros(mem-1,NrAssets);
    HistoricalDailyReturns_avg = zeros(1,NrAssets);

    for n=1:NrAssets
        id = FinancialAssetsIds{n,1};
        asset = DBFinancialAssets.(id);
        household.assets_ids{n,1} = id;
        if t>mem
            % if t>mem, historical data are sufficient with respect to household
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
        household.beliefs.AssetsExpectedCovariances = Parameters.NrDaysInYear*cov(HistoricalDailyReturns);
    else
        household.beliefs.AssetsExpectedCovariances = zeros(NrAssets,NrAssets);
        household.beliefs.AssetsExpectedCovariances = (Parameters.AssetsBeliefsDefaultStd^2)*eye(NrAssets);
    end

    household.beliefs.AssetsExpectedPriceReturns = zeros(1,NrAssets);
    household.beliefs.AssetsExpectedTotalReturns = zeros(1,NrAssets);
    household.beliefs.AssetsExpectedCashFlowYield = zeros(1,NrAssets);

    for n=1:NrAssets
        id = household.assets_ids{n,1};
        asset = DBFinancialAssets.(id);
        volatility_tmp = sqrt(household.beliefs.AssetsExpectedCovariances(n,n));
        volatility = max(Parameters.AssetsBeliefsDefaultStd,volatility_tmp);
        %volatility = volatility_tmp;
        household.beliefs.AssetsVolatilities(n) = volatility;
        if volatility>1
            fprintf('\r volatility is greater than 1')
        end
        average_return = HistoricalDailyReturns_avg(n);
        if strcmp(asset.class,'stock')
            [PriceReturn, TotalReturn, DividendYield] = ...
                agent_StockExpectedReturns(household,asset,volatility,average_return);
            household.beliefs.AssetsExpectedPriceReturns(n) = PriceReturn;
            household.beliefs.AssetsExpectedTotalReturns(n) = TotalReturn;
            household.beliefs.AssetsExpectedCashFlowYield(n) = DividendYield;
        elseif strcmp(asset.class,'bond')
            [PriceReturn, TotalReturn, CouponYield] = ...
                agent_BondExpectedReturns(household,asset,volatility,average_return);
            household.beliefs.AssetsExpectedPriceReturns(n) = PriceReturn;
            household.beliefs.AssetsExpectedTotalReturns(n) = TotalReturn;
            household.beliefs.AssetsExpectedCashFlowYield(n) = CouponYield;
        else
            error('The asset type is unknown')
        end
        clear id asset volatility PriceReturn DividendsReturn CouponsYield TotalReturn
    end

    
    if strcmp(household.PortfolioAllocationRule.class,'PT')
        bins_number = min(household.PortfolioAllocationRule.bins_number,mem);
        for n=1:NrAssets
            id = household.assets_ids{n,1};
            asset = DBFinancialAssets.(id);
            returns_tmp = HistoricalDailyReturns(:,n) + household.beliefs.AssetsExpectedCashFlowYield(n);
            [Py_returns, Px_returns] = hist(returns_tmp,bins_number);
            household.preferences.asset_prospect.(id).prob = Py_returns/sum(Py_returns);
            household.preferences.asset_prospect.(id).value = Px_returns;
            household.preferences.mean_hist_returns = HistoricalDailyReturns_avg;
            clear id asset returns_tmp Py_returns Px_returns
        end
    end

end 