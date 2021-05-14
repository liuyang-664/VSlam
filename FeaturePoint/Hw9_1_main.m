%Hw9_1_main.m
%比较对于边值问题Shooting Method和内置函数bvp4c的求解结果
clear all; clc; addpath(genpath('.'));
%一：使用Shooting Method求解
%求解算法使用二分法，转化为初值问题后用RK4方法求解
%residual_yb(x)为代入初始速度后得到y(b)-yb值的函数
TOL = 1e-8;
a = 0; %二分法求解的初始迭代值a
b = 1; %二分法求解的初始迭代值b
residual_a = residual_yb(a)
residual_b = residual_yb(b)
while (b-a)/2 > TOL
    c = (b+a)/2;
    rc = residual_yb(c);
    if rc == 0
        break;
    end
    if sign(rc) == sign(residual_yb(a))
        a = c;
    else
        b = c;
    end
end
xRoot = (b+a) / 2
[r_xRoot,t1,w1] = residual_yb(xRoot);
plot(t1,w1(:,1))
xlabel('t')
ylabel('y')
hold on;
%二：使用内置函数bvp4c求解
xmesh = linspace(0,1,5);
solinit = bvpinit(xmesh, @guess);
sol = bvp4c(@bvpfcn, @bcfcn, solinit);
plot(sol.x, sol.y(1,:), '-o');
hold off;
title('$y''''=10y^3+3y+t^2,y(0)=0,y(1)=1$','interpreter','latex')
legend('Shooting Method', 'bvp4c')
rmpath(genpath('.'));

%--------------------------------
function dydx = bvpfcn(x,y) % equation to solve
dydx = zeros(2,1);
dydx = [y(2)
       10*y(1)^3 + 3*y(1) + x^3];
end
%--------------------------------
function res = bcfcn(ya,yb) % boundary conditions
res = [ya(1)
       yb(1)-1];
end
%--------------------------------
function g = guess(x) % initial guess for y and y'
g = [x + x^3
     1+ x^2];
end
%--------------------------------
%residual_yb.m
function [r, t, w] = residual_yb(x)
%计算初始速度为x时边值问题的解中y(b)-yb的值
%使用RK4方法求解边值问题
f = @(t,y) [y(2), 10*y(1)^3 + 3*y(1) + t^3];
ta = 0;
tb = 1;
y_0 = 0; %前端边界值
y_1 = 1; %末端边界值
h = 0.01;
t = [ta:h:tb]';
yBegin = [y_0, x];
w = zeros(length(t), length(yBegin));
w(1,:) = yBegin;
for i = 1:length(t)-1
    k1 = f(t(i), w(i,:));
    k2 = f(t(i) + h/2, w(i,:) + h/2 * k1);
    k3 = f(t(i) + h/2, w(i,:) + h/2 * k2);
    k4 = f(t(i) + h, w(i,:) + h * k3);
    w(i+1,:) = w(i,:) + h/6 * (k1 + 2*k2 + 2*k3 + k4);
end
r = w(end, 1) - y_1;
end