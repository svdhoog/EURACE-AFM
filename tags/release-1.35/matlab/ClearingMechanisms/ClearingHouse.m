function[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit)

% Description: 
% [Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit)
% computes the clearing price and transactions according to the clearing house mechanims 
% given an array of buy limit orders and sell limit orders
%  
% Input arguments:
% QB: int array of buy orders' quantities  
% PBLimit: double array of buy orders' limit prices
% QS: int array of sell orders' quantities
% PSLimit: double array of sell orders' limit prices
%
% Output arguments:
% Pcross: double scalar related clearing price  
% Qcross: int scalar related to the amount of transactions at the clearing price
% Qrationed: int scalar related to the disequilibrium between demand and supply at the clearing price
%
% Version 1.0 of June 2007
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it) and Andrea Teglio (teglio@dibe.unige.it)

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

if ~isnan(P_curve)

    Qtrans = min(QB_curve,QS_curve);

    [Qcross, Dummy]=max(Qtrans);
    Idx_tmp1 = find(Qtrans==Qcross);
    Qrat = QB_curve(Idx_tmp1)-QS_curve(Idx_tmp1);
    [Dummy, Idx_tmp2]=min(abs(Qrat));
    Idx = Idx_tmp1(Idx_tmp2);

    Pcross = P_curve(Idx);
    Qrationed = QB_curve(Idx)-QS_curve(Idx);

elseif isnan(P_curve)
    Pcross = NaN;
    Qcross = NaN;
    Qrationed = NaN;
    
else error('The value of the flag trading is not recognized')
end
    
    

