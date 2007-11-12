DBFinancialMarketParticipants_building

AssetsId = fieldnames(DBFinancialAssets);

for s=1:numel(AssetsId)
    AssetId = AssetsId{s,1};
    
    asset = DBFinancialAssets.(AssetId);

    if strcmp(Parameters.ClearingMechanism,'ClearingHouse')

        %%% Clearing House clearing mechanism%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if Parameters.prompt_print == 1
            fprintf('\r\r Clearing House market clearing:')
        end
        [QB, PBLimit, QS, PSLimit]=DBFinancialMarketParticipants_OrdersCollecting(AssetId);
        [Pcross, Qcross, Qrationed] = ClearingHouse(QB, PBLimit, QS, PSLimit);
        if isnan(Pcross)
            Pcross = asset.prices(current_day-1);
            Qcross = 0;
            Qrationed = 0;
        end
        if strcmp(asset.class,'stock')
            CashFlow = asset.dividends(current_month);
            CashFlowYield = asset.dividends(current_month)/Pcross;
        elseif strcmp(asset.class,'bond')
            CashFlow = asset.NominalYield*asset.FaceValue;
            CashFlowYield = asset.NominalYield*asset.FaceValue/Pcross;
        end
        if Parameters.prompt_print == 1

            fprintf('\r Closing Price: %3.2f \t Volume: %d \t Qrat: %d \t last cash flow: %2.2f (%2.2f %%)',...
                Pcross,Qcross,Qrationed,CashFlow,100*CashFlowYield)
        end
        if Qcross>0
            [BuyingTraders, SellingTraders] = ...
                DBFinancialMarketParticipants_AssetsTransactionsRationing(Pcross, Qrationed, AssetId);
            DBFinancialMarketParticipants_AssetsTransactionsAccounting(Pcross, Qcross, BuyingTraders, SellingTraders, AssetId);
        end
        clear QB PBLimit QS PSLimit
        clear BuyingTraders SellingTraders
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif strcmp(Parameters.ClearingMechanism,'LimitOrderBook')
        
        %%% Limit order book clearing mechanism   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if Parameters.prompt_print == 1
            fprintf('\r\r Limit Order Book market clearing:')
        end
        Book_empty(AssetId)
        TransactionsMatrix = DBFinancialMarketParticipants_LimitOrders_Book_inserting(AssetId);
        asset.Book_intraday_transactions{current_day,1} = TransactionsMatrix;
        if isempty(TransactionsMatrix)
            Pcross = asset.prices(current_day-1);
            Qcross = 0;
            Qrationed = 0;
        else
            Pcross = TransactionsMatrix(end,1);
            Qcross = sum(TransactionsMatrix(:,2));
            Qrationed = 0;
        end
        if strcmp(asset.class,'stock')
            CashFlow = asset.dividends(current_month);
            CashFlowYield = asset.dividends(current_month)/Pcross;
        elseif strcmp(asset.class,'bond')
            CashFlow = asset.NominalYield*asset.FaceValue;
            CashFlowYield = asset.NominalYield*asset.FaceValue/Pcross;
        end
        if Parameters.prompt_print == 1
            fprintf('\r clearing Price: %3.2f \t Volume: %d \t Qrat: %d \t last cash flow: %2.2f (%2.2f %%)',...
                Pcross,Qcross,Qrationed,CashFlow,100*CashFlowYield)
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        error('The market clearing mechanism is unknown')
    end

    asset.prices(current_day,1)=Pcross;
    asset.volumes(current_day,1)=Qcross;
    asset.unbalance(current_day,1)=Qrationed;
    
    DBFinancialAssets.(AssetId) = asset;
    
    clear Pcross Qcross Qrationed   

end

DBFinancialMarketParticipants_retrieving_data