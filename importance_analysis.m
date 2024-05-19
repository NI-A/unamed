clear;clc;

fun = @(p,X)X(:,1).*cosd(X(:,2)).*((X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))) - p(3)*0.5./X(:,4).*(-X(:,3).*cosd(X(:,5)) +X(:,1).*cosd(X(:,2))).*(((X(:,1).*sind(X(:,2)) +((X(:,1).*sind(X(:,2))).^2+2*p(2).*(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^0.5)./(p(1) - p(3)*X(:,3).*sind(X(:,5))./X(:,4))).^2);
Pi = 3.14;
k0 = 0.5*0.53*1.293*((0.05)^2)*Pi;
p = [9.81,1.5,k0];
m = 0.5;

% 定义参数范围
lb = [5, 10, 0, 0.1, -180];
ub = [20, 50, 15, 2, 180];

% 生成输入变量的采样点
N = 5000; % 采样点数
n = numel(lb); % 输入变量数量
X = lhsdesign(N, n); % 使用拉丁超立方采样设计生成样本
for i = 1:n
    X(:,i) = X(:,i) .* (ub(i) - lb(i)) + lb(i);
end

% 计算模型输出
Y = fun(p, X);

% 计算总方差
total_variance = var(Y);

% 计算各个变量的主效应和交互效应
main_effects = zeros(1, n);
total_effects = zeros(1, n);
for i = 1:n
    X_temp = X;
    X_temp(:,i) = rand(size(X_temp(:,i))) * (ub(i) - lb(i)) + lb(i);
    Y_temp = fun(p, X_temp);
    main_effects(i) = var(Y_temp) / total_variance;
    total_effects(i) = (mean((Y - mean(Y)) .* (Y_temp - mean(Y_temp))))^2 / (total_variance * var(Y_temp));
end


% 计算 PRCC
PRCC_values = zeros(1, 5);
for i = 1:5
    PRCC_values(i) = corr(Y, X(:,i), 'Type', 'Spearman');
end

% 显示结果
disp('PRCC 值:');
disp(PRCC_values);

