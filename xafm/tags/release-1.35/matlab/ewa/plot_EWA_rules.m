%SCRIPT plot_EWA_rules
%Script to print data related to rules: usage count, performance
%All plotting occurs to the local directory

clc
close all
cd(directory);

h=0;

h=h+1;
figure(h);
plot(DBPortfolioAllocationRulesHouseholds_utilization_array);
axis tight, xlabel('time (days)'), ylabel('user count');
filename=sprintf('./PortfolioAllocationRulesHousehold_utilization_array');
disp(filename);
laprint(gcf,filename); 

h=h+1;
figure(h);
plot(DBPortfolioAllocationRulesHouseholds_performance_array);
axis tight, xlabel('time (days)'), ylabel('performance');
filename=sprintf('./PortfolioAllocationRulesHousehold_performance_array');
disp(filename);
laprint(gcf,filename); 

h=h+1;
figure(h);
plot(DBPortfolioAllocationRulesAMCs_utilization_array);
axis tight, xlabel('time (days)'), ylabel('user count');
filename=sprintf('./PortfolioAllocationRulesAMC_utilization_array');
disp(filename);
laprint(gcf,filename); 

h=h+1;
figure(h);
plot(DBPortfolioAllocationRulesAMCs_performance_array);
axis tight, xlabel('time (days)'), ylabel('performance');
filename=sprintf('./PortfolioAllocationRulesAMC_performance_array');
disp(filename);
laprint(gcf,filename); 

close all
cd('../../..');
