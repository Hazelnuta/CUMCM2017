%����ȫ����������Ļ�Ա�ܶ�-��������
function plot_done2(isdone, density, task_pri)
figure
task_num = size(isdone, 1);
for i = 1:task_num
    scatter(density(i), task_pri(i), 5, 3)
    hold on
end
b = robustfit(density, task_pri)
x = linspace(min(density), max(density), 1000);
y = b(2)*x + b(1);
plot(x, y);

    