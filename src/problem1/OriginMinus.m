% 初始模型和近似的差值

% 参数设置
start_velocity = 5:0.1:20; % 扩展速度范围
start_angle = 30:0.1:50;     % 扩展角度范围
k = 0.0048;
g = 9.8;
h = 2.4;

% 创建网格
[Velocity, Angle] = meshgrid(start_velocity, start_angle);

% 初始化距离差值矩阵
distance_diff_approx = zeros(size(Velocity));
distance_diff_nonapprox = zeros(size(Velocity));

for i = 1:numel(Velocity)
    v = Velocity(i);
    a = Angle(i);

    % 初始模型投掷距离
    fun1 = @(x) x*tand(a) - g/2*((x/(v*cosd(a))).^2) + h;
    fun1_x = @(t) v*cosd(a)*t;
    fun1_y = @(t) v*sind(a)*t - g*(t.^2)/2 + h;
    t_flight = fzero(@(t) fun1_y(t), 2*v*sind(a)/g);
    distance_initial = fun1_x(t_flight);

    % 线性空气阻力模型（近似）投掷距离
    fun2_x = @(t) v*cosd(a)*t - k*v*cosd(a)/(2*2)*(t).^2;
    fun2_y = @(t) v*sind(a)*t - g*(t.^2)/2 + h;
    t_flight_approx = fzero(@(t) fun2_y(t), 2*v*sind(a)/g);
    distance_approx = fun2_x(t_flight_approx);

    % 线性空气阻力模型（无近似）投掷距离
    fun3_x = @(t) 2*v*cosd(a)/k*(1 - exp(-k/2*t));
    fun3_y = @(t) (2*(v*sind(a)*k+2*g)/(k^2))*(1 - exp(-k/2*t)) - (2*g/k*t) + h;
    t_flight_nonapprox = fzero(@(t) fun3_y(t), 2*v*sind(a)/g);
    distance_nonapprox = fun3_x(t_flight_nonapprox);

    % 计算距离差值
    distance_diff_approx(i) = distance_initial - distance_approx;
    distance_diff_nonapprox(i) = distance_initial - distance_nonapprox;
end

% 绘制热力图
figure;
% imagesc(start_velocity, start_angle, distance_diff_approx);
% colorbar;
% xlabel('Velocity (m/s)');
% ylabel('Angle (°)');
% axis square; % 将坐标轴缩放为正方形

imagesc(start_velocity, start_angle, distance_diff_nonapprox);
colorbar;
xlabel('Velocity (m/s)');
ylabel('Angle (°)');
axis square; % 将坐标轴缩放为正方形
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];
