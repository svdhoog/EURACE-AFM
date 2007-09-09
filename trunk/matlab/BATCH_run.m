%%SCRIPT to loop over all special cases of EWA learning
%This runs 8 simulations in batch mode.
%
%% 6 September 2007, Sander van der Hoog, (svdhoog@gmail.com)

global BATCHMODE TOTNR_RUNS;
BATCHMODE=1;    %Turn batch mode on/off;


%%% Households learning parameters set in : ./households/DBHouseholds_initialization.m %%%
%Default:
rho=1;delta=1;phi=0;beta=5.0;
TOTNR_RUNS =2; %Nr. of run (for examplem random seeds to test)

%for rho=0:1:1
%    for delta=0:1:1
%        for phi=0:1:1
        
        for run_nr=1:TOTNR_RUNS
            Parameters.Households.EWA_learning.rho=rho;
            Parameters.Households.EWA_learning.delta=delta;
            Parameters.Households.EWA_learning.phi=phi;
            Parameters.Households.EWA_learning.beta=beta;

%            randn('state',1234567);        %uses Matlab 5 RNG, fixed random seed,   normally distributed
%            randn('state',sum(100*clock)); %uses Matlab 5 RNG, varying random seed, normally distributed
%            rand('state',1234567);         %uses Matlab 5 RNG, fixed random seed,   uniformly distributed
             rand('state',sum(100*clock));  %uses Matlab 5 RNG, varying random seed, uniformly distributed

            AFM_initialization;
            AFM_simulation;

            %Creating directory to store output
            directory=sprintf('./ewa/[rho=%d,delta=%d,phi=%d]/run%d',rho,delta,phi, run_nr);
            status = mkdir('',directory);
            plot_EWA_rules;
            
            %Saving database to output directory
            fprintf('\r\r Final saving\r')
            filename = sprintf('%s/AFM_t%s_rnd%d.mat', directory, num2str(Parameters.current_day), run_nr);
            save(filename);

         end   
            
%        end;
%    end;
%end;
