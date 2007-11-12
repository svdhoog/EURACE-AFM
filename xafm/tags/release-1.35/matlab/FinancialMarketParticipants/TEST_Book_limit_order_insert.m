clc
clear all
close all

global Parameters DBFinancialMarketParticipants Book

t = 4;

Parameters.current_day = t;

DBFinancialMarketParticipants.household_1.portfolio.S1 = 10;
DBFinancialMarketParticipants.household_1.portfolio.transactions_accounting = zeros(10,1);

DBFinancialMarketParticipants.household_22.portfolio.S1 = 3;
DBFinancialMarketParticipants.household_22.portfolio.transactions_accounting = zeros(10,1);

DBFinancialMarketParticipants.AMC_3.portfolio.S1= 10;
DBFinancialMarketParticipants.AMC_3.portfolio.transactions_accounting = zeros(10,1);

DBFinancialMarketParticipants.household_4.portfolio.S1 = 0;
DBFinancialMarketParticipants.household_4.portfolio.transactions_accounting = zeros(10,1);


Book.S1.Asks_values = [];
Book.S1.Bids_values = [];

Book.S1.Asks_ids = [];
Book.S1.Bids_ids = [];

AssetId = 'S1';

LimitOrder.AssetId = AssetId;
LimitOrder.p = 10;
LimitOrder.q = -3;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 10;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_1';

Book_limit_order_insert(LimitOrder);
Book_print(AssetId)


clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 11;
LimitOrder.q = -2;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 11;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_22';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)


clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 8;
LimitOrder.q = 1;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 12;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'AMC_3';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)


clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 9;
LimitOrder.q = 1;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 13;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_4';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 12;
LimitOrder.q = 2;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 13;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_4';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 11.5;
LimitOrder.q = 2;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 13;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_4';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 10;
LimitOrder.q = -2;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 120;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_1';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 7.5;
LimitOrder.q = -3;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 125;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_1';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 7.2;
LimitOrder.q = 4;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 127;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_4';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 7.3;
LimitOrder.q = 2;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 140;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'household_4';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')

clear LimitOrder
LimitOrder.AssetId = AssetId;
LimitOrder.p = 7;
LimitOrder.q = -7;
LimitOrder.emissionDayTime = t;
LimitOrder.emissionIntradayTime = 160;
LimitOrder.cancellationDayTime = t;
LimitOrder.cancellationIntradayTime = 100;
LimitOrder.agent_id = 'AMC_3';
Book_limit_order_insert(LimitOrder);
Book_print(AssetId)

DBFinancialMarketParticipants_assets_holdings_print('S1')