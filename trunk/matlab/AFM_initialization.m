%%% AFM_initialization v1.33 
%%% August 30rd, 2007
%%%
%%%CHANGES: 
%%% Sander: July 23, Merged to work with EWA files

%clc
%clear all
close all

% Set the AFM path
PATHfiles = dir;
jj = 0;
for ii =1:numel(PATHfiles)
    if PATHfiles(ii).isdir==1
        jj=jj+1;
    PATHDirs(jj).name = PATHfiles(ii).name;
    end
end
addpath(PATHDirs.name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set testing mode:
global TESTMODE;
%TESTMODE=1;  %testing ON
TESTMODE=0; %testing OFF

% Duration of the simulation
NrMonths = 4;
NrDaysInMonth = 5;

% initialization
NrMonthsInitialization = 2;
NrDaysInitialization = NrMonthsInitialization*NrDaysInMonth;

NrTotalMonths = NrMonths + NrMonthsInitialization;
NrTotalDays = NrTotalMonths*NrDaysInMonth;

NrHouseholds = 200;
NrFirms = 2;

global DBFirms DBFinancialAssets DBHouseholds DBAMCs
global DBPortfolioAllocationRulesHouseholds DBPortfolioAllocationRulesAMCs 
global FinancialAdvisor Government
global wage price
global Days MonthlyDates 
global DividendsDynamicsMonthlyDays DividendsPaymentMonthlyDays 
global WageDynamicsMonthlyDays WagePaymentMonthlyDays
global BankInterestPaymentMonthlyDays 
global Parameters Noises
global NrYears
global Book

%randn('seed',1234567);
%rand('seed',1234567);

%%%%  Government policy parameters %%%%%
Parameters.GovernmentPolicy.LastWagePublicPensionSubstitutionRate = 0.75;
Parameters.GovernmentPolicy.LaborTaxRate = 0.1;
Parameters.GovernmentPolicy.CapitalTaxRate = 0.1;
%%%%  End of Government policy parameters %%%%%

% Parameters of the Clearing Mechanism
Parameters.ClearingMechanism = 'ClearingHouse';
%Parameters.ClearingMechanism = 'LimitOrderBook';

%%% Central Bank policy parameters %%%
Parameters.CentralBankPolicy.RiskFreeRate = 0.01;
%%% End of Central Bank policy parameters %%%

%%% Banking system policy parameters %%%
Parameters.BankInterestsPeriodicityNrMonths = 3;
%%% End of Banking system policy parameters %%%

%%%% Pension Fund Manager policy parameters %%%%%
Parameters.PensionFundManager.PaymentRate = 0.06;
%%%% End of Pension Fund Manager policy parameters %%%%%

%%% Households tuning parameters %%%
Parameters.Households.Learning = 'EWA';
%Parameters.Households.Learning = 'None';

Parameters.Households.x_hat_grid = 1:0.2:4;
Parameters.Households.ni_hat_grid = 0;
Parameters.Households.x_hat0 = 3.5;
Parameters.Households.ConsumptionLearningProbability =0;

Parameters.Households.AgeDimension = 0;
Parameters.Households.age_avg = 40;
Parameters.Households.age_max = 90;
Parameters.Households.RetirementAge = 65;

if Parameters.Households.AgeDimension == 0;
    Parameters.Households.RetirementAge = 65;
elseif Parameters.Households.AgeDimension==1
    Parameters.Households.age_min = 30;
    Parameters.Households.age_logn_std = 0.3;
end

Parameters.Households.TimeInconsistencyFactor = 0.6;
Parameters.Households.UnemploymentProbability = 0.1;
Parameters.Households.RelativeRiskAversion = 2;
Parameters.Households.DiscountFactor = 0.95;
Parameters.Households.MPC = 0.3;
Parameters.Households.RandomBehaviorProbability = 1;
Parameters.Households.ChartistBehaviorProbability = 0.0;

%%%%% Time Initialization %%%%%%%
Parameters.NrDaysInitialization = NrDaysInitialization;
Parameters.NrMonthsInitialization = NrMonthsInitialization;
Parameters.NrTotalMonths = NrTotalMonths;
Parameters.NrTotalDays = NrTotalDays;
Parameters.NrDaysInMonth = NrDaysInMonth;
Parameters.NrDaysInYear = 12*NrDaysInMonth;
Parameters.current_day = NrDaysInitialization;
Parameters.current_month = NrMonthsInitialization;

Days = zeros(NrTotalDays,1);
Days = (1:NrTotalDays)';

tmp = repmat((1:NrTotalMonths),[NrDaysInMonth, 1]);
MonthlyCounter = tmp(:);
clear tmp

[MonthlyCalendarDates, YearlyCalendarDates] = MonthlyCounter2MonthlyCalendarDates(MonthlyCounter);
RealCalendarDates = RealCalendarDatesBuilding(MonthlyCalendarDates,YearlyCalendarDates);
%%%%% End of Time Initializetion %%%%%%%

%%% Computation Parameters  %%%
Parameters.IRR.guess = 0.1;
Parameters.IRR.MaxIter = 100;
Parameters.MPT.NrEFPortfolios = 50;
%%% End Computation Parameters  %%%

Parameters.AssetsBeliefsDefaultStd = 0.5;
Parameters.PriceReturn_min = -0.9;

%%% Exogenous economy parameters %%%
Parameters.MonthlyWageGrowthRate = 0.001;
Parameters.WageSigma = 0.004;
%%% End of exogenous economy parameters %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBFirms_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBFinancialAssets_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBPortfolioAllocationRulesHouseholds_initialization
NrTotalRules = numel(fieldnames(DBPortfolioAllocationRulesHouseholds));
DBPortfolioAllocationRulesHouseholds_utilization_array = zeros(NrTotalDays,NrTotalRules);
DBPortfolioAllocationRulesHouseholds_performance_array = zeros(NrTotalDays,NrTotalRules);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBPortfolioAllocationRulesAMCs_initialization
NrTotalRules = numel(fieldnames(DBPortfolioAllocationRulesAMCs));
DBPortfolioAllocationRulesAMCs_utilization_array = zeros(NrTotalDays,NrTotalRules);
DBPortfolioAllocationRulesAMCs_performance_array = zeros(NrTotalDays,NrTotalRules);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Government_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinancialAdvisor_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBHouseholds_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Noises_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PensionFundManager_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBAMCs_initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(Parameters.ClearingMechanism,'LimitOrderBook')
    Book_initialization
end

NrAssets = numel(fieldnames(DBFinancialAssets));

%%% Initialization of aggregate economic variables, registered on a monthly base
AggregateHouseholdsCapitalIncome = zeros(Parameters.NrTotalMonths,1);
AggregateLaborIncome = zeros(Parameters.NrTotalMonths,1);
AggregatePublicPensionIncome = zeros(Parameters.NrTotalMonths,1);
AggregatePrivatePensionIncome = zeros(Parameters.NrTotalMonths,1);

AggregateLaborTaxation = zeros(Parameters.NrTotalMonths,1);
AggregateHouseholdsCapitalTaxation = zeros(Parameters.NrTotalMonths,1);
AggregatePensionTaxation = zeros(Parameters.NrTotalMonths,1);
AggregateHouseholdsNetIncome = zeros(Parameters.NrTotalMonths,1);

AggregateAMCsCapitalNetIncome = zeros(Parameters.NrTotalMonths,1);
AggregateAMCsCapitalTaxation = zeros(Parameters.NrTotalMonths,1);

AggregateCashOnHands = zeros(Parameters.NrTotalMonths,1);
AggregateConsumptionBudget = zeros(Parameters.NrTotalMonths,1);
Aggregate_x_hat = zeros(Parameters.NrTotalMonths,1);
Aggregate_ni_hat = zeros(Parameters.NrTotalMonths,1);
AggregatePensionFundSaving = zeros(Parameters.NrTotalMonths,1);
AggregateTaxDetraction = zeros(Parameters.NrTotalMonths,1);

%%% End of initialization of aggregate economic variables, registered on a monthly base

%%% Initialization of financial aggregate variables, registered on a daily base
AggregateHouseholdsBankAccount = zeros(Parameters.NrTotalDays,1);
AggregateHouseholdsPortfolioBudget = zeros(Parameters.NrTotalDays,1);
AggregateHouseholdsLiquidAssetsWealth = zeros(Parameters.NrTotalDays,1);

AggregateAMCsBankAccount = zeros(Parameters.NrTotalDays,1);
AggregateAMCsPortfolioBudget = zeros(Parameters.NrTotalDays,1);
AggregateAMCsLiquidAssetsWealth = zeros(Parameters.NrTotalDays,1);

AggregateBankAccount = zeros(Parameters.NrTotalDays,1);
AggregatePortfolioBudget = zeros(Parameters.NrTotalDays,1);
AggregateLiquidAssetsWealth = zeros(Parameters.NrTotalDays,1);


AggregateAssetsMeanWeights = zeros(Parameters.NrTotalDays,NrAssets);
AggregateTransactionsAccounting = zeros(Parameters.NrTotalDays,1);

AggregateHouseholdsLiquidAssetsWealth(1:Parameters.NrDaysInitialization) = ...
    DBHouseholds_liquid_assets_wealth_aggregation(Parameters.NrDaysInitialization);

AggregateHouseholdsBankAccount(1:Parameters.NrDaysInitialization) = ...
    DBHouseholds_bank_account_aggregation(Parameters.NrDaysInitialization);

average_wealth_per_head = ...
    (AggregateHouseholdsLiquidAssetsWealth(Parameters.NrDaysInitialization)+...
    AggregateHouseholdsBankAccount(Parameters.NrDaysInitialization))/Parameters.NrHouseholds;


%%% Initialization of economic exogneous variables
wage0 = average_wealth_per_head/(12*(Parameters.Households.x_hat0-1));
wage0 = wage0/(1-Parameters.GovernmentPolicy.LaborTaxRate);
wage = NaN*ones(Parameters.NrTotalMonths,1);
wage(1:NrMonthsInitialization) = wage0;
%%% End of initialization of economic exogenous variables

%%%%%%%

% wage dynamics and payment, and dividends dynamics is set at the
% beginning of each month
WageDynamicsMonthlyDays = Days(1:NrDaysInMonth:end);
WagePaymentMonthlyDays = WageDynamicsMonthlyDays;
DividendsDynamicsMonthlyDays = WageDynamicsMonthlyDays;

DividendsPaymentMonthlyDays = ...
    Days(1:(NrDaysInMonth*Parameters.Stocks.DividendsPeriodicityNrMonths):end);

BankInterestsPaymentMonthlyDays = ...
    Days(1:(NrDaysInMonth*Parameters.BankInterestsPeriodicityNrMonths):end);;

NrBondsOutStanding = zeros(Parameters.NrTotalDays,1);

%%% graphics and printing
Parameters.graphics.household_intertemporal_expected_utility_graphics = 0;
Parameters.prompt_print=0;
Parameters.Book_print = 0;
Parameters.classifiersystem_print = 0;

save(['..\data\AFM_t', num2str(Parameters.current_day)]) 