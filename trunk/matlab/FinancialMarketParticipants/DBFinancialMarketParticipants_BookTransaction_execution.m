function[]=DBFinancialMarketParticipants_BookTransaction_execution(Transaction)

global Parameters DBFinancialMarketParticipants

t = Parameters.current_day;

AssetId = Transaction.AssetId;
id_buyer = Transaction.id_buyer;
id_seller = Transaction.id_seller;
p_trade = Transaction.p_trade;
q_trade = Transaction.q_trade;

buyer = DBFinancialMarketParticipants.(id_buyer);
seller = DBFinancialMarketParticipants.(id_seller);

OldQty_seller = seller.portfolio.(AssetId);
if q_trade > OldQty_seller
    fprintf('q_trade=%f, OldQty_seller=%f, q_trade - OldQty_seller = %f', q_trade, OldQty_seller, q_trade - OldQty_seller);
    error('OlqQty_seller is less than q_trade')
end

% update portfolio
seller.portfolio.(AssetId) = OldQty_seller - q_trade;
seller.portfolio.transactions_accounting(t) = seller.portfolio.transactions_accounting(t) + q_trade*p_trade; 
% update pending orders
seller.pending_orders.(AssetId).q = seller.pending_orders.(AssetId).q + q_trade;
if seller.pending_orders.(AssetId).q>0
    fprintf('seller.pending_orders.(AssetId).q = %f', seller.pending_orders.(AssetId).q);
    error('The quantity of a pending selling order is greater than zero')
end
DBFinancialMarketParticipants.(id_seller) = seller;

OlqQty_buyer = buyer.portfolio.(AssetId);
buyer.portfolio.(AssetId) = OlqQty_buyer + q_trade;
buyer.portfolio.transactions_accounting(t) = buyer.portfolio.transactions_accounting(t) - q_trade*p_trade; 
buyer.pending_orders.(AssetId).q = buyer.pending_orders.(AssetId).q - q_trade;
if buyer.pending_orders.(AssetId).q<0
    fprintf('buyer.pending_orders.(AssetId).q = %f', buyer.pending_orders.(AssetId).q);
    error('The quantity of a pending buying order is less than zero')
end
DBFinancialMarketParticipants.(id_buyer) = buyer;
