%数据测试 以及满意度求解
%调用方法：
%load matlab.mat
%[x, p, count, object, Sat1, x2, p2, count2, object2, Sat2, p3, object3, Sat3]= test(test_data, vip_pos_mod, vip_credit, isdone, task_pri, 0.6);
function [x, p, count, object, Sat1, x2, p2, count2, object2, Sat2, p3, object3, Sat3] = test(test_data, vip_pos, vip_credit, isdone, org_task_pri, m)
total = size(test_data,1);    %记录测试数据中任务点总数
task_vip_distance = getAllDist(vip_pos, test_data);   %计算任务点与会员点之间的距离
density = getDensity(task_vip_distance, 0.05);    %计算每个任务点处的会员密度
task_credit = task_credit2(task_vip_distance,vip_credit, 0.05);    %计算每个任务点所在位置的相对地理信誉值
[cluster_dis, minDis, test_idx, center] = vip_cluster(vip_pos, 4, test_data);     %对会员点分布聚类
[x, p, count, object, ~] = ObjectFunction(density,test_data,task_credit, minDis, 1/70, [ -0.9566,75.8729]);     %计算不打包模式下的目标函数值、完成情况和定价。可选[-0.945,75.848]

%不打包模式的商家满意度
Sat11_org = sum(x)/sum(x.*p);  %商家初始满意度表示
disp('无打包模型下软件运营者满意度：')
Sat11 = atan(300*Sat11_org)*2/pi  %商家满意度标准化

%不打包模式的用户满意度
length = zeros(4, 1);    %记录每个聚类总任务点到中心的距离总和
count_clus = zeros(4, 1);    %记录每个聚类中任务数量
Sat12 = zeros(total, 1);   %记录每个任务能提供的满意度
for j = 1:size(vip_pos)
    count_clus(test_idx(j)) = count_clus(test_idx(j)) + 1;
    length(test_idx(j)) = length(test_idx(j)) + cluster_dis(j, test_idx(j));
end          
mean_len = length./count_clus;     %每个聚类中用户前往任务的平均距离
len_cost = 2.0383*mean_len + 68.1819;     %路程代价
res = 0;
for i = 1:total
    Sat12(i) = atan(p(j)/len_cost(test_idx(j)))*2/pi;   %对每一个满意度归一化处理
    res = res + Sat12(i);
end
disp('无打包模型下软件用户满意度：')
Sat12 = res/total    %所有任务为用户提供的综合满意度

n = 1 - m;
disp('无打包模型综合满意度：')
Sat1 = Sat11^m * Sat12^n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%打包模式的满意度计算
distance = task_distance(test_data);  %计算任务点之间的距离
sequence = link(test_data);        %将任务点链接成链
package = packnode(test_data, sequence, 0.02, 4);   %将任务链切断打包
pack_num = size(package,2);           %记录总任务包数
[x2, p2, count2, object2, ~] = ObjectFunction2(distance,package,density,task_credit, minDis, 1/85, [2.41, 68.3345]);   %计算打包模式下的目标函数值

%打包模式的商家满意度
Sat21_org = sum(x2)/sum(x2.*p2);  %商家初始满意度表示
disp('打包模型下软件运营者满意度：')
Sat21 = atan(300 * Sat21_org)*2/pi  %商家满意度标准化

%打包模式下的用户满意度
pack_pos = zeros(pack_num, 2);   %记录任务包的位置坐标点
all_center_distance = zeros(pack_num, 4);   %记录每个任务包到每个会员聚类中心的距离
pack_minDis = zeros(pack_num, 2);       %记录每个任务包到最近会员中心的距离
intern_dis = zeros(pack_num, 1);  %记录每个包的内部距离
length2 = zeros(4, 1);       %记录每个聚类中所有任务到聚类中心的总路程
count_clus2 = zeros(4, 1);  %记录每个聚类中的任务包总数
Sat22 = zeros(pack_num, 1);   %记录每个任务对应的满意度
for i = 1:pack_num    %计算上述各记录矩阵的值
    if package(i).node_num == 1
        pack_pos(i,:) = test_data(package(i).rec(1), :);
    else
        xx = 0;
        yy = 0;
        for j = 1:package(i).node_num
            xx = xx + test_data(package(i).rec(j), 1);
            yy = yy + test_data(package(i).rec(j), 2);
            if j ~= package(i).node_num
                intern_dis(i) = intern_dis(i) + distance(package(i).rec(j), package(i).rec(j + 1));
            end
        end
        %任务包位置按照包中任务的平均坐标值计算
        pack_pos(i:1) = xx/package(i).node_num;  
        pack_pos(i:2) = yy/package(i).node_num;
    end
    for k = 1:4
        all_center_distance(i,k) = ((center(k,1) - pack_pos(i,1))^2 + (center(k,2) - pack_pos(i,2))^2)^(1/2);   %计算每一个任务包到每个聚类中心的距离
    end
    [pack_minDis(i,1), pack_minDis(i,2)] = min(all_center_distance(i, :));   %记录每个任务包到最近聚类中心的距离和所属分类
    length2(pack_minDis(i,2)) = length2(pack_minDis(i,2)) + pack_minDis(i,1);   %记录每个聚类中用户前往任务包的距离和
    count_clus2(pack_minDis(i,2)) = count_clus2(pack_minDis(i,2)) + 1;      %计算每个聚类中任务包的个数
end
mean_len2 = length2./count_clus2;            %计算用户前往任务包的平均距离
len_cost2 = 2.0383*mean_len2 + 68.1819;      %计算路程代价
res2 = 0;
for i = 1:pack_num
    Sat22(i) = atan(p2(i)/len_cost2(pack_minDis(i,2)))*2/pi;     %满意度归一化
    res2 = res2 + Sat22(i);
end
disp('打包模型下软件用户满意度：')
Sat22 = res2/pack_num        %所有任务包为用户提供的综合满意度
%Sat22 = res2/pack_num 
disp('打包模型综合满意度：')
Sat2 = Sat21^m * Sat22^n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%题目中原本的定价策略
%默认模式商家满意度
Sat31_org = sum(isdone)/sum(isdone.*org_task_pri);
disp('题目原定价方案下的运营者满意度：')
Sat31 = atan(300 * Sat31_org)*2/pi   %商家满意度标准化

%默认模式用户满意度
Sat32 = zeros(total, 1);   %记录每个任务能提供的满意度
info = zeros(total, 5);
info(:,1) = test_data(:,1);
info(:,2) = test_data(:,2);
info(:,3) = density;
info(:,4) = minDis;
info(:,5) = task_credit;
weight =  [1.4768,1.4878,-2.2277,1.4454,-0.0985];
p3 = -128.0681 +info* weight';
object3 = Sat31_org * total - (total - Sat31_org) + 1/70*Sat31_org*sum(p3);
res3 = 0;
for i = 1:total
    Sat32(i) = atan(p3(j)/len_cost(test_idx(j)))*2/pi;   %对每一个满意度归一化处理
    res3 = res3 + Sat32(i);
end
disp('题目原定价方案下的用户满意度：')
Sat32 = res3/total    %所有任务为用户提供的综合满意度

n = 1 - m;
disp('题目原定价方案综合满意度：')
Sat3 = Sat31^m * Sat32^n












