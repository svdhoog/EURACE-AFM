function[]=Book_AddLimitOrder(LimitOrder)

% LImitOrder: struct related to a limit order 
%
% Description:
% add a limit order to the Book
% Note: the LimitOrder should not be a feasible market order, this shoud be
% already verified outside
%
% Version 1.0, August 28th, 2007
%
% For any question, please contact Marco Raberto  

global Book

AssetId = LimitOrder.AssetId;

% the order_id is given by the number of tenths of seconds from the start of the simulation  
tmp = 10*60*60*24;  % number of tenths of seconds in a day
order_id_num = LimitOrder.emissionDayTime*tmp+LimitOrder.emissionIntradayTime;     
order_id_str = ['t', num2str(order_id_num)];

LimitOrder_tmp = [LimitOrder.p, abs(LimitOrder.q), LimitOrder.emissionDayTime, ...
        LimitOrder.emissionIntradayTime, LimitOrder.cancellationDayTime, ...
        LimitOrder.cancellationIntradayTime, order_id_num];
   

if LimitOrder.q>0  % the order is a buy order (a bid)
 
    % add the order id to existing Bids ids
    if isfield(Book.(AssetId).Bids_ids,order_id_str)
        error('There is already an order in the book with the same id')
    else
        Book.(AssetId).Bids_ids.(order_id_str) = LimitOrder.agent_id;
    end

    % add the new LimitOrder at the end of existing Bids values
    Bids_not_ordered = [Book.(AssetId).Bids_values; LimitOrder_tmp];
  
    % order the Bids 
    [BestBids, Idx_Bids_ordered] = sort(Bids_not_ordered(:,1),'descend');
    Bids_ordered = zeros(numel(BestBids),7);
    Bids_ordered = Bids_not_ordered(Idx_Bids_ordered,:);
    Book.(AssetId).Bids_values = Bids_ordered;

elseif LimitOrder.q<0  % the order is a sell order (an ask)
    
    % add the order id to existing asks ids
    if isfield(Book.(AssetId).Asks_ids,order_id_str)
        error('There is already an order in the book with the same id')
    else
        Book.(AssetId).Asks_ids.(order_id_str) = LimitOrder.agent_id;
    end

    % add the new LimitOrder at the end of existing Asks values
    Asks_not_ordered = [Book.(AssetId).Asks_values; LimitOrder_tmp];
  
    % order the Asks 
    [BestAsks, Idx_Asks_ordered] = sort(Asks_not_ordered(:,1));
    Idx_Asks_ordered = flipud(Idx_Asks_ordered);
    Asks_ordered = zeros(numel(BestAsks),7);
    Asks_ordered = Asks_not_ordered(Idx_Asks_ordered,:);
    Book.(AssetId).Asks_values = Asks_ordered;

else
    error('The quantity of the limit order is not well defined')
end