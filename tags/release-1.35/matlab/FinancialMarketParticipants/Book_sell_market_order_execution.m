function[Transactions, q_residual] = Book_sell_market_order_execution(LimitOrder)

global Book 

AssetId = LimitOrder.AssetId;

Bids_values = Book.(AssetId).Bids_values;
Bids_ids = Book.(AssetId).Bids_ids;

BestBidsPrices = Bids_values(:,1);
BestBidsQties = Bids_values(:,2);

NrBestBidsPrices = numel(BestBidsPrices);

% BestBidsPrices are ordered in descending order with respect to the price
if LimitOrder.p>BestBidsPrices(1)
    error('Invalid sell market order')
end

q_tmp = abs(LimitOrder.q);
p_tmp = BestBidsPrices(1);
%BestBidsPrices(1) is the highest bid price

j = 0;

Bids_values_new = Bids_values;

while(LimitOrder.p<=p_tmp)    
    
    j = j + 1;  % j is the index of transactions
    Transactions(j).p_trade = p_tmp;
    Transactions(j).q_trade = min(Bids_values_new(1,2),q_tmp);
    Transactions(j).DayTime = LimitOrder.emissionDayTime;
    Transactions(j).IntradayTime = LimitOrder.emissionIntradayTime;

    Transactions(j).AssetId = AssetId;
    order_id = Bids_values_new(1,7);
    id_buyer = Bids_ids.(['t', num2str(order_id)]);
    Transactions(j).id_buyer = id_buyer;
    Transactions(j).id_seller = LimitOrder.agent_id;
       
    DBFinancialMarketParticipants_BookTransaction_execution(Transactions(j))
     
    % quantities update
    q_tmp = q_tmp - Transactions(j).q_trade;  % update of limit order quantities   
    Bids_values_new(1,2) = Bids_values_new(1,2) - Transactions(j).q_trade; % update of book quantities

    if Bids_values_new(1,2)==0    % the order book has been completely exhausted
        order_id = ['t', num2str(Bids_values_new(1,7))];
        Bids_ids = rmfield(Bids_ids,order_id);  % cancel the id of the exhausted order from the book
        if size(Bids_values_new,1)==1  % there was only one order in the book
            Bids_values_new = [];   % cancel the bids side of the book
            break
        else
            Bids_values_new = Bids_values_new(2:end,:);  % cancel the exhausted order from the book
            p_tmp = Bids_values_new(1,1);  % set the new best bid
        end
    elseif Bids_values_new(1,2)<0
        error('A quantity in the book is less than zero')
    end
    
    if q_tmp==0  % check if the market order has been exhausted
        break
    end
    
end

q_residual = q_tmp;

Book.(AssetId).Bids_values = Bids_values_new;
Book.(AssetId).Bids_ids = Bids_ids;