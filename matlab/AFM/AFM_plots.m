clc
%clear all
%close all

nLags = 20;

NrBins = 9;
xVect_fit = -0.02:0.001:0.02;

color = 'b';
t_load = NrTotalDays;
Tf = t_load;

load(['..\data\AFM_t', num2str(t_load)])

t0 = Parameters.NrDaysInitialization + 1;
months_step = 2;  %yearly step
t_step = months_step*Parameters.NrDaysInMonth;

AssetsIds = fieldnames(DBFinancialAssets);

NrAssets = numel(AssetsIds);

prices = zeros(Tf,NrAssets);
returns = zeros(Tf-1,NrAssets);
volumes = zeros(Tf,NrAssets);

PDFdata_y = zeros(NrBins,NrAssets);
PDFdata_y = zeros(NrBins,NrAssets);
PDFnorm_y = zeros(numel(xVect_fit),NrAssets);

ACF = zeros(nLags+1,NrAssets);

font_sz = 14;
tick_sz = 14;

colore{1,1} = ['-', color];
colore{2,1} = ['-', color];
colore{3,1} = [':', color];
colore{4,1} = ['--', color];

line_width(1) = 0.5;
line_width(2) = 2;
line_width(3) = 2;
line_width(4) = 0.5;

markers{1,1} = [colore{1,1}, 'o'];
markers{2,1} = [colore{2,1}, 's'];
markers{3,1} = [colore{3,1}, 'v'];
markers{4,1} = [colore{4,1}, 'd'];

marker_sz(1) = 8;
marker_sz(2) = 8;
marker_sz(3) = 8;
marker_sz(4) = 8;


figure(1); hold on; grid on; box on

figure(2); hold on; grid on; box on

IdxDividendsPaymentMonthlyDays_plot = ...
    find((DividendsPaymentMonthlyDays>=t0)&(DividendsPaymentMonthlyDays<=tf));
DividendsPaymentMonthlyDays_plot = DividendsPaymentMonthlyDays(IdxDividendsPaymentMonthlyDays_plot);

for i=1:NrAssets

    %   fprintf('\r Loading asset %d',i)
    id = AssetsIds{i,1};

    prices(:,i) = DBFinancialAssets.(id).prices;
    returns(:,i) = diff(prices(:,i))./prices(2:end,i);

    figure(1);
    plot(prices(:,i),colore{i,1},'linewidth',line_width(i))


    if strcmp(DBFinancialAssets.(id).class,'stock')
        IdxMonthsCashFlows = MonthlyCounter(DividendsPaymentMonthlyDays_plot);
        cashFlows{:,i} = zeros(numel(IdxMonthsCashFlows),1);
        cashFlows{:,i} = DBFinancialAssets.(id).dividends(IdxMonthsCashFlows);
    elseif strcmp(DBFinancialAssets.(id).class,'bond')
        IdxDaysCashFlows = DBFinancialAssets.(id).CouponsPaymentDays;
        IdxMonthsCashFlows = MonthlyCounter(IdxDaysCashFlows);
        cashFlows{:,i} = zeros(numel(IdxMonthsCashFlows),1);
        cashFlows{:,i} = DBFinancialAssets.(id).NominalYield*DBFinancialAssets.(id).FaceValue;
    end



    CFYield = (1+cashFlows{:,i}./prices(IdxMonthsCashFlows,i)).^2-1;

    figure(2)
    subplot(2,1,1); hold on; grid on; box on
    plot(IdxDaysCashFlows,cashFlows{:,i},markers{i,1},'markersize',marker_sz(i),'linewidth',line_width(i))

    subplot(2,1,2); hold on; grid on; box on
    plot(IdxDaysCashFlows,100*CFYield,markers{i,1},'markersize',marker_sz(i),'linewidth',line_width(i))

    figure(4)
    subplot(NrAssets,1,i); hold on; grid on, box on
    bar(100*returns(:,i))
    %xlabel('t','fontsize',font_sz)
    ylabel('returns (%)','fontsize',font_sz)
    set(gca,'xtick',[1, t_step:t_step:t],'fontsize',tick_sz)
    set(gca,'xlim',[0.9, t+0.1])
    title(id,'fontsize',font_sz)


    [ACF(:,i), Lags, Bounds] = autocorr(returns(:,i), nLags);


    figure(5)
    subplot(NrAssets,1,i); hold on; grid on, box on
    bar(Lags,ACF(:,i))
    ylabel('ACF','fontsize',font_sz)
    set(gca,'xtick',[0:nLags],'fontsize',tick_sz)
    set(gca,'xlim',[-0.1, nLags+0.1])
    title(id,'fontsize',font_sz)


    [PDFdata_y, PDFdata_x, PDFnorm_y]=EmpPDFAnalysis(returns(:,i),NrBins,xVect_fit);

    figure(6)
    subplot(ceil(NrAssets/2),2,i); hold on; grid on, box on
    plot(100*PDFdata_x,PDFdata_y,'.')
    plot(100*xVect_fit,PDFnorm_y)
    set(gca,'yscale','log')
    xlabel('returns (%)','fontsize',font_sz)
    ylabel('PDF','fontsize',font_sz)
    title(id,'fontsize',font_sz)

    h_jb(i) = jbtest(returns(:,i));

    res = NaN;
    if h_jb(i)==1
        res = 'rejected';
    elseif h_jb(i)==0
        res = 'acecpted';
    end
    fprintf('\r Jarque_Bera Test. Null hypothesis of gaussian returns %s',res)

    E_I = (1-Parameters.Households.UnemploymentProbability)*exp(Parameters.MonthlyWageGrowthRate)*wage';


end

AssetsIds_new = AssetsIds;

AssetsIds_new{1,1} = 'S1';
AssetsIds_new{2,1} = 'S2';


figure(1); 
xlabel('t (days)','fontsize',font_sz)
ylabel('P (asset prices)','fontsize',font_sz)
set(gca,'xlim',[0.9, Tf+0.1])
set(gca,'xtick',[1, t_step:t_step:t],'fontsize',tick_sz)
legend(AssetsIds_new,0)

figure(2)
subplot(2,1,1)
xlabel('t (days)','fontsize',font_sz)
ylabel('cash flow ','fontsize',font_sz)
set(gca,'xlim',[0.9, t+0.1])
set(gca,'xtick',[1, t_step:t_step:t],'fontsize',tick_sz)
legend(AssetsIds_new,2)

subplot(2,1,2)
xlabel('t (days)','fontsize',font_sz)
ylabel('cash flow yields (%)','fontsize',font_sz)
set(gca,'xlim',[0.9, t+0.1])
set(gca,'xtick',[1, t_step:t_step:t],'fontsize',tick_sz)
legend(AssetsIds_new,2)



% Macroeconomic aggregates plots

figure(100); hold on; grid on; box on
plot(AggregateConsumptionBudget,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Consumption budget','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

figure(101); hold on; grid on; box on
plot(cumsum(-Government.financial_budget),color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Government debt','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

figure(102); 
subplot(2,1,1); hold on; grid on; box on
plot(Aggregate_x_hat,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('average x','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

subplot(2,1,2); hold on; grid on; box on
plot(Aggregate_ni_hat,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('average \nu','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

figure(103); 
subplot(3,1,1); hold on; grid on; box on
plot(wage,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('wage','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

subplot(3,1,2); hold on; grid on; box on
plot(AggregateLaborTaxation,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Aggregate Labor Taxation','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

subplot(3,1,3); hold on; grid on; box on
plot(AggregateNetIncome,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Aggregate Net Income','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)



figure(104); 
subplot(3,1,1); hold on; grid on; box on
plot(AggregatePensionFundManagerCapitalTaxation,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Aggregate Pension Fund Manager Capital Taxation','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

subplot(3,1,2); hold on; grid on; box on
plot(AggregateHouseholdsCapitalTaxation,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Aggregate Households Capital Taxation','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)

subplot(3,1,3); hold on; grid on; box on
plot(Government.tax_collection,color)
xlabel('m (months)','fontsize',font_sz)
ylabel('Government tax collection','fontsize',font_sz)
set(gca,'xlim',[0.9, Parameters.NrTotalMonths+0.1])
set(gca,'xtick',[1, months_step:months_step:Parameters.NrTotalMonths],'fontsize',tick_sz)


figure(105); 
subplot(2,1,1); hold on; grid on; box on
hold on; grid on; box on
plot(AggregateBankAccount,color)
xlabel('t (days)','fontsize',font_sz)
ylabel('Aggregate bank account','fontsize',font_sz)
set(gca,'xlim',[0.9, Tf+0.1])
set(gca,'xtick',[1, t_step:t_step:Tf],'fontsize',tick_sz)

subplot(2,1,2); hold on; grid on; box on
plot(AggregateLiquidAssetsWealth(1:Tf)+...
    AggregateBankAccount(1:Tf),color)
xlabel('t (days)','fontsize',font_sz)
ylabel('Aggregate households wealth','fontsize',font_sz)
set(gca,'xlim',[0.9, Tf+0.1])
set(gca,'xtick',[1, t_step:t_step:Tf],'fontsize',tick_sz)

