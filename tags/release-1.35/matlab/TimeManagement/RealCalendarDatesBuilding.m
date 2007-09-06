function[CalendarDates]=RealCalendarDatesBiulding(MonthlyCalendarDates,YearlyCalendarDates)


NrDates = numel(MonthlyCalendarDates);

CalendarDates = NaN*ones(NrDates,1);

for d=1:NrDates
    if ~isnan(MonthlyCalendarDates(d))
        CalendarDates(d) = datenum(1999+YearlyCalendarDates(d),MonthlyCalendarDates(d),1);
    else
        CalendarDates(d) = NaN;
    end
end
    