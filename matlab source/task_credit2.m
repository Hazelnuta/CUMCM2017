%根据会员分布得到指定地点的相对信誉值
function tc = task_credit2(distance,vip_credit, disThresh)
tmp = distance;
task_num = size(distance,1);
vip_num = size(distance,2);
tc = zeros(task_num, 1);
for i = 1:task_num
    count = 0;
    sum = 0;
    for j = 1:vip_num
        if tmp(i, j) <= disThresh  %任务与会员距离在阈值内，则加入计数
            count = count + 1;
            sum = sum + log(vip_credit(j));
        end
    end
    if count > 0
        tc(i) = sum/count;
    else
        tc(i) = 0;
    end
end
tc_min = min(tc);
for i = 1:task_num
    if tc(i) ~= 0
        tc(i) = tc(i) - tc_min;
    end
end

