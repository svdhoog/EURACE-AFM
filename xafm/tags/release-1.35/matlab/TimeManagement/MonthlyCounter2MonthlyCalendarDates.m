function[MonthlyCalendarDays, YearlyCalendarDates]=MonthlyCounter2MonthlyCalendarDates(MonthlyCounter)

MonthlyCalendarDays = NaN*ones(numel(MonthlyCounter),1);

Idx1 = find(MonthlyCounter==1);
IdxNot1 = find(MonthlyCounter~=1);

MonthlyCalendarDays(Idx1) = NaN;
MonthlyCalendarDays(IdxNot1) = mod(MonthlyCounter(IdxNot1)-1,12);

MonthlyCalendarDays(find(MonthlyCalendarDays==0))=12;

YearlyCalendarDates = ceil((MonthlyCounter-1)/12);
YearlyCalendarDates(Idx1) = NaN;
