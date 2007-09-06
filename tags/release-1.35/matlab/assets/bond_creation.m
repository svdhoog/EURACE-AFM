function[bond]=bond_creation(id)

global Parameters Days

%%% Data types creation %%%
bond.class = 'bond';
bond.id = id;
bond.IssueDay = Parameters.Bonds.(id).IssueDay;
bond.MaturityDay = Parameters.Bonds.(id).MaturityDay;
bond.NominalYield = Parameters.Bonds.(id).NominalYield;
bond.FaceValue = Parameters.Bonds.(id).FaceValue;
bond.NrOutStandingShares = NaN*ones(Parameters.NrTotalDays,1);
bond.NrOutStandingShares(1:Parameters.NrDaysInitialization) = Parameters.Bonds.(id).NrOutStandingShares0;

bond.prices = NaN*ones(Parameters.NrTotalDays,1);
if strcmp(Parameters.Bonds.PricesInitializationType,'RandomWalk')
    Ret_tmp = [0; randn(Parameters.NrDaysInitialization-1,1)]/Parameters.Bonds.PricesInitializationScaleFactor;
else
    error('Prices initialization type is undefined')
end
bond.prices(1:Parameters.NrDaysInitialization) = bond.FaceValue*exp(cumsum(Ret_tmp));
if strcmp(Parameters.ClearingMechanism,'LimitOrderBook')
    bond.Book_intraday_transactions = cell(Parameters.NrTotalDays,1);
end

CouponPeriodicityNrMonths = Parameters.Bonds.(id).CouponPeriodicityNrMonths;
bond.CouponsPaymentDays = ...
    (bond.IssueDay+(Parameters.NrDaysInMonth*CouponPeriodicityNrMonths):...
    (Parameters.NrDaysInMonth*CouponPeriodicityNrMonths):bond.MaturityDay)';



