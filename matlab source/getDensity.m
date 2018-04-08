%��ָ�������Ļ�Ա�ܶ�
function gd = getDensity(distance, disThresh)
tmp = distance;
task_num = size(distance,1);
vip_num = size(distance,2);
gd = zeros(task_num, 1);
for i = 1:task_num
    count = 0;
    for j = 1:vip_num
        if tmp(i, j) <= disThresh  %�������С����ֵ�����������Χ
            count = count + 1;
        end
    end
    if count == 0
        gd(i,1) = 0;
    else
        gd(i,1) = log(count);  %ȡ��������
    end
end
    