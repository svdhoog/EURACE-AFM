clc
clear all

global Parameters DBFinancialAssets Noises

figure(1); hold on; grid on; box on

%%%%%%%%LEGENDA%%%%%%%%%
color1 = 'b';
color2 = 'r';

font_sz = 14;  tick_sz = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%

LoadingDay = 50;
load(['..\data\AFM_t', num2str(LoadingDay)])

for index = (Parameters.NrDaysInitialization+1):Parameters.NrTotalDays
        
    current_day = Days(index);
    current_month = MonthlyCounter(index);
    
    Parameters.current_day = current_day;
    Parameters.current_month = current_month;
    
    if ismember(current_day,DividendsDynamicsMonthlyDays)
        
        FinancialAssetsIds = fieldnames(DBFinancialAssets);
        
        for fa = 1:numel(FinancialAssetsIds)
            
            id = FinancialAssetsIds{fa,1};
            FinancialAsset = DBFinancialAssets.(id);
            
            if strcmp(FinancialAsset.class,'stock')
                
                stock = FinancialAsset;
                
                m = Parameters.current_month;

                id = stock.id;

                LastDividend = stock.dividends(m-1);

                growth_rate = Parameters.Stocks.(id).DividendsGrowthRate;
                s = Parameters.Stocks.(id).DividendsSigma;

                NewDividend_Log = log(LastDividend) + growth_rate + s*Noises.(id)(m);
                stock.dividends(m) = exp(NewDividend_Log);
                
                DBFinancialAssets.(id) = stock;
            end
            
            clear FinancialAsset stock
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);subplot(2,1,1); hold on; grid on; box on
plot(1:Parameters.NrTotalDays,DBFinancialAssets.('F1').dividends,color1);
xlabel('t (days)','fontsize',font_sz)
ylabel('Dividends','fontsize',font_sz)

figure(1);subplot(2,1,2); hold on; grid on; box on
plot(1:Parameters.NrTotalDays,DBFinancialAssets.('F2').dividends,color2);
xlabel('t (days)','fontsize',font_sz)
ylabel('Dividends','fontsize',font_sz)
