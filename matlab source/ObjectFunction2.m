%Ŀ�꺯�������ģʽ�£�
%���÷�����
%load matlab.mat
%[x, p, count, object, payment] = ObjectFunction2(task_distance,package,density,task_credit, task2vip_min, 1/70,  [2.4103, 68.3345])
function [x, p, count, object, payment]  = ObjectFunction2(distance,package,density,task_credit, remote, coeff, solution)
task_num = size(remote, 1);  
p = zeros(size(package,2), 1);
%�������ṹ��Ķ���
for i = 1:size(package,2)   %packageΪ����Ľṹ������
    if package(i).node_num == 1    %��������Ϊ�����������ԭ��������
        num = package(i).rec(1);
        p(i) = solution(1)*task_credit(num)*remote(i) + solution(2);
    else                          %��������Ϊ����������ÿ�������Ķ������ܶȼ���
        p_group = zeros(package(i).node_num, 1);
        for j = 1:package(i).node_num
            num = package(i).rec(j);
            p_group(j) = solution(1)*task_credit(num)/(density(num) + 1) + solution(2);
        end
        p(i) = package(i).node_num * min(p_group); %������Ķ���Ϊ������ͼ۸������ļ۸�n��
    end
end
%Ԥ���������������ɶ�
x = zeros(size(package,2), 1);
count = 0;
com_sum = 0;
for j = 1:size(package,2)
    if package(j).node_num == 1
        if p(j) >  -2.2740*density(j) + 75.2988
           x(j) = 1;
           count = count+ 1;
           com_sum = com_sum + 1;
        end
    else
        internDis = 0;  %��¼��������ڲ������
        orgDis = 0;   %��¼������ĸ����ⲿ�����
        for jj = 1:package(j).node_num - 1
            internDis = internDis + distance(package(j).rec(jj), package(j).rec(jj + 1));
            orgDis = orgDis + remote(package(j).rec(jj));
        end
        orgDis = orgDis + remote(package(j).rec(package(j).node_num));
        if p(j) > 2.0383*(orgDis/package(j).node_num + internDis) + 68.1819  %�ɵ�һ����϶��õľ��붨����
                x(j) = 1;
                count = count+ package(j).node_num;
        end
    end
end
payment = sum(x.*p);
object = count - (task_num - count) - coeff*payment;       %���Ŀ�꺯��������ֵ