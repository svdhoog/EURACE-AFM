function[household]=household_ProspectRanking(household)

global Parameters DBFinancialAssets

t = Parameters.currentTime;

horiz = household.InvestmentHorizon;

if household.financial_activity(t)==0
    %household.preferences.ranking = [NaN, NaN]; % qui però non basta un vettore qualsiasi ma che dipende dalle id
    return
elseif household.financial_activity(t) == 1
    %fprintf('\r household: %s',household.id)
    
FinancialAssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(FinancialAssetsIds);
    mem = household.memory;
    horiz = household.InvestmentHorizon;
    % imposta l'utilità del saving account (notare che il tasso d'interesse è fisso)
    household.preferences.prospectutility.SA = Parameters.RiskFreeRate;
    % qui devo creare il ranking
    if t>mem
        HistoricalPrices = zeros(mem,NrAssets);
        HistoricalReturns = zeros(mem-1,NrAssets);
        HistoricalAnnualReturns = zeros(mem-1,NrAssets);
    end
    
    for n=1:NrAssets
        id = household.assets_ids{n,1};
        asset = DBFinancialAssets.(id);
        if t>mem
            HistoricalPrices(:,n) = asset.prices(t-mem:t-1);
            %% Conversion from the monthly return HistoricalReturns to the annual rate HistoricalAnnualReturns
            %% given by compounding the monthly return
            HistoricalReturns = diff(HistoricalPrices)./HistoricalPrices(1:end-1,:);
            HistoricalAverageReturns = mean(HistoricalAnnualReturns);


            %calcola l'istogramma sui ritorni
            binsnumber = min(household.preferences.binsnumber,mem);         
            HistoricalReturns = HistoricalReturns(:,1) + household.beliefs.AssetsExpectedCashFlowYields(n);% sommo i dividendi ai ritorni
            SortHistoricalReturns = sort (HistoricalReturns);
            MinHistoricalReturns = min (SortHistoricalReturns);
            MaxHistoricalReturns = max(SortHistoricalReturns);
            Increment = (MaxHistoricalReturns - MinHistoricalReturns)/binsnumber;
            HistHistoricalReturnsX = zeros (binsnumber,1);
            ValueFunction = zeros (binsnumber,1);
            for k = 1:binsnumber
                HistHistoricalReturnsX(k) = (MinHistoricalReturns + Increment*(k) + MinHistoricalReturns + Increment*(k-1))/2;
                % calcola value function
                if HistHistoricalReturnsX(k) < 0
                    ValueFunction(k) = Parameters.LambdaValueFunction*HistHistoricalReturnsX(k);
                else
                    ValueFunction(k) = HistHistoricalReturnsX(k);
                end

            end

            HistHistoricalReturnsY = hist (HistoricalReturns,binsnumber);
            HistHistoricalReturnsY = HistHistoricalReturnsY/sum(HistHistoricalReturnsY);
            % sono ancora da sommare i ritorni dati dai dividendi

            %calcola l'utilità
            AssetUtility = HistHistoricalReturnsY * ValueFunction;
            household.preferences.prospectutility.(id) = AssetUtility;
        end
        clear id asset
    end

end

   

