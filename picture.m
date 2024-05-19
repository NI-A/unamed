clear;
start_velocity= [10.5,10.1,9.9,9.3,9.1,9.9,8.1,8.3,8.2,8.2,8.1,8.0,7.7,7.1,6.9,6.0];
start_angle = [33,34,35,36,31,35,35,32,33,36,35,37,28,35,34,36];
k = 0.0012;
g = 9.8;
h = 2.4;
v = 10.4;
a = 30;
%简单模型
fun1_x = @(t) v*cosd(a)*t;
fun1_y = @(t) v*sind(a)*t - g*(t.^2)/2+h;
fun1 = @(x) x*tand(a) - g/2*((x/(v*cosd(a))).^2) + h;
%x轴向线性模型，考虑二阶量
fun2_x = @(t) v*cosd(a)*t - k*v*cosd(a)/(2*2)*(t).^2;
fun2_y = @(t) v*sind(a)*t - g*(t.^2)/2+h;
%线性模型
fun3_y = @(t) (2*(v*sind(a)*k+2*g)/(k^2))*(1 - exp(-k/m*t)) - (2*g/k*t) + h;
fun3_x = @(t) 2*v*cosd(a)/k*(1 - exp(-k/2*t));
fun3 = @(x)(2*g+k*v*sind(a))*(k*x - v*cosd(a)*2)/(k*k*v*cosd(a)) + g*2*2*log(-(k*x - v*cosd(a)*2)/(v*cosd(a)*2))/(k*k) + (2*g + k*v*sind(a))*2/(k*k)+h;



%绘图

c_t = 0:0.03:1.8;
x2 = fun2_x(c_t);
y2 = fun2_y(c_t);
%x1 = fun1_x(c_t);
%y1 = fun1_y(c_t);
y1 = fun1(x2);
%x3 = fun3_x(c_t);
y3 = fun3(x2);


[m,n] = size(c_t);
y1_MSE = sum((y1 - y3).^2)/n;
y2_MSE = sum((y2 - y3).^2)/n;
plot(x2,y1,'b-', 'LineWidth', 2);
hold on;
plot(x2,y2, 'ro--', 'LineWidth', 2);
hold on;
plot(x2,y3,'g--','LineWidth', 2);
hold on;

xlabel('length/m');
ylabel('height/m');
legend('初始模型', '线性空气阻力（近似）', '线性空气阻力(无近似）');

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];
