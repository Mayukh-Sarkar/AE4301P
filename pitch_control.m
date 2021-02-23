FindF16Dynamics;


%% Longitudinal modes
A_lon = A_longitude_lo([3 4 2 5],[3 4 2 5]);
B_lon = A_longitude_lo([3 4 2 5],[6 7]);
B_lon=B_lon([1,2,3,4],[2]);
C_lon=eye(4);
D_lon = D_lo([1,2,3,4],[1]);

%construct the matrices for the state space matrix

SS_sym_4=ss(A_lon,B_lon,C_lon,D_lon);
%% short period state space
A_sp=A_lon([2,4],[2,4]);
B_sp=B_lon([2,4],[1]);
C_sp=C_lon([2,4],[2,4]);
D_sp=D_lon([1 2]);


SS_2=ss(A_sp,B_sp,C_sp,D_sp);

t_shortperiod1=0:0.1:10;
t_shortperiod2=0:0.1:200;
sp_4_s=step(-SS_sym_4,t_shortperiod1);
sp_2_s=step(-SS_2,t_shortperiod1);
sp_4_l=step(-SS_sym_4,t_shortperiod2);
sp_2_l=step(-SS_2,t_shortperiod2);

figure
plot(t_shortperiod1,rad2deg(sp_4_s(:,4)));
hold 
plot(t_shortperiod1,rad2deg(sp_2_s(:,2)))
ylabel('pitch rate q[deg/s]')
xlabel('Time[s]')
legend('4 state model','2 state model')

figure
plot(t_shortperiod2,rad2deg(sp_4_l(:,4)))
hold 
plot(t_shortperiod2,rad2deg(sp_2_l(:,2)))
ylabel('pitch rate q[deg/s]')
xlabel('Time[s]')
legend('4 state model','2 state model')



%% parameters
w_n_sp = 1.5454; % from the 4th order model
zeta_n_sp = 0.4991; %from the fourth order model
V = 600*0.3048;
w_n_sp_r = 0.03*V;
zeta_n_sp_r = 0.5;
T_c = inv(0.75*w_n_sp_r);
T_old = inv(0.75*w_n_sp);
v_gust = 4.572; %gust velocity m/s
pole1 = -w_n_sp_r*zeta_n_sp_r + sqrt(zeta_n_sp_r^2-1)*w_n_sp_r;
pole2 = -w_n_sp_r*zeta_n_sp_r - sqrt(zeta_n_sp_r^2-1)*w_n_sp_r;
K = place(A_sp, B_sp, [pole1,pole2]);
K_a = K(1); % GAIN AOA
K_q = K(2); % gain for pitch
alpha_induced = atan(v_gust/V);
elevat_def_induced = K_a*alpha_induced ;

%% CAP and Gibson criteria

CAP_old = w_n_sp_r^2*T_old*9.81/V;
CAP_new = w_n_sp_r^2*T_c*9.81/V;

gibson_old = T_old - 2*zeta_n_sp/w_n_sp_r;
gibson_new = T_c - 2*zeta_n_sp_r/w_n_sp_r;
%% lead lag filter , ptich to elevator deflection
 num_e = [ T_c 1];
 den_e = [T_old 1];
 G_s = tf(num_e , den_e); %lead lag filter
 b = (2*w_n_sp_r*zeta_n_sp_r);
 c = w_n_sp_r^2;
 num_q = [0 T_old*K_q , K_q];
 den_q = [1 b c];
 H_s  = tf(num_q ,den_q);
 num_q_1 = [0 T_old 1];
 H_s_1 = tf(num_q_1,den_q);
 %% verification of CAP and Gibson
tf_new = G_s*H_s;
tf_new=minreal(zpk(tf_new));
tf_pitchangle=tf_new*tf([1],[1 0]);

time = 20;
opt = stepDataOptions('StepAmplitude',-1);
figure;
[y,t]=step(tf_new,opt,time);
plot(t,y);
xlabel('Time (s)');
ylabel('Pitch rate (deg/s)')
title('Pitch Rate time response');

figure;
[y,t]=step(tf_pitchangle,opt,time);
plot(t,y);
xlabel('Time (s)');
ylabel('Pitch angle (deg)')
title('Pitch angle time response');

figure
trg_x = [0 0.3 0.06 0];
trg_y = [1 1 3 3];
patch(trg_x,trg_y,[0 1 0],'FaceAlpha',.4);hold on;
scatter(gibson_new,1.24,'filled','r');
grid on
xlim([0,0.0608])
ylim([1,4])
xlabel('DB/q_{s} [s]')
ylabel('q_{m}/q_{s} [-]')
