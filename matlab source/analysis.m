%�����̼Ҷ���Ϊʲô����������δ�����
%���� ά�� ��Ա�ܶ� ��Ե��������� ����㵽����������̾���
%���÷�ʽ��
%load matlab.mat
%analysis(task_pos, task_pri,task_credit, density, task2vip_min, isdone)
function analysis(task_pos, task_pri,task_credit, vip_density, minDis, isdone)
%�����Ա����������
analysis1 = zeros(size(task_pos,1), 5);
analysis1(:,1) = task_pos(:,1);
analysis1(:,2) = task_pos(:,2);
analysis1(:,3) = vip_density;
analysis1(:,4) = task_credit;
analysis1(:,5) = minDis;
[b,stats] = robustfit(analysis1,task_pri)

valid_num = sum(isdone,1);
analysis2 = zeros(valid_num, 5);
valid_pri = zeros(valid_num, 1);
count = 1;
for i = 1:size(task_pos,1)
    if isdone(i) == 1
        analysis2(count,1) = task_pos(i,1);
        analysis2(count,2) = task_pos(i,2);
        analysis2(count,3) = vip_density(i);
        analysis2(count,4) = task_credit(i);
        analysis2(count,5) = minDis(i);
        valid_pri(count) = task_pri(i);
        count = count + 1;
    end
end
[b2,stats2] = robustfit(analysis2,valid_pri)