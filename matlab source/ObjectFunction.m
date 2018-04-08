%Ŀ�꺯��
%���÷�����
%load matlab.mat
%[x, p, count, object] = ObjectFunction(density,task_pos,task_credit, task2vip_min, 1/70, [-0.945,75.848]); 
function [x, p, count, object, payment] = ObjectFunction(density,task_pos,task_credit, remote, coeff, solution)
task_num = size(task_pos, 1);  
p = solution(1)*task_credit.*remote + solution(2); %���۾���
x = zeros(task_num, 1);
count = 0;
for i = 1:task_num
    if p(i) >  -2.2740*density(i) + 75.2988  %������·�̴���
       x(i) = 1;
       count = count+ 1;
    end
end
payment = sum(x.*p);      %�����̼���Ҫ֧�����ܳ��
object = sum(x) - sum(1.- x) - coeff*payment;  %����Ŀ�꺯��ֵ