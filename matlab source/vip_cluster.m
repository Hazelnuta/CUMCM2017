%��Ա���࣬������ÿ������㵽�����������ĵľ��룬�Լ���̾���
%���÷�����
%load matlab.mat��
%[task2vip, task2vip_min, vip_idx, vip_C] = vip_cluster(vip_pos, k, task_pos);
function  [distance, minDis, idx, C] = vip_cluster(vip_pos, k, task_pos)
[idx,C, ~, ~] = kmeans(vip_pos,k);
task_num = size(task_pos, 1);
vip_num =  size(vip_pos, 1);
figure
for ii = 1:vip_num
    scatter(vip_pos(ii,2), vip_pos(ii,1), 5, idx(ii)*3);
    hold on
end
distance = zeros(task_num, k);
for i = 1:task_num
    for j = 1:k
        distance(i, j) = ((task_pos(i,1) - C(j,1))^2 + (task_pos(i,2) - C(j,2))^2)^(1/2);
    end
end
minDis = zeros(task_num, 1);
for i = 1:task_num
    minDis(i) = min(distance(i));
end
    
