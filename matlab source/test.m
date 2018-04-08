%���ݲ��� �Լ���������
%���÷�����
%load matlab.mat
%[x, p, count, object, Sat1, x2, p2, count2, object2, Sat2, p3, object3, Sat3]= test(test_data, vip_pos_mod, vip_credit, isdone, task_pri, 0.6);
function [x, p, count, object, Sat1, x2, p2, count2, object2, Sat2, p3, object3, Sat3] = test(test_data, vip_pos, vip_credit, isdone, org_task_pri, m)
total = size(test_data,1);    %��¼�������������������
task_vip_distance = getAllDist(vip_pos, test_data);   %������������Ա��֮��ľ���
density = getDensity(task_vip_distance, 0.05);    %����ÿ������㴦�Ļ�Ա�ܶ�
task_credit = task_credit2(task_vip_distance,vip_credit, 0.05);    %����ÿ�����������λ�õ���Ե�������ֵ
[cluster_dis, minDis, test_idx, center] = vip_cluster(vip_pos, 4, test_data);     %�Ի�Ա��ֲ�����
[x, p, count, object, ~] = ObjectFunction(density,test_data,task_credit, minDis, 1/70, [ -0.9566,75.8729]);     %���㲻���ģʽ�µ�Ŀ�꺯��ֵ���������Ͷ��ۡ���ѡ[-0.945,75.848]

%�����ģʽ���̼������
Sat11_org = sum(x)/sum(x.*p);  %�̼ҳ�ʼ����ȱ�ʾ
disp('�޴��ģ���������Ӫ������ȣ�')
Sat11 = atan(300*Sat11_org)*2/pi  %�̼�����ȱ�׼��

%�����ģʽ���û������
length = zeros(4, 1);    %��¼ÿ������������㵽���ĵľ����ܺ�
count_clus = zeros(4, 1);    %��¼ÿ����������������
Sat12 = zeros(total, 1);   %��¼ÿ���������ṩ�������
for j = 1:size(vip_pos)
    count_clus(test_idx(j)) = count_clus(test_idx(j)) + 1;
    length(test_idx(j)) = length(test_idx(j)) + cluster_dis(j, test_idx(j));
end          
mean_len = length./count_clus;     %ÿ���������û�ǰ�������ƽ������
len_cost = 2.0383*mean_len + 68.1819;     %·�̴���
res = 0;
for i = 1:total
    Sat12(i) = atan(p(j)/len_cost(test_idx(j)))*2/pi;   %��ÿһ������ȹ�һ������
    res = res + Sat12(i);
end
disp('�޴��ģ��������û�����ȣ�')
Sat12 = res/total    %��������Ϊ�û��ṩ���ۺ������

n = 1 - m;
disp('�޴��ģ���ۺ�����ȣ�')
Sat1 = Sat11^m * Sat12^n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ģʽ������ȼ���
distance = task_distance(test_data);  %���������֮��ľ���
sequence = link(test_data);        %����������ӳ���
package = packnode(test_data, sequence, 0.02, 4);   %���������жϴ��
pack_num = size(package,2);           %��¼���������
[x2, p2, count2, object2, ~] = ObjectFunction2(distance,package,density,task_credit, minDis, 1/85, [2.41, 68.3345]);   %������ģʽ�µ�Ŀ�꺯��ֵ

%���ģʽ���̼������
Sat21_org = sum(x2)/sum(x2.*p2);  %�̼ҳ�ʼ����ȱ�ʾ
disp('���ģ���������Ӫ������ȣ�')
Sat21 = atan(300 * Sat21_org)*2/pi  %�̼�����ȱ�׼��

%���ģʽ�µ��û������
pack_pos = zeros(pack_num, 2);   %��¼�������λ�������
all_center_distance = zeros(pack_num, 4);   %��¼ÿ���������ÿ����Ա�������ĵľ���
pack_minDis = zeros(pack_num, 2);       %��¼ÿ��������������Ա���ĵľ���
intern_dis = zeros(pack_num, 1);  %��¼ÿ�������ڲ�����
length2 = zeros(4, 1);       %��¼ÿ���������������񵽾������ĵ���·��
count_clus2 = zeros(4, 1);  %��¼ÿ�������е����������
Sat22 = zeros(pack_num, 1);   %��¼ÿ�������Ӧ�������
for i = 1:pack_num    %������������¼�����ֵ
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
        %�����λ�ð��հ��������ƽ������ֵ����
        pack_pos(i:1) = xx/package(i).node_num;  
        pack_pos(i:2) = yy/package(i).node_num;
    end
    for k = 1:4
        all_center_distance(i,k) = ((center(k,1) - pack_pos(i,1))^2 + (center(k,2) - pack_pos(i,2))^2)^(1/2);   %����ÿһ���������ÿ���������ĵľ���
    end
    [pack_minDis(i,1), pack_minDis(i,2)] = min(all_center_distance(i, :));   %��¼ÿ�������������������ĵľ������������
    length2(pack_minDis(i,2)) = length2(pack_minDis(i,2)) + pack_minDis(i,1);   %��¼ÿ���������û�ǰ��������ľ����
    count_clus2(pack_minDis(i,2)) = count_clus2(pack_minDis(i,2)) + 1;      %����ÿ��������������ĸ���
end
mean_len2 = length2./count_clus2;            %�����û�ǰ���������ƽ������
len_cost2 = 2.0383*mean_len2 + 68.1819;      %����·�̴���
res2 = 0;
for i = 1:pack_num
    Sat22(i) = atan(p2(i)/len_cost2(pack_minDis(i,2)))*2/pi;     %����ȹ�һ��
    res2 = res2 + Sat22(i);
end
disp('���ģ��������û�����ȣ�')
Sat22 = res2/pack_num        %���������Ϊ�û��ṩ���ۺ������
%Sat22 = res2/pack_num 
disp('���ģ���ۺ�����ȣ�')
Sat2 = Sat21^m * Sat22^n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ŀ��ԭ���Ķ��۲���
%Ĭ��ģʽ�̼������
Sat31_org = sum(isdone)/sum(isdone.*org_task_pri);
disp('��Ŀԭ���۷����µ���Ӫ������ȣ�')
Sat31 = atan(300 * Sat31_org)*2/pi   %�̼�����ȱ�׼��

%Ĭ��ģʽ�û������
Sat32 = zeros(total, 1);   %��¼ÿ���������ṩ�������
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
    Sat32(i) = atan(p3(j)/len_cost(test_idx(j)))*2/pi;   %��ÿһ������ȹ�һ������
    res3 = res3 + Sat32(i);
end
disp('��Ŀԭ���۷����µ��û�����ȣ�')
Sat32 = res3/total    %��������Ϊ�û��ṩ���ۺ������

n = 1 - m;
disp('��Ŀԭ���۷����ۺ�����ȣ�')
Sat3 = Sat31^m * Sat32^n












