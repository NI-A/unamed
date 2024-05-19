clear;clc;

%不考虑风速风向
syms t s k1 k2 x y g h vx vy p X Y;

eq1 = s^2 * X  - vx == -k1 * s * X + k2 *( s * Y - h);
eq2 = s^2 * Y - s * h - vy == -g/s ;

sol = solve(eq1, eq2, X, Y);

xSol = ilaplace(sol.X, s, t);
ySol = ilaplace(sol.Y, s, t);

%考虑风速风向
syms ux uy;
eq1 = s^2 * X  - vx == -k1 * (s * X -ux/s)- k2 *( s * Y - h - uy/s);
eq2 = s^2 * Y - s * h - vy == -g/s +k1*uy/s -k2*ux/s;

sol = solve(eq1, eq2, X, Y);

x2Sol = ilaplace(sol.X, s, t);
y2Sol = ilaplace(sol.Y, s, t);

%求导
dxSol = diff(xSol, t);
dx2Sol = diff(x2Sol, t);
%求导
dySol = diff(ySol, t);
dy2Sol = diff(y2Sol, t);

%求二阶导
ddxSol = diff(xSol, t,2);
ddx2Sol = diff(x2Sol, t,2);
%求二阶导
ddySol = diff(ySol, t,2);
ddy2Sol = diff(y2Sol, t,2);