function[TransactionsMatrix]=DBFinancialMarketParticipants_LimitOrders_Book_inserting(AssetId)

% Version 1
% Marco Raberto, August 31, 2007

global Parameters DBFinancialMarketParticipants DBFinancialAssets Book 

t = Parameters.current_day;
TenthsSecs_daily = 10*60*60*24; % number of tenths of seconds in a day

FinancialMarketParticipantsIDs = fieldnames(DBFinancialMarketParticipants);
NrFinancialMarketParticipants = numel(FinancialMarketParticipantsIDs);

Indexes_new = randperm(NrFinancialMarketParticipants);
WaitingTimes = ceil(exprnd(10,NrFinancialMarketParticipants,1));
OrdersTimes = cumsum(WaitingTimes);
if OrdersTimes(end)>TenthsSecs_daily  % number of tenths of seconds in a day
    error('The last order time exceeds the number of tenths of seconds in a day')
end

TransactionsMatrix = [];

for h=1:NrFinancialMarketParticipants
    Idx = Indexes_new(h);
    id = FinancialMarketParticipantsIDs{Idx,1};
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    if ~isfield(FinancialMarketParticipant,'trading_activity')
        fprintf('%s',FinancialMarketParticipant.id)
    end
    if FinancialMarketParticipant.trading_activity(t)==1
        if (FinancialMarketParticipant.pending_orders.(AssetId).q)~=0
            LimitOrder.p = FinancialMarketParticipant.pending_orders.(AssetId).pLimit;
            LimitOrder.q = FinancialMarketParticipant.pending_orders.(AssetId).q;
            LimitOrder.AssetId = AssetId;
            LimitOrder.agent_id = FinancialMarketParticipant.id;
            LimitOrder.emissionDayTime = t;
            LimitOrder.emissionIntradayTime = OrdersTimes(h);
            LimitOrder.cancellationDayTime = t;
            LimitOrder.cancellationIntradayTime = TenthsSecs_daily;

            Transactions = Book_limit_order_insert(LimitOrder);

            if Parameters.Book_print==1
                fprintf('\r\r Incoming limit order:')
                fprintf('\r Asset id \t issuer id \t limit price \t qty')
                fprintf('\r %s \t %s \t %f \t %d',AssetId,FinancialMarketParticipant.id,...
                    LimitOrder.p,LimitOrder.q)
                Book_print(AssetId)
                Transactions_print(Transactions)
                fprintf('\r\r Please, press any key to continue')

                pause
            end

            NrTransactions = numel(Transactions);

            if NrTransactions>0
                for i=1:NrTransactions
                    TransactionsMatrix = [TransactionsMatrix; ...
                        Transactions(i).p_trade, Transactions(i).q_trade, Transactions(i).IntradayTime];
                end
            end
            
            clear Transactions
        end
    elseif FinancialMarketParticipant.trading_activity(t)~=1
        error('The FinancialMarketParticipant is not active in the financial market')
    end
    clear tmp id FinancialMarketParticipant p q
end