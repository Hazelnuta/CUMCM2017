%计算所有任务点两两之间的距离
%调用方法：
%task_distance = task_distance(task_pos)；
function td = task_distance(task_pos)
task_num = size(task_pos,1);
td = zeros(task_num, task_num);
for i = 1:task_num
    for j = 1:task_num
        td(i, j) = ((task_pos(i,1) - task_pos(j,1))^2 + (task_pos(i,2) - task_pos(j,2))^2)^(1/2);
    end
end