function[BuyingTraders, SellingTraders]=DBHouseholds_AssetTransactionsRationing(Pcross, Qrationed, AssetId)

% Description:
% [BuyingTraders, SellingTraders]=DBHouseholds_AssetTransactionsRationing(Pcross, Qrationed, AssetId)
% returns a list of buying and selling traders given the clearing price, the rationed quantity and the asset id.
% 
% Input arguments:
% Pcross: double scalar related clearing price  
% Qrationed: int scalar related to the disequilibrium between demand and supply at the clearing price
% AssetId: string that indicates the id of the considered asset
% 
% Output arguments:
% BuyingTraders: cell array of households that manage to buy the stock
% SellingTraders: cell array of households that manage to sell the stock
%
% Note: this function employ two global variables, DBHouseholds and Parameters.
% DBhouseholds is a data structure that includes all households, which are references by their respective id. An example:
% DBhouseholds.household_3 returns the household whose id is household 3.
%
%
% Version 1.0 of June 2007
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it)
% and Andrea Teglio (teglio@dibe.unige.it)

global Parameters DBHouseholds

t = Parameters.currentTime;

HouseholdsID = fieldnames(DBHouseholds);

iB = 0; iS = 0;
for h=1:numel(HouseholdsID)
    id = HouseholdsID{h,1};
    household = DBHouseholds.(id);
    if household.financial_activity(t)==1
        tmp=household.orders.(AssetId);
        p = tmp(1);
        q = tmp(2);
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
    clear tmp id household p q
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


