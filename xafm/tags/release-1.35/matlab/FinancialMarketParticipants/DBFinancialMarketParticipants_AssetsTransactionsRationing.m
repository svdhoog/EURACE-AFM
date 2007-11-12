function[BuyingTraders, SellingTraders]=...
    DBFinancialMarketParticipants_AssetTransactionsRationing(Pcross, Qrationed, AssetId)

global Parameters DBFinancialMarketParticipants

t = Parameters.current_day;

DBFinancialMarketParticipantsIDs = fieldnames(DBFinancialMarketParticipants);

iB = 0; iS = 0;
for h=1:numel(DBFinancialMarketParticipantsIDs)
    id = DBFinancialMarketParticipantsIDs{h,1};
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    if FinancialMarketParticipant.trading_activity(t)==1
        p = FinancialMarketParticipant.pending_orders.(AssetId).pLimit;
        q = FinancialMarketParticipant.pending_orders.(AssetId).q;
        if q>0  % Buy order
            if p>=Pcross
                iB=iB+1;
                BuyingTraders{iB,1}=id;
                BuyingTraders{iB,2}=p;
                BuyingTraders{iB,3}=q;
            end
        elseif q<0  %Sell order
            if p<=Pcross
                iS=iS+1;
                SellingTraders{iS,1}=id;
                SellingTraders{iS,2}=p;
                SellingTraders{iS,3}=abs(q);
            end
        end
    end
    clear tmp id FinancialMarketParticipant p q
end

[NrBuyingTraders, Dummy]=size(BuyingTraders);
[NrSellingTraders, Dummy]=size(SellingTraders);

%%% Random rationing

if Qrationed>0  %% The demand side is rationed
    Idx_rationingOrder = randperm(NrBuyingTraders);
    Qrationed_tmp=Qrationed;
    for i=1:length(Idx_rationingOrder)
        Idx = Idx_rationingOrder(i);
        q = BuyingTraders{Idx,3};
        if q>=Qrationed_tmp
            BuyingTraders{Idx,3}=q-Qrationed_tmp;
            break
        else
            BuyingTraders{Idx,3}=0;
            Qrationed_tmp = Qrationed_tmp-q;
        end
        clear Idx q
    end
elseif Qrationed<0  %% The supply side is rationed
    Idx_rationingOrder = randperm(NrSellingTraders);
    Qrationed_tmp=abs(Qrationed);
    for i=1:length(Idx_rationingOrder)
        Idx = Idx_rationingOrder(i);
        q = SellingTraders{Idx,3};
        if q>=Qrationed_tmp
            SellingTraders{Idx,3}=q-Qrationed_tmp;
            break
        else
            SellingTraders{Idx,3}=0;
            Qrationed_tmp = Qrationed_tmp-q;
        end
        clear Idx q
    end
end


