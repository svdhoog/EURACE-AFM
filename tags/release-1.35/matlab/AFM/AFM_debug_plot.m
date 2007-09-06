clc
clear all
close all

LoadingDay = 480;

color = 'b';

load(['..\data\AFM_t', num2str(LoadingDay)])

AssetsIds = fieldnames(DBFinancialAssets);
NrAssets = numel(AssetsIds);

colore{1,1} = ['-', color];
colore{2,1} = ['-', color];
colore{3,1} = [':', color];
colore{4,1} = ['--', color];

line_width(1) = 0.5;
line_width(2) = 2;
line_width(3) = 2;
line_width(4) = 0.5;

font_sz = 14;  tick_sz = 12;

t0 = Parameters.NrDaysInitialization; m0 = Parameters.NrMonthsInitialization;
Tf = LoadingDay;
mf = Parameters.NrTotalMonths  - Parameters.NrMonthsInitialization;
t_step = floor(LoadingDay/100)*10;

figure(1); hold on; grid on; box on
figure(2); 
subplot(3,1,1); hold on; grid on; box on
subplot(3,1,2); hold on; grid on; box on
subplot(3,1,3); hold on; grid on; box on

figure(3); hold on; grid on; box on


for i=1:NrAssets
    
 %   fprintf('\r Loading asset %d',i)
    id = AssetsIds{i,1};

    prices(:,i) = DBFinancialAssets.(id).prices(1:Tf);

    figure(1); 
    plot(prices(:,i),colore{i,1},'linewidth',line_width(i))
    
    figure(2); subplot(3,1,1);
    plot(t0:Tf,PriceReturns(t0:Tf,i),colore{i,1},'linewidth',line_width(i))
    
    figure(2); subplot(3,1,2);
    plot(t0:Tf,TotalReturns(t0:Tf,i),colore{i,1},'linewidth',line_width(i))
    
    figure(2); subplot(3,1,3);
    plot(t0:Tf,AgregateVolatilities(t0:Tf,i),colore{i,1},'linewidth',line_width(i))
    
    figure(3);
    plot(t0:Tf,weights_mean(t0:Tf,i),colore{i,1},'linewidth',line_width(i))
    
end


figure(4); subplot(2,1,1); hold on; grid on; box on
plot(m0:mf,AggregateConsumptionBudget(m0:mf),color)
figure(4); subplot(2,1,2); hold on; grid on; box on
plot(m0:mf,wage(m0:mf),color)


figure(1); 
xlabel('t (days)','fontsize',font_sz)
ylabel('P (asset prices)','fontsize',font_sz)
set(gca,'xlim',[0.9, Tf+0.1])
set(gca,'xtick',[1, t_step:t_step:t],'fontsize',tick_sz)
legend(AssetsIds,0)


figure(5);
plot(DBPortfolioAllocationRulesHouseholds_utilization_array);
axis tight, xlabel('time (days)'), ylabel('user count');
filename=sprintf('./PortfolioAllocationRulesH_utilization_array');
disp(filename);
laprint(gcf,filename); 

figure(6);
plot(DBPortfolioAllocationRulesHouseholds_performance_array);
axis tight, xlabel('time (days)'), ylabel('performance');
filename=sprintf('./PortfolioAllocationRulesH_performance_array');
disp(filename);
laprint(gcf,filename); 

figure(7);
plot(DBPortfolioAllocationRulesAMCs_utilization_array);
axis tight, xlabel('time (days)'), ylabel('user count');
filename=sprintf('./PortfolioAllocationRulesAMC_utilization_array');
disp(filename);
laprint(gcf,filename); 

figure(8);
plot(DBPortfolioAllocationRulesAMCs_performance_array);
axis tight, xlabel('time (days)'), ylabel('performance');
filename=sprintf('./PortfolioAllocationRulesAMC_performance_array');
disp(filename);
laprint(gcf,filename); 