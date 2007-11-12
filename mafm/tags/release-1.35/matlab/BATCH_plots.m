%SCRIPT BATCH_plots
%Script to cycle over multiple simulation runs.
%Plotting occurs by calling BATCH_AFM_plots.
%
% 6 September 2007, Sander van der Hoog, (svdhoog@gmail.com)


rho=1;delta=1;phi=0;beta=5.0;
NrTotalDays=30;
TOTNR_RUNS=5;

for run_nr=1:TOTNR_RUNS
    fprintf('Loading random seed: %d\n', run_nr);
    directory=sprintf('./ewa/[rho=%d,delta=%d,phi=%d]/run%d',rho,delta,phi, run_nr);

    fprintf('Entering into: %s\n', directory);
    cd(directory);

    %CODE: for loading a file for a certain random seed
    filename = sprintf('./AFM_t%d_rnd%d.mat', NrTotalDays, run_nr);

    fprintf('Loading: %s\n', filename);
    load(filename);

%Checking that we are in the local directory:
%    fprintf('Currently in:'); pwd
%    fprintf('Directory variable: %s\n', directory);

    fprintf('Plotting\n');
    run('../../../BATCH_AFM_plots');

    fprintf('Exiting from: %s\n', directory);
    cd('../../../');
end; 