% 参数设置
start_velocity = 5:0.1:15; % 扩展速度范围
start_angle = 30:0.1:50;   % 扩展角度范围
k = 0.0048;
j = 0.0019;
g = 9.8;
h = 2.4;
p0 = [g, h, k, j];

% 创建网格
[Velocity, Angle] = meshgrid(start_velocity, start_angle);

% 初始化轨迹偏差矩阵
trajectory_mse = zeros(size(Velocity));

% 计算 fun_5 和 fun_4 的投掷轨迹
for i = 1:numel(Velocity)
    v = Velocity(i);
    a = Angle(i);

    k1 = k;
    k2 = j;
    vx = v * cosd(a);
    vy = v * sind(a);

    % 旋转（近似）投掷轨迹
    fun5_x = @(t) ((1 - k1 * t + 0.5 * (k1 * t).^2) .* (-vx * k1^2 + k2 * vy * k1 + g * k2)) ./ (k1^3) ...
                - (-vx * k1^2 + k2 * vy * k1 + g * k2) ./ (k1^3) ...
                + (t .* (g * k2 + k1 * k2 * vy)) ./ (k1^2) ...
                - (g * k2 .* t.^2) ./ (2 * k1);
    fun5_y = @(t) h + t * vy - (g * t.^2) / 2;
    t_flight_spin = fzero(@(t) fun5_y(t) - h, 2 * v * sind(a) / g);

    t_values_spin = linspace(0, t_flight_spin, 100); % 用于计算轨迹的时间值
    x_spin = fun5_x(t_values_spin);
    y_spin = fun5_y(t_values_spin);

    % 考虑旋转（无近似）投掷轨迹
    fun4_x = @(t) (exp(-k1 * t) .* (-vx * k1^2 + k2 * vy * k1 + g * k2)) ./ (k1^3) ...
                - (-vx * k1^2 + k2 * vy * k1 + g * k2) ./ (k1^3) ...
                + (t .* (g * k2 + k1 * k2 * vy)) ./ (k1^2) ...
                - (g * k2 .* t.^2) ./ (2 * k1);
    fun4_y = @(t) h + t * vy - (g * t.^2) / 2;
    t_flight_spinNo = fzero(@(t) fun4_y(t) - h, 2 * v * sind(a) / g);

    t_values_spinNo = linspace(0, t_flight_spinNo, 100); % 用于计算轨迹的时间值
    x_spinNo = fun4_x(t_values_spinNo);
    y_spinNo = fun4_y(t_values_spinNo);

    % 插值计算y值，确保x坐标相同
    common_x = linspace(min(min(x_spin), min(x_spinNo)), max(max(x_spin), max(x_spinNo)), 100);
    y_spin_interp = interp1(x_spin, y_spin, common_x, 'linear', 'extrap');
    y_spinNo_interp = interp1(x_spinNo, y_spinNo, common_x, 'linear', 'extrap');

    % 计算每一个x对应的y_mse，评价轨迹偏差
    y_diff = y_spin_interp - y_spinNo_interp;
    y_mse = mean(y_diff .^ 2);
    
    trajectory_mse(i) = y_mse;
end

% 绘制轨迹偏差热力图
figure;
imagesc(start_velocity, start_angle, trajectory_mse);
colorbar;
xlabel('Velocity (m/s)');
ylabel('Angle (°)');
axis square; % 将坐标轴缩放为正方形
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3), fig_pos(4)];
saveas(gcf, 'MSE_Spin_NoApproximatetoApproximate.pdf');
