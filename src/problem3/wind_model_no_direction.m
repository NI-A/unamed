clear;
start_velocity= [10.5,10.1,9.9,9.3,9.1,9.9,8.1,8.3,8.2,8.2,8.1,8.0,7.7,7.1,6.9,6.0];
start_angle = [33,34,35,36,31,35,35,32,33,36,35,37,28,35,34,36];
%模型，x轴向风
%fun = @(p,X)X(:,1).*cosd(X(:,2)).*();                       %x轴向，一阶量
%fun = @(p,X)p(3)*0.5./X(:,4).*().*(().^2);                  %x轴向，二阶量
%fun = @(p,X)-X(:,3) + X(:,1).*cosd(X(:,2));                  %水平风
%t = @(p,X)(X(:,1).*sind(X(:,2)) + ((X(:,1).*sind(X(:,2))).^2+2*p(1)*p(2)).^0.5)/p(1); %时间量
%fun = @(p,X)X(:,1).*cosd(X(:,2)).*(((X(:,1).*(sind(X(:,2))))+((X(:,1).*(sind(X(:,2)))).^2+2*p(1)*p(2)).^0.5)/p(1)) - p(3)./(2*X(:,4)).*(-X(:,3) + X(:,1).*cosd(X(:,2))).*((((X(:,1).*(sind(X(:,2))))+((X(:,1).*(sind(X(:,2)))).^2+2*p(1)*p(2)).^0.5)/p(1)).^2);

fun = @(p,X)X(:,1).*cosd(X(:,2)).*((X(:,1).*sind(X(:,2)) + ((X(:,1).*sind(X(:,2))).^2+2*p(1)*p(2)).^0.5)/p(1)) - p(3)*0.5./X(:,4).*(-X(:,3) + X(:,1).*cosd(X(:,2))).*(((X(:,1).*sind(X(:,2)) + ((X(:,1).*sind(X(:,2))).^2+2*p(1)*p(2)).^0.5)/p(1)).^2);
fun_2 =@(p,X)X(:,4).*(-X(:,3) + X(:,1).*cosd(X(:,2)))/p(3).*(1 - exp(-p(3)./X(:,4).*((X(:,1).*sind(X(:,2)) + ((X(:,1).*sind(X(:,2))).^2+2*p(1)*p(2)).^0.5)/p(1)))) + X(:,3).*((X(:,1).*sind(X(:,2)) + ((X(:,1).*sind(X(:,2))).^2+2*p(1)*p(2)).^0.5)/p(1));
Pi = 3.14;
k0 = 0.5*0.53*1.293*((0.05)^2)*Pi;
p = [9.81,1.5,0.0003];
v = start_velocity(1);
a = start_angle(1);
% 验证模型
m = 2;
%m = 0.5;
c_vf = -10:0.1:10;
c_velocity = zeros(size(c_vf));
c_velocity(:) = v;
c_angle = zeros(size(c_vf));
c_angle(:) = a;
c_m = zeros(size(c_vf));
c_m(:) = m;
c_l = fun_2(p,[c_velocity',c_angle',c_vf',c_m']);
figure;
plot(c_vf,c_l,'LineWidth', 2);
hold on;
c_l = fun(p,[c_velocity',c_angle',c_vf',c_m']);
plot(c_vf,c_l,'LineWidth', 2);
l = fun(p,[v,a,10,0.5]);
legend('线性空气阻力（无近似）', '线性空气阻力（近似）');

xlabel('vf/(m/s)');
ylabel('length/m');

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];