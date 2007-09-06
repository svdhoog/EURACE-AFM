%%SCRIPT: timerstart.m
%Script to time the execution of a simulation run
%25 August 2007, Sander van der Hoog (svdhoog@gmail.com)

timestart=clock;

%filename=sprintf('../log/matlab-%02d%02d%4d-%02d%02d%02.f.log',timestart(2),timestart(3),timestart(1),timestart(4),timestart(5),timestart(6));
filename=sprintf('../log/matlab.log');
SIMLOGFILE = fopen(filename,'a');

fprintf(SIMLOGFILE,'\n===========================================================================================================\n');
fprintf(SIMLOGFILE,'Simulation started on %s\n', DATESTR(NOW));

fclose(SIMLOGFILE);
