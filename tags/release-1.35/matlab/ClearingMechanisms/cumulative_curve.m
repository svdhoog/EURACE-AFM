function[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit)

% Description: 
% [P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit)
% return the cumulative demand and supply curves given an array of buy limit orders and sell limit orders
%  
% Input arguments:
% QB: int array of buy orders' quantities  
% PBLimit: double array of buy orders' limit prices
% QS: int array of sell orders' quantities
% PSLimit: double array of sell orders' limit prices
%
% Output arguments:
% P_curve: double array related to the price grid where QB_curve and QS_curve are determined   
% QB_curve: int array related to cumulative demand curve
% QS_curve: int array related to cumulative supply curve
%
% Version 1.0 of June 2007
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it) and Andrea Teglio (teglio@dibe.unige.it)


if isnan(QB)
    warning('There is no stock demand')
    P_curve = NaN;
    QB_curve = NaN;
    QS_curve = NaN;
    return
elseif isnan(QS)
    warning('There is no stock supply')
    P_curve = NaN;
    QB_curve = NaN;
    QS_curve = NaN;
    return
end

if max(PBLimit)<min(PSLimit)
    warning('The max buy limit price is lower than the min sell limit price')
    P_curve = NaN;
    QB_curve = NaN;
    QS_curve = NaN;
    return
end


if length(QB)~=length(PBLimit)
    error('Vector lengths of buying quantities and limit prices are different')
end

if length(QS)~=length(PSLimit)
    error('Vector lengths of selling quantities and limit prices are different')
end

if ~isempty(find(PBLimit<0))
    error('One or more buy limit prices are negative')
end

if ~isempty(find(PSLimit<0))
    error('One or more sell limit prices are negative')
end


PLimit = union(PBLimit,PSLimit);

P_curve = unique([PLimit, 0, inf]);
P_curve_size = length(P_curve);

QB_curve=zeros(P_curve_size,1);

for n=1:P_curve_size
    PLim_tmp = P_curve(n);
    Idx_tmp = find(PBLimit>=PLim_tmp);
    QB_curve(n) = sum(QB(Idx_tmp));
    clear Idx_tmp PLim_tmp
end

QS_curve=zeros(P_curve_size,1);

for m=1:P_curve_size
    PLim_tmp = P_curve(m);
    Idx_tmp = find(PSLimit<=PLim_tmp);
    QS_curve(m) = sum(QS(Idx_tmp));
    clear Idx_tmp PLim_tmp
end


    

