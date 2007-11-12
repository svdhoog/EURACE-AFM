function[QB, PBLimit, QS, PSLimit]=DBFinancialMarketParticipants_OrdersCollecting(AssetId)

global Parameters DBFinancialMarketParticipants

t = Parameters.current_day;

QB = NaN;
QS = NaN;
PBLimit = NaN;
PSLimit = NaN;

FinancialMarketParticipantsIDs = fieldnames(DBFinancialMarketParticipants);

iB = 0;  iS = 0;

for h=1:numel(FinancialMarketParticipantsIDs)
    id = FinancialMarketParticipantsIDs{h,1};
    FinancialMarketParticipant = DBFinancialMarketParticipants.(id);
    if FinancialMarketParticipant.trading_activity(t)==1
        if ~isnan(FinancialMarketParticipant.pending_orders.(AssetId).pLimit)
            p = FinancialMarketParticipant.pending_orders.(AssetId).pLimit;
            q = FinancialMarketParticipant.pending_orders.(AssetId).q;
            if q>0
                iB=iB+1;
                QB(iB)=q;
                PBLimit(iB)=p;
            elseif q<0
                iS=iS+1;
                QS(iS)=abs(q);
                PSLimit(iS)=p;
            end
        end
    elseif FinancialMarketParticipant.trading_activity(t)~=1
        error('The FinancialMarketParticipant is not active in the financial market')
    end
    clear tmp id FinancialMarketParticipant p q
end


