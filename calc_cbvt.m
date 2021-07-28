function [C_bv] = calc_cbvt(X)

phi = X(1);
theta = X(2);
psi = X(3);
u = X(4);
v = X(5);
w = X(6);
V_b = [u;v;w];
C_psi = [cos(psi) sin(psi) 0;
      -sin(psi) cos(psi) 0;
       0        0        1];
C_theta = [cos(theta) 0 -sin(theta);
           0          1  0;
           sin(theta) 0  cos(theta)];
       
C_phi = [1 0        0;
         0 cos(phi) sin(phi);
         0 -sin(phi) cos(phi)];
     
C_bv =  C_phi.*C_theta.*C_psi;
C_bv = C_bv'*V_b;
   