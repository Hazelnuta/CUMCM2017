%绘制已完成任务的会员密度-定价曲线
%调用方法：
%load matlab.mat
%plot_done3(isdone, density, task_pri)
function plot_done3(isdone, density, task_pri)
figure
task_num = size(isdone, 1);
valid_num = sum(isdone,1);
new_density = zeros(valid_num,1);
new_taskpri = zeros(valid_num,1);
count = 1;
for i = 1:task_num
    if isdone(i) == 1
        scatter(density(i), task_pri(i), 5, 3)
        hold on
        new_density(count) = density(i);
        new_taskpri(count) = task_pri(i);
        count = count + 1;
    end
end
b = robustfit(new_density, new_taskpri)
x = linspace(min(new_density), max(new_density), 1000);
y = b(2)*x + b(1);
plot(x, y);

    