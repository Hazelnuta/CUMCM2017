%任务成链
%调用方法：
%load matlab.mat
% sequence = link(task_pos)
function sequence = link(task_pos)
task_num = size(task_pos,1);
distance = zeros(task_num, task_num);
%计算任务点两两距离
for i = 1:task_num
    for j = 1:task_num
        distance(i, j) = ((task_pos(i,1) - task_pos(j,1))^2 + (task_pos(i,2) - task_pos(j,2))^2)^(1/2);  
    end
end
count_all = 1;
sequence = zeros(task_num, 1);
flag = zeros(task_num, 1);
i = 1;
sequence(count_all) = i;
flag(1) = 1;
while count_all < task_num
    %贪心法成链
    [~, minpos] = min(distance(i,:));
    if flag(minpos) == 0
        count_all = count_all + 1;
        sequence(count_all) = minpos;
        i = minpos;
        flag(minpos) = 1;
        distance(i,minpos) = inf;
    else
        distance(i,minpos) = inf;
    end
end
    
    