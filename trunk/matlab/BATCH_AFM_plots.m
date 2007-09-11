%SCRIPT BATCH_AFM_plots
%Script to print data related to variables: prices, returns.
%All plotting occurs in the directory variable set in BATCH_plots.
%
%% 6 September 2007, Sander van der Hoog, (svdhoog@gmail.com)

%clc
%clear all
%close all

nLags = 20;

NrBins = 9;
xVect_fit = -0.02:0.001:0.02;

color = 'b';
t_load = NrTotalDays;
Tf = t_load;

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


IdxDividendsPaymentMonthlyDays_plot = ...
    find((DividendsPaymentMonthlyDays>=t0)&(DividendsPaymentMonthlyDays<=Tf));
DividendsPaymentMonthlyDays_plot = DividendsPaymentMonthlyDays(IdxDividendsPaymentMonthlyDays_plot);


%%This loop results in plots for each asset separately:
for i=1:NrAssets

    fprintf('Loading asset %d\n',i)
    id = AssetsIds{i,1};

    prices(:,i) = DBFinancialAssets.(id).prices;
    returns(:,i) = diff(prices(:,i))./prices(2:end,i);

    figure(i); hold on; grid on; box on;
    plot(prices(:,i),colore{1,1},'linewidth',line_width(1));
    axis tight; title('Prices');
    filename=sprintf('./prices_asset%d', i);
    disp(filename);
    laprint(gcf,filename); 
%    print(gcf, '-deps', filename); 
    
    figure(NrAssets+i); hold on; grid on; box on;
    plot(returns(:,i),colore{1,1},'linewidth',line_width(1));
    axis tight; title('Returns');
    filename=sprintf('./returns_asset%d', i);
    disp(filename);
    laprint(gcf,filename); 
%    print(gcf, '-deps', filename); 

end;

%Printing of the eps files occurs at the end
if(run_nr==TOTNR_RUNS)
for i=1:NrAssets
    figure(i);
    filename=sprintf('./prices_asset%d', i);
    disp(filename);
    laprint(gcf,filename); 
%    print(gcf, '-deps', filename); 
end;
close all;
end;

return;
