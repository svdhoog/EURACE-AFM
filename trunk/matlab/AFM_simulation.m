%%% AFM_simulation v1.33
%%% August 30th, 2007

%clc
%clear all
close all


%Set the BASE dir:
addpath(pwd);
BASE=pwd;

% Set the AFM path to all subdirs:
PATHfiles = dir;
jj = 0;
for ii =1:numel(PATHfiles)
    if PATHfiles(ii).isdir==1
        jj=jj+1;
%%    PATHDirs(jj).name = PATHfiles(ii).name;
    path=sprintf('%s/%s', BASE, PATHfiles(ii).name);
    PATHDirs(jj).name = path;
    end
end
addpath(PATHDirs.name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LoadingDay = NrDaysInitialization; %240; %NrDaysInitialization;
SavingStep = NrTotalDays+1; %340; %NrTotalDays;
%%%%%%%%%%%%%%%%%%%%%%%%

global Parameters
global DBFinancialAssets DBHouseholds DBFinancialMarketParticipants
global wage price price_inflation
global Days RealCalendarDates MonthlyCalendarDates 
global DividendsDynamicsMonthlyDays DividendsPaymentMonthlyDays 
global WageDynamicsMonthlyDays WagePaymentMonthlyDays
global BankInterestPaymentMonthlyDays 
global Book
global PensionFundManager Government
global NrBondsOutStanding

warning off

load(['..\data\AFM_t', num2str(LoadingDay)])

NrDaysFwd = Parameters.NrTotalDays-LoadingDay;
clear LoadingDay

if (Parameters.current_day+NrDaysFwd)>Parameters.NrTotalDays
    error('The current simulation exceeds the time scheduled duration of this Economy')
end

%randn('seed',1234567);
%rand('seed',1234567);

t_current_start = Parameters.current_day+1;

timerstart;

for t=t_current_start:Parameters.NrTotalDays

    timerclock;
    
    current_day = Days(t);
    current_month = MonthlyCounter(t);
    
    Parameters.current_day = current_day;
    Parameters.current_month = current_month;
    
    if (MonthlyCalendarDates(current_day)==1)&(MonthlyCalendarDates(current_day-1)~=1)
        fprintf('\r %%%%%%%%%%%%%%')
        fprintf('\r  New year ')
        fprintf('\r %%%%%%%%%%%%%%')
        yy = YearlyCalendarDates(t);
%         age_avg(yy) = DBHouseholds_age_advancement;
%         fprintf('\r Average age: %f',age_avg)
        [NrHouseholds_active, NrHouseholds_pensioned] = DBHouseholds_pensioning;
        fprintf('\r NrHouseholds active: %d \t pensioned: %d',NrHouseholds_active, NrHouseholds_pensioned)
   end
     
    
    fprintf('\r %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    fprintf('\r\r New day. Month: %4d \t Day: %3d',current_month,current_day)
    fprintf('\r %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    fprintf('\r\r Households aggregate values:')
    fprintf('\r HouseholdLiquidAssetsWealth: %9.2f \t BankAccount: %9.2f \t',...
        AggregateHouseholdsLiquidAssetsWealth(current_day-1),AggregateHouseholdsBankAccount(current_day-1))
    
    %%% Determination of the state of the economy
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Labor market and income accunting %%
    %% Note: labor wage dynamics is exogenously given
    %%
    %% Monthly wage dynamics
    if ismember(current_day,WageDynamicsMonthlyDays)
        LaborWageDynamics
    end
    
    AFM_labor_and_pension_payment
    %% Monthly market clearing and payment of labor income
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Capital income dynamics and accounting
    %% Note: dividends dynamics is exogenously given, coupons and interests
    %%       are fixed 
    %%
    %% Dividends dynamics
    if ismember(current_day,DividendsDynamicsMonthlyDays)
        DBStocks_DividendsDynamics
    end

    %%% Payment of capital income
    AFM_dividends_payment
    AFM_bank_interests_payment
    AFM_coupons_payment   
    if (MonthlyCalendarDates(current_day)~=MonthlyCalendarDates(current_day-1))
        AFM_capital_income_aggregation
    end
    %%% End of Payment of capital income

    AFM_AssetsBeliefsFormation
    
    if (MonthlyCalendarDates(current_day)~=MonthlyCalendarDates(current_day-1))
        AFM_income_and_taxation
        AFM_consumption_and_saving
        Government_accounting
    end
 
    AFM_portfolio_budget
    
    AFM_trading_activity
    
    AFM_learning 
    
    AFM_AssetsWeightsComputing

    AFM_OrdersIssuing    
    
    DBStocks_NrOutStandingShares_constant
    
    AFM_FinancialMarketSession
    
    AFM_transactions_accounting
    AFM_wealth_accounting
        
    if (MonthlyCalendarDates(current_day)~=MonthlyCalendarDates(current_day-1))
        PensionFundManager_new_quotes_distribution
    end

    %%% Saving
    if rem(t,SavingStep)==0
        fprintf('\r\r Saving data\r')
        save(['..\data\AFM_t', num2str(Parameters.current_day), '.mat'])
    end
    
end

fprintf('\r\r Final saving\r')
save(['..\data\AFM_t', num2str(Parameters.current_day), '.mat']) 
timerend; 
