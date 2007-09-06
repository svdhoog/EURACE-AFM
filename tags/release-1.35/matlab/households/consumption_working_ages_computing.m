function[C, I, TaxDetraction]=consumption_working_ages_computing(ParametersTmp)

global Parameters

x_hat = ParametersTmp.x_hat;
ni_hat = ParametersTmp.ni_hat;

MPC = Parameters.Households.MPC;
mu = ParametersTmp.mu;
wage = ParametersTmp.wage_net;


X = max(0,ParametersTmp.X);
R = ParametersTmp.R;
G = ParametersTmp.G;

wage_expected = G*wage;

I = ni_hat*wage;

TaxDetraction = Parameters.GovernmentPolicy.LaborTaxRate*I;
C_approx = ((-x_hat*wage_expected + wage*R*x_hat + (1-mu)*wage_expected - R*(I-TaxDetraction))/R)+...
    MPC*(X-x_hat*wage);

if (C_approx>0)&(C_approx<=(X-I+TaxDetraction))
    C = C_approx;
else
    if (C_approx<=0)&((X-I+TaxDetraction)>0)  %% negation of the first condition
        C = .01*(X-I+TaxDetraction);
    elseif (C_approx<=0)&((X-I+TaxDetraction)<=0)  %% negation of the first condition
        C = 0;
    elseif (C_approx>(X-I+TaxDetraction))&((X-I+TaxDetraction)>0)
        %% negation of the second condition
        C = 0.99*(X-I+TaxDetraction);
    elseif (C_approx>(X-I+TaxDetraction))&((X-I+TaxDetraction)<=0)
        %% negation of the second condition
        C = 0;
    else
        error('This case for consumption for not contemplated')
    end
end

