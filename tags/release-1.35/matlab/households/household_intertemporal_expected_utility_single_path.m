function [U, C_current, I_current] = ...
    household_intertemporal_expected_utility_single_path(household,x_hat,ni_hat)

global Parameters wage PensionFundManager colore

m = Parameters.current_month;
t = Parameters.current_day;

mu = Parameters.Households.UnemploymentProbability;       % probability of zero income
rho = Parameters.Households.RelativeRiskAversion;     
delta = Parameters.Households.DiscountFactor; 
beta = Parameters.Households.TimeInconsistencyFactor;   

tr = Parameters.GovernmentPolicy.LaborTaxRate;

T = Parameters.Households.age_max;  % number of periods
age = household.age;

R = max(1.04,1+yearly_average_cash_flow_yield_estimate);
G = exp(12*Parameters.MonthlyWageGrowthRate);

if G<((R*delta)*(1-mu))^(1/rho) % impatience condition
    warning('the impatience condition is not verified')
end

w = zeros(T,1);
X = zeros(T,1);
C = zeros(T,1);
I = zeros(T,1);
Taxes = zeros(T,1);
Z = zeros(T,1);
Wealth = zeros(T,1);
u = zeros(T,1);

Wealth(age-1) = household.liquid_assets_wealth(t-1)+household.portfolio.bank_account(t-1);
Z(age-1) = household.pension_fund_quotes(m-1)*PensionFundManager.quote_value(m-1);
if isnan(Z(age-1))
    Z(age-1) = 0;
end

for h=age:T
    %%% Wage expected dynamics
    if h<Parameters.Households.RetirementAge  %% working ages
        w(h) = (1-tr)*(G^(h-age))*12*wage(m); %% yearly net wage
        X(h) = R*Wealth(h-1)+(1-mu)*w(h);     %% yearly cash on hands
    
        %%% Expected cash on hands
        ParametersTmp.X = X(h);
        ParametersTmp.x_hat = x_hat;
        ParametersTmp.ni_hat = ni_hat;
        ParametersTmp.mu = mu;
        ParametersTmp.wage_net = w(h);
        ParametersTmp.G = G;
        ParametersTmp.R = R;
 
        ParametersTmp.MPC = Parameters.Households.MPC;

        [C(h), I(h), TaxDetraction(h)] = consumption_working_ages_computing(ParametersTmp);
        clear ParametersTmp
        
        Wealth(h) = R*Wealth(h-1)+(1-mu)*w(h)-C(h)-I(h)+TaxDetraction(h); % end of period wealth

        Z(h) = R*Z(h-1) + I(h);

    elseif h>=Parameters.Households.RetirementAge  %% retirement ages

        Z_Montante = Z(Parameters.Households.RetirementAge-1);  
        w_last = w(Parameters.Households.RetirementAge-1);
        
        %% yearly private pension
        PrivatePension(h) = Parameters.PensionFundManager.PaymentRate*Z_Montante;

        %% yearly public pension
        PublicPension(h) = ...
            Parameters.GovernmentPolicy.LastWagePublicPensionSubstitutionRate*w_last;
 
        I(h) = 0;
        C(h) = (1-tr)*(PrivatePension(h)+PublicPension(h)) + Wealth(h-1)/(T-h+1);
        Wealth(h) = R*Wealth(h-1)+(1-tr)*(PrivatePension(h)+PublicPension(h))...
            -C(h);

    end
    
    if rho ~=1
        u(h) = (C(h)^(1-rho))/(1-rho);
    elseif rho==1
        u(h) = log(C(h));
    end

end

C_current = C(age);
I_current = I(age);

if age < T
    discount_vector = delta.^(1:(T-age));
    U = u(age)+beta*sum(discount_vector'.*u((age+1):T)); % intertemporal utility
else
    U = u(age);
end

if Parameters.graphics.household_intertemporal_expected_utility_graphics ==1

    figure(1)
    subplot(2,2,1);
    hold on; grid on; box on
    plot(age:T,C(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('C (consumption)','fontsize',14)

    subplot(2,2,2);
    hold on; grid on; box on
    plot(age:T,X(age:T),colore)
    plot(age:T,w(age:T),[':', colore],'linewidth',2)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('X (cash on hand)','fontsize',14)

    subplot(2,2,3);
    hold on; grid on; box on
    plot(age:T,u(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('u (instantaneous utility)','fontsize',14)

    subplot(2,2,4);
    hold on; grid on; box on
    plot(age:T,Wealth(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('W (Wealth)','fontsize',14)

    figure(2)
    subplot(2,2,1);
    hold on; grid on; box on
    plot(age:Parameters.Households.RetirementAge-1,...
        X(age:Parameters.Households.RetirementAge-1)./w(age:Parameters.Households.RetirementAge-1),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('x','fontsize',14)

    subplot(2,2,2);
    hold on; grid on; box on
    plot(age:T,I(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('I','fontsize',14)

    subplot(2,2,3);
    hold on; grid on; box on
    plot(age:T,PrivatePension(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('Private Pension','fontsize',14)

    subplot(2,2,4);
    hold on; grid on; box on
    plot(age:T,PublicPension(age:T)+PrivatePension(age:T),colore)
    set(gca,'xtick',[age:10:T])
    set(gca,'xlim',[age, T])
    xlabel('age','fontsize',14)
    ylabel('Private + Public Pension','fontsize',14)

end