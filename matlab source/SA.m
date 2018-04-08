%不打包定价的目标优化模型(基于模拟退火法)
%调用方法：
%load matlab.mat;
%[p, alpha, beta] = SA(density, task_pos,task_credit, task2vip_min, 1/70, 0.05, -1,80)
function [p, alpha, beta] = SA(density, task_pos,task_credit, remote, coeff, StepFactor, start1, start2);
MarkovLength=1000; % 马可夫链长度
DecayScale=0.95; % 衰减参数 
Temperature0=100; % 初始温度
Temperatureend=1; % 最终温度
Boltzmann_con=1; % Boltzmann常数
AcceptPoints=0.0; % Metropolis过程中总接受点
% 随机初始化参数
Par_cur=[start1, start2]; % 用Par_cur表示当前解
%Par_best_cur = Par_cur; % 用Par_best_cur表示当前最优解
Par_best=Par_cur; % 用Par_best表示冷却中的最好解
Par_new = Par_cur;
% 每迭代一次退火(降温)一次，直到满足迭代条件为止
t=Temperature0;
alpha = start1;
beta = start2;
itr_num=0; % 记录迭代次数
while t>Temperatureend
    itr_num=itr_num+1;
    t = DecayScale*t;  % 温度更新（降温)
    for i=1:MarkovLength
        % 在此当前参数点附近随机选下一点
        Par_new(1) = Par_cur(1) + StepFactor*(rand(1) - 0.5);
        Par_new(2) = Par_cur(2) + StepFactor*(rand(1) - 0.5);
        % 检验当前解是否为全局最优解
        if (ObjectFunction(density,task_pos,task_credit, remote, coeff,Par_best)<...
                ObjectFunction(density,task_pos,task_credit, remote, coeff,Par_new))
            % 保留上一个最优解
            %Par_best_cur = Par_best;
            % 此为新的最优解
            Par_best=Par_new;
        end
        % Metropolis过程
        if (ObjectFunction(density,task_pos,task_credit, remote, coeff,Par_cur)-...
                ObjectFunction(density,task_pos,task_credit, remote, coeff,Par_new)<0)
            % 接受新解
            Par_cur=Par_new;
            AcceptPoints=AcceptPoints+1;
        else
            changer=(ObjectFunction(density,task_pos,task_credit, remote, coeff, Par_new)-...
            ObjectFunction(density,task_pos,task_credit, remote, coeff, Par_cur))/(Boltzmann_con*t);
            p1 = exp(changer);
            if p1>rand(1)
                Par_cur=Par_new;
                AcceptPoints=AcceptPoints+1;
            end
        end
        alpha = Par_best(1);
        beta = Par_best(2);
    end
end
[~, p, count, object, ~] = ObjectFunction(density,task_pos,task_credit, remote, 1/70, Par_best);
count    %输出完成任务数
object   %输出目标函数值
alpha
beta


