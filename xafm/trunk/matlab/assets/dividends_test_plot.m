clc
clear all

global Parameters DBFinancialAssets

figure(1); hold on; grid on; box on

%%%%%%%%LEGENDA%%%%%%%%%
color1 = 'b';
color2 = 'r';

colore{1,1} = ['-', color1];
colore{2,1} = ['--', color2];

line_width(1) = 0.5;
line_width(2) = 2;

font_sz = 14;  tick_sz = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%

LoadingDay = 240;

load(['..\data\AFM_t', num2str(LoadingDay)])

FinancialAssetsIds = fieldnames(DBFinancialAssets);

NrMonths = Parameters.NrTotalMonths - Parameters.NrMonthsInitialization;

for jj = 1:numel(FinancialAssetsIds)
    id = FinancialAssetsIds{jj,1};

    FinancialAsset = DBFinancialAssets.(id);
    
    if strcmp(FinancialAsset.class,'stock')

        growth_rate = Parameters.Stocks.(id).DividendsGrowthRate;
        s = Parameters.Stocks.(id).DividendsSigma;

        NewDividend_Log(1:Parameters.NrMonthsInitialization) = 0;

        for m=(Parameters.NrMonthsInitialization+1):Parameters.NrTotalMonths
            NewDividend_Log(m) = NewDividend_Log(m-1) + growth_rate + s*Noises.(id)(m);
        end

        plot(1:Parameters.NrTotalMonths,exp(NewDividend_Log),colore{jj,1});

        clear id NewDividend_Log

    end
    
    clear FinancialAsset
    
end
