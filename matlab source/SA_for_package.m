%���ģʽ�µ�Ŀ���Ż�ģ�ͣ�ʹ���˻��㷨��
%���÷�����
%load matlab.mat;
% [p, alpha, beta] = SA_for_package(task_distance, package, density,task_credit, task2vip_min, 1/70, 0.5, 1,80)
function [p, alpha, beta] = SA_for_package(distance, package, density,task_credit, remote, coeff, StepFactor, start1, start2)
MarkovLength=100; % ��ɷ�������
DecayScale=0.95; % ˥������ 
Temperature0=100; % ��ʼ�¶�
Temperatureend=1; % �����¶�
Boltzmann_con=1; % Boltzmann����
AcceptPoints=0.0; % Metropolis�������ܽ��ܵ�
% �����ʼ������
Par_cur=[start1, start2]; % ��Par_cur��ʾ��ǰ��
%Par_best_cur = Par_cur; % ��Par_best_cur��ʾ��ǰ���Ž�
Par_best=Par_cur; % ��Par_best��ʾ��ȴ�е���ý�
Par_new = Par_cur;
% ÿ����һ���˻�(����)һ�Σ�ֱ�������������Ϊֹ
t=Temperature0;
alpha = start1;
beta = start2;
itr_num=0; % ��¼��������
while t>Temperatureend
    itr_num=itr_num+1;
    t = DecayScale*t;  % �¶ȸ��£�����)
    for i=1:MarkovLength
        % �ڴ˵�ǰ�����㸽�����ѡ��һ��
        Par_new(1) = Par_cur(1) + StepFactor*(rand(1) - 0.5);
        Par_new(2) = Par_cur(2) + StepFactor*(rand(1) - 0.5);
        % ���鵱ǰ���Ƿ�Ϊȫ�����Ž�
        if (ObjectFunction(distance,package, density,task_credit, remote, coeff,Par_best)<...
                ObjectFunction(distance,package,density,task_credit, remote, coeff,Par_new))
            % ��Ϊ�µ����Ž�
            Par_best=Par_new;
        end
        % Metropolis����
        if (ObjectFunction(distance,package,density,task_credit, remote, coeff,Par_cur)<...
                ObjectFunction(distance,package,density,task_credit, remote, coeff,Par_new))
            % �����½�
            Par_cur=Par_new;
            AcceptPoints=AcceptPoints+1;
        else
            changer=(ObjectFunction(distance,package,density,task_credit, remote, coeff, Par_new)-...
            ObjectFunction(distance,package,density,task_credit, remote, coeff, Par_cur))/(Boltzmann_con*t);
            p1 = exp(changer);      %���ܸ���
            if p1>rand(1)
                Par_cur=Par_new;
                AcceptPoints=AcceptPoints+1;
            end
        end
        alpha = Par_best(1); %���µ�ǰ����ֵ
        beta = Par_best(2);
    end
end
%�������Ž��µ�Ŀ�꺯�����Լ���������
[~, p, ~, ~, ~]  = ObjectFunction2(distance,package,density,task_credit, remote, coeff, Par_best);
