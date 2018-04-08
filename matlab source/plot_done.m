%绘制已完成任务的距离-定价曲线
%调用方法：
%load matlab.mat
%plot_done(isdone, task2vip_min, task_pri)
function plot_done(isdone, mindis, task_pri)
figure
task_num = size(isdone, 1);
for i = 1:task_num
    if isdone(i)== 1
        scatter(mindis(i), task_pri(i), 5, 3)
        hold on
    end
end

    