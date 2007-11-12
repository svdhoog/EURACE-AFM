%%SCRIPT: timerend.m
%25 August 2007, Sander van der Hoog (svdhoog@gmail.com)

past  = etime(clock,timestart);

filename=sprintf('../log/matlab-3.log');
SIMLOGFILE = fopen(filename,'a');

fprintf(SIMLOGFILE,'Simulation finished on %s\n', DATESTR(NOW));
fprintf(SIMLOGFILE,'Simulation time: %12.f\n', past);
fprintf(SIMLOGFILE,'===========================================================================================================\n');

fclose(SIMLOGFILE);
