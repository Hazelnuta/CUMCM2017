%绘制任务与聚类中心距离-任务定价曲线
%调用方法：
%load matlab.mat
%plot_done4(isdone, task2vip_min, task_pri)
function plot_done4(isdone, minDis, task_pri)
figure
task_num = size(isdone, 1);
valid_num = sum(isdone,1);
new_minDis = zeros(valid_num,1);
new_taskpri = zeros(valid_num,1);
count = 1;
for i = 1:task_num
    if isdone(i) == 1
        scatter(minDis(i), task_pri(i), 5, 3)
        hold on
        new_minDis(count) = minDis(i);
        new_taskpri(count) = task_pri(i);
        count = count + 1;
    end
end
b = robustfit(new_minDis, new_taskpri)
x = linspace(min(new_minDis), max(new_minDis), 1000);
y = b(2)*x + b(1);
plot(x, y);
