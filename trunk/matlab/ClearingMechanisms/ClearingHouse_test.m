

% Version 1.0 of June 2007
% For any comments, please contact Marco Raberto (raberto@dibe.unige.it) and Andrea Teglio (teglio@dibe.unige.it)

clc
clear all
close all

font_sz = 12;

%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 1

QB = [3 2 4 1];
PBLimit = [1 2 3 1];

QS = [3 1 4 1];
PSLimit = [1 1 3 1];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 2

QB = [3 2 4 1];
PBLimit = [1 2 0 1];

QS = [3 1 4 1 1];
PSLimit = [1 1 3 1 0];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 3

QB = [3 2 4 1];
PBLimit = [1.5 2 0 1.5];

QS = [3 1 4 2 1];
PSLimit = [1 1 3 1 0];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 4

QB = [3 2 4 3];
PBLimit = [1.5 2 0 1.5];

QS = [3 1 4 2 1];
PSLimit = [1 1 3 1 0];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 5

QB = [3 2 4 1];
PBLimit = [1 2 3 1];

QS = [3 1 4 1 2];
PSLimit = [1 1 3 1 2];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test n. 6

QB = [3 2 4 1];
PBLimit = [1 2 3 1];

QS = [3 1 4 1 7];
PSLimit = [1 1 3 1 2];

[P_curve, QB_curve, QS_curve] = cumulative_curve(QB, PBLimit, QS, PSLimit);

figure; hold on; grid on; 
plot(P_curve,QB_curve,'xr','linewidth',2)
plot(P_curve,QS_curve,'ob','linewidth',2)
xlabel('prices','fontsize',font_sz); ylabel('quantities','fontsize',font_sz)

[Pcross, Qcross, Qrationed]=ClearingHouse(QB, PBLimit, QS, PSLimit);

fprintf('\r Pcross: %f \t Qcross: %d \t Qrationed: %d',[Pcross, Qcross, Qrationed])
plot(Pcross,Qcross,'ks','markersize',12)
legend('demand','supply','transaction')



