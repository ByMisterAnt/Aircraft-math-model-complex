function [XDOT] = sodel_6dof(X,U)

%1   vector state and control
%state vector
x1 = X(1); %u
x2 = X(2); %v
x3 = X(3); %w
x4 = X(4); %p
x5 = X(5); %q
x6 = X(6); %r
x7 = X(7); %phi
x8 = X(8); %theta
x9 = X(9); %psi

%control vector
u1 = U(1); %d_A aileron
u2 = U(2); %d_T elevator
u3 = U(3); %d_R rudder
u4 = U(4); %d_th1 throttle 1
u5 = U(5); %d_th2 throttle 2

%2 parameters/constants
m = 120000; %total mass

cbar = 6.6;             %aerodynamc chord (m)
lt = 24.8;              %dist by aircrafts tail and body (m)
S = 260;                %wing platform area (m^2)
St = 64;                %tail platform area (m^2)

Xcg = 0.23*cbar;        %x position of center of gravity in Fm (m)
Ycg = 0;                %y position of center of gravity in Fm (m)
Zcg = 0.10*cbar;         %z position of center of gravity in Fm (m)

Xac = 0.12*cbar;        %x position of aerodyn center in Fm (m)
Yac = 0;                %y position of aerodyn center in Fm (m)
Zac = 0;                %z position of aerodyn center in Fm (m)

%engine constants
Xapt1 = 0;              %x position of engine 1 force in Fm (m)
Yapt1 = -7.94;          %y position of engine 1 force in Fm (m)
Zapt1 = -1.9;           %z position of engine 1 force in Fm (m)

Xapt2 = 0;              %x position of engine 2 force in Fm (m)
Yapt2 = 7.94;           %y position of engine 2 force in Fm (m)
Zapt2 = -1.9;           %z position of engine 2 force in Fm (m)

%other
rho = 1.225;            %air dencity (kg/m^3)
g = 9.81;               %gravity
depsda = 0.25;          %change in downwash w.r.t. alpha (rad/rad)
alpha_L0 = -11.5*pi/180;%zero lift angle of attack
n = 5.5;                %slope of linear region of lift slope
a3 = -768.5;            %coeff of alpha^3
a2 = 609.2;             %coeff of alpha^2
a1 = -155.2;            %coeff of alpha^1
a0 = 15.212;            %coeff of alpha^0
alpha_switch = 14.5*(pi/180);% alpha where lift

%1 saturation and limits in simulink

%2 intermediate variables
%calc airspeed
Va = sqrt(x1^2+x2^2+x3^2);

%alpha && beta
alpha = atan2(x3,x1);
beta = asin(x2/Va);

%dynamic pressure
Q = 0.5*rho*Va^2;

%def vectors wbe_b & V_b
wbe_b = [x4;x5;x6];
V_b = [x1;x2;x3];

%3 aerodynamic force coeffs
%calc CL_wb
if alpha <= alpha_switch
  CL_wb = n*(alpha - alpha_L0);
else
  CL_wb = a3*alpha^3 + a2*alpha^2 + a1*alpha +a0;
end

%CL_t
epsilon = depsda*(alpha-alpha_L0);
alpha_t = alpha - epsilon + u2 + 1.3*x5*lt/Va;
CL_t = 3.1*(St/S)*alpha_t;

%total lift force
CL = CL_wb + CL_t;

%total drag force (neglecting tail)
CD = 0.13 + 0.07*(5.5*alpha + 0.654)^2;

%sideforce
CY = -1.6*beta + 0.24*u3;

%4 aerodynamic sideforces
%in F_s (stabil axis)
FA_s = [-CD*Q*S;
        -CY*Q*S;
        -CL*Q*S;];

%rotate forces to F_b (body axs)
C_bs = [cos(alpha) 0 -sin(alpha);
        0 1 0;
        sin(alpha) 0 cos(alpha)];

FA_b = C_bs*FA_s;

%5 aerodynamic moment coeffs about aircraft
%moments in Fb, def eta, dCMdx & dCMdu
eta11 = -1.4*beta;
eta21 = -0.59 - (3.1*(St*lt)/(S*cbar))*(alpha-epsilon);
eta31 = (1-alpha*(180/(15*pi)))*beta;

eta = [eta11;
       eta21;
       eta31];

dCMdx = (cbar/Va)*[-11 0 5;
                    0 (-4.03*(St*lt^2)/(S*cbar^2)) 0;
                    1.7 0 -11.5];

dCMdu = [-0.6 0 0.22;
          0 (-3.1*(St*lt)/(S*cbar)) 0;
          0 0 -0.63];

CMac_b = eta + dCMdx*wbe_b +dCMdu*[u1;u2;u3];

%6 aerodynamic moment about aircraft
MAac_b = CMac_b*Q*S*cbar;

%7 aerodynamic moment about center gravity
rcg_b = [Xcg; Ycg; Zcg];
rac_b = [Xac; Yac; Zac];
MAcg_b = MAac_b + cross(FA_b, rcg_b - rac_b);

%8 engine force & moments
%thrust
F1 = u4*m*g;
F2 = u5*m*g;

%with Fb
FE1_b = [F1;0;0];
FE2_b = [F2;0;0];

FE_b = FE1_b + FE2_b;
%moment due to offset of engine thrust from center of gravity
mew1 = [Xcg - Xapt1;
        Yapt1 - Ycg;
        Zcg - Zapt1];

mew2 = [Xcg - Xapt2;
        Yapt2 - Ycg;
        Zcg - Zapt2];

MEcg1_b = cross(mew1,FE1_b);
MEcg2_b = cross(mew2,FE2_b);

MEcg_b = MEcg1_b + MEcg2_b;

%9 gravity effects
g_b = [-g*sin(x8);
    g*cos(x8)*sin(x7);
    g*cos(x8)*cos(x7)];
Fg_b = m*g_b;

%10 state derivatives
%inertia matrix
Ib = m*[40.07 0 -2.0923;
        0 64 0;
        -2.0923 0 99.92];

%inverse
invIb = (1/m)*[0.0249836    0        0.000523151;
                0           0.015625 0;
                0.000523151 0        0.010019];

%udot vdot wdot
F_b = Fg_b + FE_b + FA_b;
x1to3dot = (1/m)*F_b - cross(wbe_b,V_b);

Mcg_b = MAcg_b + MEcg_b;
x4to6dot = invIb*(Mcg_b - cross(wbe_b,Ib*wbe_b));

%phi theta & psi dot
H_phi = [1 sin(x7)*tan(x8) cos(x7)*tan(x8);
        0 cos(x7) -sin(x7);
        0 sin(x7)/cos(x8) cos(x7)/cos(x8)];

x7to9dot = H_phi*wbe_b;

XDOT = [x1to3dot
        x4to6dot
        x7to9dot
        F_b
        Mcg_b];
