import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.optimize import curve_fit

# 给定数据
start_velocity = np.array([10.5, 10.1, 9.9, 9.3, 9.1, 9.9, 8.1, 8.3, 8.2, 8.2, 8.1, 8.0, 7.7, 7.1, 6.9, 6.0])
start_angle = np.array([33, 34, 35, 36, 31, 35, 35, 32, 33, 36, 35, 37, 28, 35, 34, 36])
x_length = np.array([13.08, 12.36, 12.03, 10.93, 10.28, 12.03, 8.78, 8.99, 8.88, 8.97, 8.78, 8.65, 7.84, 7.22, 6.92, 5.69])

# 定义二元函数拟合模型
def func(x, a, b, c):
    velocity, angle = x
    return a * velocity**2 + b * angle + c

# 数据拟合
popt, pcov = curve_fit(func, (start_velocity, start_angle), x_length)

# 可视化拟合结果
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# 绘制数据点
ax.scatter(start_velocity, start_angle, x_length, c='r', marker='o', label='Data')

# 构建网格点
x = np.linspace(min(start_velocity), max(start_velocity), 50)
y = np.linspace(min(start_angle), max(start_angle), 50)
X, Y = np.meshgrid(x, y)

# 计算拟合值
Z = func((X, Y), *popt)

# 绘制拟合曲面
ax.plot_surface(X, Y, Z, alpha=0.5, cmap='viridis', label='Fit')

ax.set_xlabel('Speed (m/s)')
ax.set_ylabel('Angle (°)')
ax.set_zlabel('Distance (m)')

plt.legend()
plt.show()
