clear;
start_velocity= [10.5,10.1,9.9,9.3,9.1,9.9,8.1,8.3,8.2,8.2,8.1,8.0,7.7,7.1,6.9,6.0];
start_angle = [33,34,35,36,31,35,35,32,33,36,35,37,28,35,34,36];
%参数设置
k = 0.0004;
g = 9.8;
h = 2.4;
v =10.5;
a = 30;
%模型
%简单模型
fun1_x = @(t) v*cosd(a)*t;
fun1_y = @(t) v*sind(a)*t - g*(t.^2)/2+h;
fun1 = @(x) x*tand(a) - g/2*((x/(v*cosd(a))).^2) + h;
%x轴向线性模型，考虑空气阻力二阶量
fun2_x = @(t) v*cosd(a)*t - k*v*cosd(a)/(2*2)*(t).^2;
fun2_y = @(t) v*sind(a)*t - g*(t.^2)/2+h;
%线性模型，考虑空气阻力
fun3_y = @(t) (2*(v*sind(a)*k+2*g)/(k^2))*(1 - exp(-k/m*t)) - (2*g/k*t) + h;
fun3_x = @(t) 2*v*cosd(a)/k*(1 - exp(-k/2*t));
fun3 = @(x)(2*g+k*v*sind(a))*(k*x - v*cosd(a)*2)/(k*k*v*cosd(a)) + g*2*2*log(-(k*x - v*cosd(a)*2)/(v*cosd(a)*2))/(k*k) + (2*g + k*v*sind(a))*2/(k*k)+h;

%x轴向线性模型，考虑空气阻力和空气升力
k1 =k;
k2 =k;
vx = v*cosd(a);
vy = v*sind(a);
fun4_x= @(t) (exp(-k1*t) .* (-vx*k1^2 + k2*vy*k1 + g*k2)) ./ (k1^3) - (-vx*k1^2 + k2*vy*k1 + g*k2) ./ (k1^3) + (t .* (g*k2 + k1*k2*vy)) ./ (k1^2) - (g*k2.*t.^2) ./ (2*k1);
fun4_y= @(t) h + t*vy - (g*t.^2) / 2;
%x轴向线性模型，考虑空气阻力和空气升力二阶量
fun5_x= @(t) ((1 - k1*t + 0.5*(k1*t).^2) .* (-vx*k1^2 + k2*vy*k1 + g*k2)) ./ (k1^3) - (-vx*k1^2 + k2*vy*k1 + g*k2) ./ (k1^3) + (t .* (g*k2 + k1*k2*vy)) ./ (k1^2) - (g*k2.*t.^2) ./ (2*k1);
fun5_y= @(t) h + t*vy - (g*t.^2) / 2;
%绘图

c_t = 0:0.03:1.8;
x4 = fun4_x(c_t);
y4 = fun4_y(c_t);
y3 = fun3(x4);
t = zeros(size(c_t));
[~,n] = size(c_t);

for i=1:n
     t(i)= fsolve(@(t) fun5_x(t) - x4(i), 0);
end
x5 = fun5_x(t);
y5 = fun5_y(t);

y1 = fun1(x4);

[m,n] = size(c_t);
y5_MSE = sum((y5 - y4).^2)/n;
plot(x4,y4, 'b-', 'LineWidth', 2);
hold on;
plot(x5,y5,'g--','LineWidth', 2);
hold on;

xlabel('length/m');
ylabel('height/m');
legend('线性空气阻力（无近似）', '线性空气阻力(近似）');

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];
