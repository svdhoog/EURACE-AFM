%%SCRIPT: timerclock.m
%25 August 2007, Sander van der Hoog (svdhoog@gmail.com)

%%NrDaysFwd = Parameters.NrTotalDays-LoadingDay;
LoadingDay = Parameters.NrTotalDays-NrDaysFwd;

%At current period t:
total= Parameters.NrTotalDays;
done = t-LoadingDay;
todo= Parameters.NrTotalDays-LoadingDay; %=total-done;
counter=done/todo;

filename=sprintf('../log/matlab-3.log');
SIMLOGFILE = fopen(filename,'a');

   past  = etime(clock,timestart);
   hours = floor(past/3600);
   min   = floor((past-hours*3600)/60);
   sec   = floor(past-hours*3600-min*60);
   string_done=sprintf('%s Done: [%.2f][%d/%d][%d/%d] [%02d:%02d:%02d]', DATESTR(NOW), counter, done,todo, t,total,hours,min,sec);
   fprintf(SIMLOGFILE,'%s ',string_done);
   
   estimate = past/counter - past;
   hours = floor(estimate/3600);
   min   = floor((estimate-hours*3600)/60);
   sec   = floor(estimate-hours*3600-min*60);
   string_remaining=sprintf('\t Remaining: [%02d:%02d:%02d]', hours,min,sec);
   fprintf(SIMLOGFILE,'%s',string_remaining);

   estimate_total = past/counter;
   hours = floor(estimate_total/3600);
   min   = floor((estimate_total-hours*3600)/60);
   sec   = floor(estimate_total-hours*3600-min*60);
   string_total=sprintf('\t Est. Total: [%02d:%02d:%02d]', hours,min,sec);
   fprintf(SIMLOGFILE,'%s\n',string_total);

%Print to prompt:
%  string = strcat(string_done,string_remaining,string_total);
%  disp(string); 

fclose(SIMLOGFILE);
