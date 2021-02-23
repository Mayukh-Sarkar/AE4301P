FindF16Dynamics
close all

%----Display 19th row of C and D matrices to find expression of a_n--------
disp(C_lo(19,:));
disp(D_lo(19,:));

%Transfer functions for plotting of different x_a--------------------------
sys = tf(SS_lo);
num = sys.Numerator(19,2); %Extract correct numerator from sys object
den = sys.Denominator(19,2); %Extract correct denominator from sys object
x_a0ft = minreal(tf(num,den));

num = sys.Numerator(20,2); %Extract correct numerator from sys object
den = sys.Denominator(20,2); %Extract correct denominator from sys object
x_a5ft = minreal(tf(num,den));

num = sys.Numerator(21,2); %Extract correct numerator from sys object
den = sys.Denominator(21,2); %Extract correct denominator from sys object
x_a59ft = minreal(tf(num,den));

num = sys.Numerator(22,2); %Extract correct numerator from sys object
den = sys.Denominator(22,2); %Extract correct denominator from sys object
x_a6ft = minreal(tf(num,den));

num = sys.Numerator(23,2); %Extract correct numerator from sys object
den = sys.Denominator(23,2); %Extract correct denominator from sys object
x_a7ft = minreal(tf(num,den));

num = sys.Numerator(24,2); %Extract correct numerator from sys object
den = sys.Denominator(24,2); %Extract correct denominator from sys object
x_a15ft = minreal(tf(num,den));

disp("Transfer function a_n/d_e for x_a = 0");
disp(x_a0ft); %Display transfer function for 0ft x_a

opt = stepDataOptions('StepAmplitude',-1); %Set step options to -1 step input

%-----x_a = 0 short and long plot------------------------------------------
figure(1)
t = 0:0.01:5; %Long
step(x_a0ft, t, opt);
title('Negative step response (5s)')
xlabel('Time [s]')
ylabel('Normal acceleration a_{n} [ft/s^{2}]')

figure(2)
t = 0:0.01:1000; %Long
step(x_a0ft, t, opt);
title('Negative step response (1000s)')
xlabel('Time [s]')
ylabel('Normal acceleration a_{n} [ft/s^{2}]')

%----Plots for different x_a-----------------------------------------------
figure(3)
t = 0:0.001:5; %5 second plot
step(x_a0ft,x_a5ft, x_a59ft, x_a6ft, x_a7ft, x_a15ft, t,opt);
title('Negative step response (5s)')
xlabel('Time [s]')
ylabel('Normal acceleration a_{n} [ft/s^{2}]')
legend('x_a = 0 ft','x_a = 5 ft','x_a = 5.9 ft','x_a = 6 ft','x_a = 7 ft','x_a = 15 ft')

figure(4)
t = 0:0.001:1; %1 second plot
step(x_a0ft,x_a5ft, x_a59ft, x_a6ft, x_a7ft, x_a15ft, t,opt);
title('Negative step response (1s)')
xlabel('Time [s]')
ylabel('Normal acceleration a_{n} [ft/s^{2}]')
legend('x_a = 0 ft','x_a = 5 ft','x_a = 5.9 ft','x_a = 6 ft','x_a = 7 ft','x_a = 15 ft')

%----Extracting zeros------------------------------------------------------
disp("0 ft");
disp(zero(x_a0ft));
disp("5 ft");
disp(zero(x_a5ft));
disp("5.9 ft");
disp(zero(x_a59ft));
disp("6 ft");
disp(zero(x_a6ft));
disp("7 ft");
disp(zero(x_a7ft));
disp("15 ft");
disp(zero(x_a15ft));








