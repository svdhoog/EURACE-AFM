function[Transactions]=Book_limit_order_insert(LimitOrder)

% Input variable:
% LimitOrder: struct related to a limit order
%
% Output variables:
% Transactions: struct related to a transaction
%
% Description:
% Check if the LimitOrder is a market order and in this case execute it, otherwise add it or 
% its residual to to the book   
%
% Version 1.0, August 28th, 2007
%
% For any question, please contact Marco Raberto  

global Parameters Book

AssetId = LimitOrder.AssetId;

Transactions = [];

Asks_values = Book.(AssetId).Asks_values;
Bids_values = Book.(AssetId).Bids_values;

if LimitOrder.q>0  % buy order
    if ~isempty(Asks_values)
        BestAskPrice = Asks_values(end,1);
        if LimitOrder.p>=BestAskPrice  % the buy limit order becomes a buy market order
            [Transactions, q_residual] = Book_buy_market_order_execution(LimitOrder);
            if q_residual>0
                LimitOrder.q = q_residual;
                Book_AddLimitOrder(LimitOrder)
            elseif q_residual<0
                error('Buy market order execution: q_residual is less than zero')
            end
        else
            Book_AddLimitOrder(LimitOrder)
        end
    else
        Book_AddLimitOrder(LimitOrder)
    end
elseif LimitOrder.q<0 % sell order
    if ~isempty(Bids_values)
        BestBidPrice = Bids_values(1,1);
        if LimitOrder.p<=BestBidPrice  % the order becomes a market order
            [Transactions, q_residual] = Book_sell_market_order_execution(LimitOrder);
            if q_residual>0
                LimitOrder.q = -q_residual;
                Book_AddLimitOrder(LimitOrder)
            elseif q_residual<0
                error('Buy sell order execution: q_residual is less than zero')
            end
        else
            Book_AddLimitOrder(LimitOrder)
        end
    else
        Book_AddLimitOrder(LimitOrder)
    end
end

