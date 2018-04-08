%断链打包
%调用方法：
%load matlab.mat;
%package = packnode(task_pos, sequence, intervalMost, linkmost)
function package = packnode(task_pos, sequence, intervalMost, linkmost)
task_num = size(task_pos, 1);
distance = zeros(task_num, task_num);
%计算任务点两两距离
for i = 1:task_num
    for j = 1:task_num
        distance(i, j) = ((task_pos(i,1) - task_pos(j,1))^2 + (task_pos(i,2) - task_pos(j,2))^2)^(1/2);
    end
end
%打包
pack_number = 0;
count = 1;
pack_node = 1;
record = zeros(task_num, 1);
for i = 1:task_num-1
    %点距超过阈值就切断
    if distance(sequence(i), sequence(i+1)) > intervalMost
        record(i) = count;
        count = count + 1;
        pack_node = 1;
        pack_number = pack_number + 1;
        if i == task_num - 1
            record(i + 1) = count;
            pack_number = pack_number + 1; 
        end
    %点距在阈值之内考虑是否划入相同包
    else
        %当前链节点数小于上限，划入同一子链
        if pack_node < linkmost
            record(i) = count;
            pack_node = pack_node + 1;
            if i == task_num - 1
                record(i + 1) = count;
            end
        %否则切断
        else
            record(i) = count;
            count = count + 1;
            %pack_node = 1;
            pack_number = pack_number + 1;
            if i == task_num - 1
                record(i + 1) = count;
                pack_number = pack_number + 1;
            end
        end
    end
end
%建立任务包的结构体序列
for i =  1:pack_number
    package(i).node_num = 0;
    package(i).first = 0;
end
%记录每个任务包的首个任务序号
for i = 1:task_num
    package(record(i)).node_num = package(record(i)).node_num + 1;
    if package(record(i)).first == 0
        package(record(i)).first = i;
    end
end
%记录每个任务包所有任务序号
for i = 1: pack_number
    num = package(i).node_num;
    package(i).rec = zeros(num,1);
    for j = 1:num
        package(i).rec(j) = sequence(package(record(i)).first + j - 1);
    end
end

    