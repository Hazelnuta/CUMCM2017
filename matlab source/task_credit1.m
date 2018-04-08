%根据会员分布得到指定地点的相对信誉值(模型最终采用方法为task_credit2）
function tc = task_credit1(distance,vip_credit, localVip)
tmp = distance;
task_num = size(distance,1);
tc = zeros(task_num, 1);
for i = 1:task_num
    sum = 0;
    for j = 1:localVip
        [~,mpos] = min(tmp(i,:));
        sum = sum + log(vip_credit(mpos));
        tmp(i, mpos) = max(tmp(i,:));
    end
    tc(i) = sum/localVip;
end

