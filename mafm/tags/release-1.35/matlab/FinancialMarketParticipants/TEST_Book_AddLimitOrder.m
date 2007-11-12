% Version 1.0, August 28th, 2007
%
% For any question, please contact Marco Raberto  

clc
clear all
close all

global Book

Book.S1.Bids_values = [];
Book.S1.Asks_values = [];
Book.S1.Bids_ids = [];
Book.S1.Asks_ids = [];

%%% Add Buy Limit Order 1
LimitOrder.AssetId = 'S1';
LimitOrder.p = 10;
LimitOrder.q = 2;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 1;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_7';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Add Buy Limit Order 2
LimitOrder.AssetId = 'S1';
LimitOrder.p = 11;
LimitOrder.q = 3;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 2;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_8';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Add Buy Limit Order 3
LimitOrder.AssetId = 'S1';
LimitOrder.p = 10.5;
LimitOrder.q = 13;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 4;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_4';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Add Buy Limit Order 4
LimitOrder.AssetId = 'S1';
LimitOrder.p = 10.5;
LimitOrder.q = 14;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 6;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_41';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Add Ask Limit Order 1
LimitOrder.AssetId = 'S1';
LimitOrder.p = 10;
LimitOrder.q = -20;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 11;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_7';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Add Ask Limit Order 2
LimitOrder.AssetId = 'S1';
LimitOrder.p = 11;
LimitOrder.q = -23;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 12;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_8';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Add Ask Limit Order 3
LimitOrder.AssetId = 'S1';
LimitOrder.p = 8;
LimitOrder.q = -13;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 14;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_4';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Add Ask Limit Order 4
LimitOrder.AssetId = 'S1';
LimitOrder.p = 10;
LimitOrder.q = -13;
LimitOrder.emissionDayTime = 100;
LimitOrder.emissionIntradayTime = 24;
LimitOrder.cancellationDayTime = 100;
LimitOrder.cancellationIntradayTime = 1000;
LimitOrder.agent_id = 'household_14';

Book_AddLimitOrder(LimitOrder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Book.S1.Bids_values
Book.S1.Asks_values

Book.S1.Bids_ids
Book.S1.Asks_ids