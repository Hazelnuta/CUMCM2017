%�ýṹ��record��¼ÿ��������е��������
%���÷�����
%load matlab.mat
%record = record_pack(package, 4)
function record = record_pack(package, num)
for i = 1:num
    ss = '';
    for j = 1:package(i).node_num
        if package(i).rec(j) ~= 0
            ss = strcat(ss ,num2str(package(i).rec(j)));
            if j < package(i).node_num
                ss = strcat(ss ,', ');
            end
        end
    end
    record(i).content = ss;
end