function[C, I, x_hat_Umax, ni_hat_Umax]=...
    household_intertemporal_expected_utility_maximization(household)

global Parameters 

x_hat_grid = Parameters.Households.x_hat_grid;
ni_hat_grid = Parameters.Households.ni_hat_grid;

h = 0;
for x_hat = x_hat_grid
    k = 0;
    h = h + 1;
    for ni_hat = ni_hat_grid
        k = k + 1;
        [U(h,k), C_current(h,k), I_current(h,k)] = ...
            household_intertemporal_expected_utility_single_path(household,x_hat,ni_hat);
    end
end

[Dummy, Idx_ni_hat_Umax] = max(max(U,[],1));
[Dummy, Idx_x_hat_Umax] = max(max(U,[],2));

x_hat_Umax = x_hat_grid(Idx_x_hat_Umax);
ni_hat_Umax = ni_hat_grid(Idx_ni_hat_Umax);

C = C_current(Idx_x_hat_Umax,Idx_ni_hat_Umax);
I = I_current(Idx_x_hat_Umax,Idx_ni_hat_Umax);

% U
% 
% U(Idx_x_hat_Umax,Idx_ni_hat_Umax)


