%目标函数（打包模式下）
%调用方法：
%load matlab.mat
%[x, p, count, object, payment] = ObjectFunction2(task_distance,package,density,task_credit, task2vip_min, 1/70,  [2.4103, 68.3345])
function [x, p, count, object, payment]  = ObjectFunction2(distance,package,density,task_credit, remote, coeff, solution)
task_num = size(remote, 1);  
p = zeros(size(package,2), 1);
%计算打包结构体的定价
for i = 1:size(package,2)   %package为打包的结构体序列
    if package(i).node_num == 1    %如果任务包为单点包，按照原方法定价
        num = package(i).rec(1);
        p(i) = solution(1)*task_credit(num)*remote(i) + solution(2);
    else                          %如果任务包为多点包，包内每个任务点的定价用密度计算
        p_group = zeros(package(i).node_num, 1);
        for j = 1:package(i).node_num
            num = package(i).rec(j);
            p_group(j) = solution(1)*task_credit(num)/(density(num) + 1) + solution(2);
        end
        p(i) = package(i).node_num * min(p_group); %任务包的定价为包内最低价格任务点的价格n倍
    end
end
%预测所有任务包的完成度
x = zeros(size(package,2), 1);
count = 0;
com_sum = 0;
for j = 1:size(package,2)
    if package(j).node_num == 1
        if p(j) >  -2.2740*density(j) + 75.2988
           x(j) = 1;
           count = count+ 1;
           com_sum = com_sum + 1;
        end
    else
        internDis = 0;  %记录任务包的内部距离和
        orgDis = 0;   %记录任务包的各点外部距离和
        for jj = 1:package(j).node_num - 1
            internDis = internDis + distance(package(j).rec(jj), package(j).rec(jj + 1));
            orgDis = orgDis + remote(package(j).rec(jj));
        end
        orgDis = orgDis + remote(package(j).rec(package(j).node_num));
        if p(j) > 2.0383*(orgDis/package(j).node_num + internDis) + 68.1819  %由第一问拟合而得的距离定价线
                x(j) = 1;
                count = count+ package(j).node_num;
        end
    end
end
payment = sum(x.*p);
object = count - (task_num - count) - coeff*payment;       %输出目标函数的最终值