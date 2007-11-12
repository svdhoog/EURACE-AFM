function[household]=household_OrdersIssuingProspectRanking(household)

global Parameters DBFinancialAssets

t = Parameters.current_day;

horiz = household.InvestmentHorizon;

if household.financial_activity(t)==0
    return
elseif household.financial_activity(t) == 1
    FinancialAssetsIds = fieldnames(DBFinancialAssets);
    NrAssets = numel(FinancialAssetsIds);
    mem = household.memory;
    horiz = household.InvestmentHorizon;
    
    if t<mem % shortcut sulla memoria
        mem = t - 1;
    end
    HistoricalPrices = zeros(mem,NrAssets);
    HistoricalReturns = zeros(mem-1,NrAssets);
    HistoricalAnnualReturns = zeros(mem-1,NrAssets);

    for n=1:NrAssets
        id = household.assets_ids{n,1};
        asset = DBFinancialAssets.(id);
        HistoricalPrices = asset.prices(t-mem:t-1);
        HistoricalReturns = diff(HistoricalPrices)./HistoricalPrices(1:end-1);
        WeightedHistoricalReturns = Prospect_Weighting_Returns(household,HistoricalReturns);
        %calcola l'istogramma sui ritorni
        binsnumber = min(household.preferences.binsnumber,mem);
        HistoricalReturns = HistoricalReturns +  household.beliefs.AssetsExpectedYields(n);
        SortHistoricalReturns = sort (WeightedHistoricalReturns);
        MinHistoricalReturns = min(SortHistoricalReturns);
        MaxHistoricalReturns = max(SortHistoricalReturns);
        Increment = (MaxHistoricalReturns - MinHistoricalReturns)/binsnumber;
        HistHistoricalReturnsX = zeros (binsnumber,1);
        ValueFunction = zeros (binsnumber,1);
        lambda = Loss_Aversion_computing(household);
        for k = 1:binsnumber
            HistHistoricalReturnsX(k) = (MinHistoricalReturns + Increment*(k) + MinHistoricalReturns + Increment*(k-1))/2;
            % calcola value function
            if HistHistoricalReturnsX(k) < 0
                ValueFunction(k) = lambda*HistHistoricalReturnsX(k);
            else
                ValueFunction(k) = HistHistoricalReturnsX(k);
            end

            HistHistoricalReturnsY = hist (WeightedHistoricalReturns,binsnumber);
            HistHistoricalReturnsY = HistHistoricalReturnsY/sum(HistHistoricalReturnsY);
            %calcola l'utilità
            AssetUtility = HistHistoricalReturnsY * ValueFunction;
            household.preferences.prospectutility.(id)(t) = AssetUtility;
            household.preferences.prospectutility.SA(t) = Parameters.RiskFreeRate; % imposta l'utilità del saving account

        end
        clear id asset
    end

end

   

