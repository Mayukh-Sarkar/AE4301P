FindF16Dynamics
close all

%% Model reduction
A_reduced = A_lo([3,7,8,5,11],[3,7,8,5,11]);
B_reduced = A_lo([3,7,8,5,11], [13,14]);
C_reduced = C_lo([3,7,8,5,11],[3,7,8,5,11]);
%C_reduced = eye(5);
D_reduced = D_lo([3,7,8,5,11], [1,2]);

disp(A_reduced)
disp(B_reduced)
disp(C_reduced)
disp(D_reduced)

disp("Trim thrust (lbs): ")
disp(trim_thrust_lo)
disp("Trim elevator deflection (deg): ")
disp(trim_control_lo(1))

model_trimmed = ss(A_reduced, B_reduced, C_reduced, D_reduced);

sim('Glide_flare_alt',300);
results = ans;

%Plotting results----------------------------------------------------------
%Glideslope and pitch
figure(1)
plot(results.GS);
hold on
plot(results.pitch);
title('Glide and pitch angle')
xlabel('Time [s]')
ylabel('Angle [deg]')
legend('Glide angle','Pitch angle')

%Airspeed
figure(2)
plot(results.V);
title('Airspeed')
xlabel('Time [s]')
ylabel('Airspeed [ft/s]')
legend('Airspeed')

%Altitude
figure(3)
plot(results.h);
title('Altitude over airfield')
xlabel('Time [s]')
ylabel('Altitude [ft]')
legend('Altitude')

%Vertical speed
figure(4)
plot(results.hdot);
title('Vertical speed')
xlabel('Time [s]')
ylabel('Vertical speed [ft/s]')
legend('Vertical speed')


disp("Done")
cost   = 4.7464e-30;
thrust = 2826.8165 ;
elev   = -4.1891;
ail    = -1.9926e-15;
rud    = 1.2406e-14 ;
alpha  = 10.4511;
dLEF   = 0;
Vel   = 300;
