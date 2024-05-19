% 第二问
% 求解最佳出手角度

clear;
%导入数据
g = 9.81;
Pi = 3.14;
start_velocity= [10.5,10.1,9.9,9.3,9.1,9.9,8.1,8.3,8.2,8.2,8.1,8.0,7.7,7.1,6.9,6.0];
start_angle = [33,34,35,36,31,35,35,32,33,36,35,37,28,35,34,36];
x_length = [13.08,12.36,12.03,10.93,10.28,12.03,8.78,8.99,8.88,8.97,8.78,8.65,7.84,7.22,6.92,5.69];

X = [start_velocity',start_angle'];
Y = x_length';
k0 = 0.5*0.53*1.293*((0.1336/2)^2)*Pi;
%简单模型
%fun = @(p,X)X(:,1).*(cosd(X(:,2))).*((X(:,1).*(sind(X(:,2))))+((X(:,1).*(sind(X(:,2)))).^2+2*p(1)*p(2)).^0.5)/p(1);
%p0 = [9.81,2.4];
%x轴向线性模型，考虑二阶量
fun = @(p,X)X(:,1).*(cosd(X(:,2))).*((X(:,1).*(sind(X(:,2))))+((X(:,1).*(sind(X(:,2)))).^2+2*p(1)*p(2)).^0.5)/p(1) - p(3)*X(:,1).*cosd(X(:,2))/(2*2).*(X(:,1).*(cosd(X(:,2))).*((X(:,1).*(sind(X(:,2))))+((X(:,1).*(sind(X(:,2)))).^2+2*p(1)*p(2)).^0.5)/p(1)).^2;
p0 = [9.81,2.4,0.0048];
opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
%p = nlinfit(X,Y,fun,p0,opts);
LB =[];
UB = [];
options = optimset('MaxFunEvals',800,'MaxIter',500,'TolFun',1.000000e-06);
p = lsqcurvefit(fun,p0,X,Y,LB,UB,options);
%计算拟合值
Y1 = fun(p,X);

%计算MSE
[m , n]= size(Y);
Yc = (Y1 - Y);
MSE = sum(Yc.^2)/m;
%画图
c_velocity=5:0.1:12;
c_angle=15:0.1:55;
[V, A] = meshgrid(c_velocity, c_angle); %生成网格
X_mesh = [V(:), A(:)];
% 计算对应的Z值
L = fun(p, X_mesh);
L = reshape(L, size(V));

% 绘制三维图像
figure;
surf(V, A, L, 'EdgeColor', 'none');
xlabel('velocity/(m/s)');
ylabel('angle/°');
zlabel('length/m');
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];
%计算
d = [8.70,36.7];
S1 = fun(p,d);
%最优化计算
velocity = 8;
objective = @(angle) -fun(p,[velocity,angle]);
angle_best = fminbnd(objective, 0, 90, opts);
%绘图
figure;
c_angle=15:0.1:55;
c_velocity = zeros(size(c_angle));
c_velocity(:) = velocity;
L = fun(p, [c_velocity',c_angle']);
plot(c_angle,L,'LineWidth', 2);
xlabel('angle/°');
ylabel('length/m');

hold on;

[maxY, maxIndex] = max(L);
maxX = c_angle(maxIndex);
plot(maxX, maxY, 'ro', 'MarkerFaceColor', 'r');
plot([c_angle(1), maxX], [maxY, maxY], 'k--'); % 从原点到最高点的水平虚线
plot([maxX, maxX], [7, maxY], 'k--'); % 从最高点到 x 轴的垂直虚线
plot(maxX, maxY, 'ro', 'MarkerFaceColor', 'r');
legend('velocity = 8m/s','最佳出手角度点');
labelX = (c_angle(1) + c_angle(350)) / 2;
labelY = (L(250) + L(350)) / 2;
text(labelX, labelY, ['Max: (', num2str(maxX), ', ', num2str(maxY), ')'],'FontSize', 13, 'FontWeight', 'bold');
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3),fig_pos(4)];