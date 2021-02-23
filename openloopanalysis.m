close all;
clear;
altitude = 20000;
velocity = 600;
x_a=0;

FindF16Dynamics;

%% LONGITUDINAL MODES

A_lon = A_longitude_lo([3 4 2 5],[3 4 2 5]);
B_lon = A_longitude_lo([3 4 2 5],[6, 7]);
C_lon = eye(4);
%C_lon = C_longitude_lo([2,3,4,5],[2,3,4,5]);
D_lon = D_lo([1,2,3,4],[1,2]);

A_1 =  eig(A_lon); % gives eigen vales for the longitudinal mode

%% LATERAL MODES



A_lat = A_lateral_lo([4 1 5 6 ],[4 1 5 6]);
B_lat = A_lateral_lo([4 3 5 6],[8 9]);
C_lat = eye(4);
%C_lat = C_lateral_lo([1,4,5,6],[1,4,5,6]);
D_lat = D_lo([1,2,3,4],[1,2]);


A_2 = eig(A_lat); %gives eigen values for the lateral mode

SS_lon=ss(A_lon,B_lon,C_lon,D_lon);
SS_lat=ss(A_lat,B_lat,C_lat,D_lat);


%%Eigen Motion Identification
%% Phugoid   has a lower natural frequency
w_n_p = abs(A_1(3));  %natural frequecny
zeta_p = - real(A_1(3))/w_n_p ; % damping coefficient zeta
P_p = 2*pi/imag(A_1(3));   % period P
T_p = log(0.5)/real(A_1(3)); %time period for half amplitude



t_p=0:0.1:1000;
u_p=zeros(2,length(t_p));
for i=1:2:20
    u_p(i)=deg2rad(2);
end 
for i=22:2:40
    u_p(i)=-deg2rad(2);
end 
phu=lsim(SS_lon,u_p,t_p);


figure
title('Phugoid')
subplot(4,1,1)
plot(t_p,phu(:,1))
xlabel("Time[s]")
ylabel('V[ft/s]')
title('Velocity')
subplot(4,1,4)
plot(t_p,rad2deg(phu(:,4)))
xlabel("Time[s]")
ylabel('q [deg/s]')
title('Pitch rate')
subplot(4,1,2)
plot(t_p,rad2deg(phu(:,2)))
xlabel("Time[s]")
ylabel('\alpha [deg]')
title('AoA')
subplot(4,1,3)
plot(t_p,rad2deg(phu(:,3)))
xlabel("Time[s]")
ylabel("\theta [deg]")
title('Pitch angle')




%% short period  has a higer natural frequency
w_n_s = abs(A_1(1));  %natural frequecny
zeta_s = - real(A_1(1))/w_n_s ; % damping coefficient zeta
P_s= 2*pi/imag(A_1(1));   % period P
T_s = log(0.5)/real(A_1(1)); %time period for half amplitude

t_s=0:0.1:600;
u_s=ones(2,length(t_s))*deg2rad(2);
for i=1:2:20
    u_s(i)=deg2rad(2);
end 
for i=22:2:40
    u_s(i)=-deg2rad(2);
end 

short=lsim(SS_lon,u_s,t_s);


figure
title('short period')
subplot(4,1,1)
plot(t_s,short(:,1))
xlabel("Time[s]")
ylabel('V[ft/s]')
title('Velocity')
subplot(4,1,2)
plot(t_s,rad2deg(short(:,2)))
xlabel("Time[s]")
ylabel('\alpha [deg]')
title('AoA')
subplot(4,1,3)
plot(t_s,rad2deg(short(:,3)))
xlabel("Time[s]")
ylabel("\theta [deg]")
title('Pitch angle')
subplot(4,1,4)
plot(t_s,rad2deg(short(:,4)))
xlabel("Time[s]")
ylabel('q [deg/s]')
title('Pitch rate')

%% Dutch roll  lateral mode
w_n_d = abs(A_2(1));  %natural frequecny
zeta_d = - real(A_2(1))/w_n_p ; % damping coefficient zeta
P_d = 2*pi/imag(A_2(1));   % period P
T_d = log(0.5)/real(A_2(1)); %time period for half amplitude

t_d=0:0.1:25;
u_d=zeros(2,length(t_d));
for i=2:2:20
    u_d(i)=deg2rad(5);
end 
for i=22:2:40
    u_d(i)=-deg2rad(5);
end 
d_roll=lsim(SS_lat,u_d,t_d);


figure()
title('dutch roll')
subplot(4,1,1)
plot(t_d,rad2deg(d_roll(:,1)))
xlabel("Time[s]")
ylabel('\beta [deg]')
title('Sideslip angle')
subplot(4,1,2)
plot(t_d,rad2deg(d_roll(:,2)))
xlabel("Time[s]")
ylabel('\phi[deg]')
title('Roll angle')
subplot(4,1,3)
plot(t_d,rad2deg(d_roll(:,3)))
xlabel("Time[s]")
ylabel("p [deg/s]")
title('Roll rate')
subplot(4,1,4)
plot(t_d,rad2deg(d_roll(:,4)))
xlabel("Time[s]")
ylabel('r [deg/s]')
title('Yaw rate')

%% Aperiodic Roll lateral mode
w_n_a = abs(A_2(3));  %natural frequecny
T_ap_a = - 1/real(A_2(3)) ; % notion fro aperiod roll
T_a = log(0.5)/real(A_2(3)); %time period for half amplitude

t_ap=0:0.1:100;
u_ap=zeros(2,length(t_ap));
for i=1:2:length(t_ap)*2
    u_ap(i)=deg2rad(2);
end
aproll=lsim(SS_lat,u_ap,t_ap);


figure()
title('Aperiodic')
subplot(4,1,1)
plot(t_ap,rad2deg(aproll(:,1)))
xlabel("Time[s]")
ylabel('\beta [deg]')
title('Sideslip angle')
subplot(4,1,2)
plot(t_ap,rad2deg(aproll(:,2)))
xlabel("Time[s]")
ylabel('\phi[deg]')
title('Roll angle')
subplot(4,1,3)
plot(t_ap,rad2deg(aproll(:,3)))
xlabel("Time[s]")
ylabel("p [deg/s]")
title('Roll rate')
subplot(4,1,4)
plot(t_ap,rad2deg(aproll(:,4)))
xlabel("Time[s]")
ylabel('r [deg/s]')
title('Yaw rate')

%% Spiral stability lateral mode

w_n_ss = abs(A_2(4));  %natural frequecny
T_ss_s= - 1/real(A_2(4)) ; % damping coefficient zeta

T_ss = log(0.5)/real(A_2(4)); %time period for half amplitude

t_sp=0:0.1:100;
u_sp=zeros(2,length(t_sp));
spiral_stability=lsim(SS_lat,u_sp,t_sp, [0;deg2rad(-50);0;0]);

figure()
title('spiral')
subplot(4,1,1)
plot(t_sp,rad2deg(spiral_stability(:,1)))
xlabel("Time[s]")
ylabel('\beta [deg]')
title('Sideslip angle')
subplot(4,1,2)
plot(t_sp,rad2deg(spiral_stability(:,2)))
xlabel("Time[s]")
ylabel('\phi[deg]')
title('Roll angle')
subplot(4,1,3)
plot(t_sp,rad2deg(spiral_stability(:,3)))
xlabel("Time[s]")
ylabel("p [deg/s]")
title('Roll rate')
subplot(4,1,4)
plot(t_sp,rad2deg(spiral_stability(:,4)))
xlabel("Time[s]")
ylabel('r [deg/s]')
title('Yaw rate')























