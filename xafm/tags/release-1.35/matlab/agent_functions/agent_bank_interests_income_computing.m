function[interest]=agent_bank_interests_income_computing(agent)

global Parameters

t = Parameters.current_day;

NrDays = Parameters.BankInterestsPeriodicityNrMonths*Parameters.NrDaysInMonth;

interest = 0;
for j=1:NrDays
    interest_tmp = (1/Parameters.NrDaysInYear)*agent.portfolio.bank_account(t-j)*...
        Parameters.CentralBankPolicy.RiskFreeRate;
    interest = interest + interest_tmp;
    clear interest_tmp
end
    
