%目标函数
%调用方法：
%load matlab.mat
%[x, p, count, object] = ObjectFunction(density,task_pos,task_credit, task2vip_min, 1/70, [-0.945,75.848]); 
function [x, p, count, object, payment] = ObjectFunction(density,task_pos,task_credit, remote, coeff, solution)
task_num = size(task_pos, 1);  
p = solution(1)*task_credit.*remote + solution(2); %定价矩阵
x = zeros(task_num, 1);
count = 0;
for i = 1:task_num
    if p(i) >  -2.2740*density(i) + 75.2988  %酬金大于路程代价
       x(i) = 1;
       count = count+ 1;
    end
end
payment = sum(x.*p);      %计算商家需要支付的总酬金
object = sum(x) - sum(1.- x) - coeff*payment;  %计算目标函数值