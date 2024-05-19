clear;
start_velocity= [10.5,10.1,9.9,9.3,9.1,9.9,8.1,8.3,8.2,8.2,8.1,8.0,7.7,7.1,6.9,6.0];
start_angle = [33,34,35,36,31,35,35,32,33,36,35,37,28,35,34,36];
%模型
%fun = @(p,X)X(:,1).*cosd(X(:,2)).*();                       %x轴向，一阶量
%fun = @(p,X)p(3)*0.5./X(:,4).*().*(().^2);                  %x轴向，二阶量
%fun = @(p,X)-X(:,3) + X(:,1).*cosd(X(:,2));                  %水平风
%fun = @(p,X) -X(:,3).*cosd(X(:,5)) +X(:,1).*cosd(X(:,2));     %任意方向
%t = @(p,X)(X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*()).^0.5)./(); %时间量
%t = @(p,X) p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4);                      %p(1)修正
%t = @(p,X)(X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4)); %时间量
%t1 = @(p,X)(X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2)*p(1)).^0.5)/p(1);
%t2 = @(p,X)(X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3)./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3)./X(:,4));
fun = @(p,X)X(:,1).*cosd(X(:,2)).*((X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))) - p(3)*0.5./X(:,4).*(-X(:,3).*cosd(X(:,5)) +X(:,1).*cosd(X(:,2))).*(((X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^2);
Pi = 3.14;
k0 = 0.5*0.53*1.293*((0.05)^2)*Pi;
p = [9.81,1.5,0.0003];
v = start_velocity(1);
a = start_angle(1);
m = 0.5;

%风速固定时，落地距离与风向的关系图




c_theta = -180:0.1:180;
c_vf = zeros(size(c_theta));
c_vf(:) = 0;
c_velocity = zeros(size(c_theta));
c_velocity(:) = v;
c_angle = zeros(size(c_theta));
c_angle(:) = a;
c_m = zeros(size(c_theta));
c_m(:) = m;


c_l = fun(p,[c_velocity',c_angle',c_vf',c_m',c_theta']);
%x1 = fun(p,[v,a,0,0.5,0]);
figure;
plot(c_theta,c_l, 'LineWidth', 2,'Color', 'g');
hold on ;
c_vf(:) = 10;
c_l = fun(p,[c_velocity',c_angle',c_vf',c_m',c_theta']);
plot(c_theta,c_l, 'LineWidth', 2,'Color', 'b');


[max_val, max_idx] = max(c_l);
[min_val, min_idx] = min(c_l);

hold on;

line([-200, c_theta(max_idx)], [max_val, max_val], 'LineStyle', '--', 'Color', 'k');
line([-200, c_theta(min_idx)], [min_val, min_val], 'LineStyle', '--', 'Color', 'k');
line([c_theta(max_idx), c_theta(max_idx)], [12.18, max_val], 'LineStyle', '--', 'Color', 'k');
line([c_theta(min_idx), c_theta(min_idx)], [12.18, min_val], 'LineStyle', '--', 'Color', 'k');


text(c_theta(max_idx)-100, max_val-0.0025, ['Max: (', num2str(c_theta(max_idx)), ', ', num2str(max_val), ')'], 'FontSize', 10, 'FontWeight', 'bold');
text(c_theta(min_idx), min_val+0.002, ['Min: (', num2str(c_theta(min_idx)), ', ', num2str(min_val), ')'], 'FontSize', 10, 'FontWeight', 'bold');


plot(c_theta(max_idx), max_val, 'ro', 'MarkerFaceColor', 'r');
plot(c_theta(min_idx), min_val, 'ro', 'MarkerFaceColor', 'r');
hold on;



xlabel('theta/°');
ylabel('length/m');
legend('风速Vf = 0m/s', '风速Vf = 10m/s', 'FontSize', 8);

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];
%figure;
%c_vf = -10:0.1:10;
%c_velocity = zeros(size(c_vf));
%c_velocity(:) = v;
%c_angle = zeros(size(c_vf));
%c_angle(:) = a;
%c_m = zeros(size(c_vf));
%c_m(:) = m;
%c_theta = zeros(size(c_vf));
%c_theta(:) = 0;
%c_l = fun(p,[c_velocity',c_angle',c_vf',c_m',c_theta']);
%plot(c_vf,c_l);

%指定出手角度，出手速度，质量时三维关系作图
figure;
theta_range = -180:0.1:180;
vf_range = 0:0.1:20;
[c_theta, c_vf] = meshgrid(theta_range, vf_range);

v = start_velocity(1);
a = start_angle(1);
m = 0.5;

c_velocity = ones(size(c_theta)) * v;
c_angle = ones(size(c_theta)) * a;
c_m = ones(size(c_theta)) * m;

c_l = fun(p, [c_velocity(:), c_angle(:), c_vf(:), c_m(:), c_theta(:)]);
c_l = reshape(c_l, size(c_theta));

surf(c_theta, c_vf, c_l, 'EdgeColor', 'none');
xlabel('theta/°');
ylabel('vf/(m/s)');
zlabel('length/m');

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];


%最佳出手角与风速、风向间的关系图

theta_range = -180:0.1:180;
vf_range = 0:0.1:20;
[c_theta, c_vf] = meshgrid(theta_range, vf_range);
velocity = 8;
m = 0.5;
angle_best(size(theta_range),size(vf_range)) = 0;
opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
for i = 1:size(theta_range')
    for j = 1:size(vf_range')
        objective = @(angle) -fun(p,[velocity,angle,vf_range(j),m,theta_range(i)]);
        angle_best(i,j) = fminbnd(objective, 0, 90, opts);
    end
end
figure;
surf(c_theta, c_vf, angle_best', 'EdgeColor', 'none');
xlabel('theta/°');
ylabel('vf/(m/s)');
zlabel('best-angle/°');
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];