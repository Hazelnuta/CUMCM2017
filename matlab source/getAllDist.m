%获得任务点和会员两两之间的距离矩阵
function distance = getAllDist(vip_pos, task_pos)
vip_num = size(vip_pos,1);
task_num = size(task_pos,1);
distance = zeros(task_num, vip_num);
for i = 1:task_num
    for j = 1:vip_num
        distance(i, j) = ((task_pos(i,1) - vip_pos(j,1))^2 + (task_pos(i,2) - vip_pos(j,2))^2)^(1/2);
    end
end

        