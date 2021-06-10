%ICP_SVDMethod.m
function [R t] = ICP_SVDMethod(P1,P2)
%P1为某一点在相机坐标系下的位置，每一行为一个点的坐标
%P2为相机改变姿态后该点在新相机坐标系下的位置
%寻找最优的旋转矩阵R和平移向量t，使得p2 = R*p1 + t

if size(P1) ~= size(P2)
    fprintf('运算错误，输入两组点的矩阵大小不相等！\n')
    return
elseif size(P1,2) ~= 3
    fprintf('运算错误，输入两组点的矩阵的每一行不是空间三维坐标！\n')
    return
end

%计算两组点的质心
p1_mean = mean(P1);
p2_mean = mean(P2);
%计算去质心坐标
Q1 = P1 - p1_mean;
Q2 = P2 - p2_mean;

%寻找最优的旋转矩阵R和平移向量t
W = zeros(3);
for i = 1:size(Q1,1)
    W = W + Q2(i,:)' * Q1(i,:);
end
[U,S,V] = svd(W);
R = U*V';
if det(R) < 0
    R = -R;
end

t = p2_mean' - R*p1_mean';

end

    
