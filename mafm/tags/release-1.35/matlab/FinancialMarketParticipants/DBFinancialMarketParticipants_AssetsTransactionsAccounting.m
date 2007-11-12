function[]=DBFinancialMarketParticipants_AssetsTransactionsAccounting(Pcross, Qcross, ...
    BuyingTraders, SellingTraders, AssetId)

global Parameters DBHouseholds DBFinancialMarketParticipants Government

t = Parameters.current_day;

id_buyers = cellstr(char(BuyingTraders{:,1}));
id_sellers = cellstr(char(SellingTraders{:,1}));

NrBuyers = length(id_buyers);
NrSellers = length(id_sellers);

%%%% consistency checks %%%%
if NrBuyers==0
    error('There are no buyers!')
elseif NrSellers==0
    error('There are no sellers')
end
if ~isempty(intersect(id_buyers,id_sellers))
    error('The same id for a buyer and a seller')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QBtot = 0;  QStot = 0;
%%% Accounting about buyers  %%%
for n=1:NrBuyers
    id = BuyingTraders{n,1};
    deltaQ = BuyingTraders{n,3};
    QBtot = QBtot + deltaQ;
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    OldQty = FinancialMarketParticipant.portfolio.(AssetId);
    FinancialMarketParticipant.portfolio.(AssetId) = OldQty + deltaQ;
    FinancialMarketParticipant.portfolio.transactions_accounting(t) = ...
        FinancialMarketParticipant.portfolio.transactions_accounting(t) - Pcross*deltaQ;
    FinancialMarketParticipant.pending_orders.(AssetId).q = FinancialMarketParticipant.pending_orders.(AssetId).q - deltaQ;
    if FinancialMarketParticipant.pending_orders.(AssetId).q<0
        error('The quantity of a pending buying order is less than zero')
    end
    DBFinancialMarketParticipants.(id) = FinancialMarketParticipant;
    
    
    clear id FinancialMarketParticipant deltaQ v OldQty
end

%%% Accounting about sellers  %%%
for n=1:NrSellers
    id = SellingTraders{n,1};
    deltaQ = SellingTraders{n,3};
    QStot = QStot + deltaQ;
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    OldQty = FinancialMarketParticipant.portfolio.(AssetId);
    FinancialMarketParticipant.portfolio.(AssetId) = OldQty - deltaQ;
    FinancialMarketParticipant.portfolio.transactions_accounting(t) = ...
        FinancialMarketParticipant.portfolio.transactions_accounting(t) + Pcross*deltaQ;
    FinancialMarketParticipant.pending_orders.(AssetId).q = FinancialMarketParticipant.pending_orders.(AssetId).q + deltaQ;
    if FinancialMarketParticipant.pending_orders.(AssetId).q>0
        error('The quantity of a pending selling order is greater than zero')
    end
    DBFinancialMarketParticipants.(id) = FinancialMarketParticipant;

    clear id FinancialMarketParticipant deltaQ v OldQty

end

%%%  Final check %%%
if (abs(QBtot-QStot)>0.99)|(abs(QBtot-Qcross)>0.99)|(abs(QStot-Qcross)>0.99)
    fprintf('\r\n QBtot: %d \t QStot: %d \t Qcross: %d',QBtot,QStot,Qcross)
    error('Error in the transactions quantities')
end
