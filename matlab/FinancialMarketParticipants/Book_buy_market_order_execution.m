function[Transactions, q_residual] = Book_buy_market_order_execution(LimitOrder)

global Book Parameters

AssetId = LimitOrder.AssetId;

Asks_values = Book.(AssetId).Asks_values;
Asks_ids = Book.(AssetId).Asks_ids;

BestAsksPrices = Asks_values(:,1);
BestAsksQties = Asks_values(:,2);

NrBestAsksPrices = numel(BestAsksPrices);

% BestAsksPrices are ordered in descending order with respect to the price
if LimitOrder.p<BestAsksPrices(end)
    error('Invalid buy market order')
end

q_tmp = LimitOrder.q;
p_tmp = BestAsksPrices(end);
%BestAsksPrices(end) is the lowest ask price

j = 0;

Asks_values_new = Asks_values;

while(LimitOrder.p>=p_tmp)    
    
    j = j + 1;  % j is the index of transactions
    Transactions(j).p_trade = p_tmp;
    Transactions(j).q_trade = min(Asks_values_new(end,2),q_tmp);
    Transactions(j).DayTime = LimitOrder.emissionDayTime;
    Transactions(j).IntradayTime = LimitOrder.emissionIntradayTime;

    Transactions(j).AssetId = AssetId;
    Transactions(j).id_buyer = LimitOrder.agent_id;
    order_id = Asks_values_new(end,7);
    id_seller = Asks_ids.(['t', num2str(order_id)]);
    Transactions(j).id_seller = id_seller;
       
    DBFinancialMarketParticipants_BookTransaction_execution(Transactions(j))
    
    % quantities update
    q_tmp = q_tmp - Transactions(j).q_trade;   
    Asks_values_new(end,2) = Asks_values_new(end,2) - Transactions(j).q_trade;

    if Asks_values_new(end,2)==0  % the order book has been completely exhausted
        order_id = ['t', num2str(Asks_values_new(end,7))];
        Asks_ids = rmfield(Asks_ids,order_id);
        if size(Asks_values_new,1)==1
            Asks_values_new = [];
            break
        else
            Asks_values_new = Asks_values_new(1:end-1,:);
            p_tmp = Asks_values_new(end,1);
        end
    elseif Asks_values_new(end,2)<0
        error('A quantity in the book is less than zero')
    end
    
    if q_tmp==0   % check if the market order has been exhausted
        break
    end
    
end

q_residual = q_tmp;

Book.(AssetId).Asks_values = Asks_values_new;
Book.(AssetId).Asks_ids = Asks_ids;