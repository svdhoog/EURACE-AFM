function[]=Transactions_print(Transactions)

NrTransactions = numel(Transactions);

if NrTransactions>0
    fprintf('\r Transactions:')
    fprintf('\r AssetId \t buyer \t seller \t price \t qty')
    for i=1:NrTransactions
        AssetId = Transactions(i).AssetId;
        id_buyer = Transactions(i).id_buyer;
        id_seller = Transactions(i).id_seller;
        p_trade = Transactions(i).p_trade;
        q_trade = Transactions(i).q_trade;
        fprintf('\r %s \t %s \t %s \t %f \t %d',AssetId,id_buyer,id_seller,p_trade,q_trade)
    end
else
    fprintf('\r\r No transactions')
end
