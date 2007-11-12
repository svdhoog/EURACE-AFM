%%% Stocks %%%
Parameters.Stocks.PricesInitializationType = 'RandomWalk';
Parameters.Stocks.PricesInitializationScaleFactor = 100;
Parameters.Stocks.PricesInit = 100;
Parameters.Stocks.Ids = fieldnames(DBFirms);
Parameters.Stocks.NrOutStandingShares0 = 200000;

Parameters.Stocks.DividendsPeriodicityNrMonths = 6;
Parameters.Stocks.Dividends0 = 1;
Parameters.Stocks.DividendsGrowthRateMin = 0.002;
Parameters.Stocks.DividendsGrowthRateMax = 0.0022;
Parameters.Stocks.DividendsGrowthRateSigma = 0.02;

%%% Dividends growth rates determination %%%

growth_rates = linspace(Parameters.Stocks.DividendsGrowthRateMin,...
    Parameters.Stocks.DividendsGrowthRateMax,Parameters.NrFirms);

for i=1:Parameters.NrFirms
    id = Parameters.Stocks.Ids{i,1};
    Parameters.Stocks.(id).DividendsGrowthRate = growth_rates(i);
    Parameters.Stocks.(id).DividendsSigma = Parameters.Stocks.DividendsGrowthRateSigma;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Bonds %%%
% Parameters.Bonds.Ids = {};
Parameters.Bonds.PricesInitializationType = 'RandomWalk';
Parameters.Bonds.PricesInitializationScaleFactor = 500;
Parameters.Bonds.Ids = {'GovBond'};

Parameters.Bonds.GovBond.IssueDay = NrDaysInitialization+1;
Parameters.Bonds.GovBond.MaturityDay = Days(end);
Parameters.Bonds.GovBond.CouponPeriodicityNrMonths = 6;
Parameters.Bonds.GovBond.NominalYield = 0.01;
Parameters.Bonds.GovBond.FaceValue = 100;
Parameters.Bonds.GovBond.NrOutStandingShares0 = 200000;


%%% Asset initialization %%%
DBFinancialAssets_creation();
