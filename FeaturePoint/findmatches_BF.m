function [matchedPoints1 matchedPoints2] = findmatches_BF(des1, des2,corner1,corner2)
%des是img的描述子，大小为n*256，采用二进制描述子
%corner是特征点的像素坐标，大小为n*2
n = size(des1,1);

%利用暴力匹配法在des2中寻找离des1每一行向量最近的2个匹配点
idx1 = zeros(n,2);
dist1 = idx1;
for i = 1:n
    minD1 = sum(double(xor(des1(i,:), des2(1,:)))); index1 = 1;
    tmpD = sum(double(xor(des1(i,:), des2(2,:))));
    if tmpD < minD1
        minD2 = minD1;
        minD1 = tmpD;
        index1 = 2;
        index2 = 1;
    else
        minD2 = tmpD;
        index2 = 2;
    end
    for j = 3:n
        tmpD = sum(double(xor(des1(i,:), des2(j,:))));
        if tmpD < minD1
            minD2 = minD1;
            minD1 = tmpD;
            index1 = j;
        elseif tmpD < minD2
            minD2 = tmpD;
            index2 = j;
        end
    end
    
    idx1(i,1) = index1;
    idx1(i,2) = index2;
    dist1(i,1) = minD1;
    dist1(i,2) = minD2;
end

%利用暴力匹配法在des1中寻找离des2每一行向量最近的2个匹配点
idx2 = zeros(n,2);
dist2 = idx1;
for i = 1:n
    minD1 = sum(double(xor(des2(i,:), des1(1,:)))); index1 = 1;
    tmpD = sum(double(xor(des2(i,:), des1(2,:))));
    if tmpD < minD1
        minD2 = minD1;
        minD1 = tmpD;
        index1 = 2;
        index2 = 1;
    else
        minD2 = tmpD;
        index2 = 2;
    end
    for j = 3:n
        tmpD = sum(double(xor(des2(i,:), des1(j,:))));
        if tmpD < minD1
            minD2 = minD1;
            minD1 = tmpD;
            index1 = j;
        elseif tmpD < minD2
            minD2 = tmpD;
            index2 = j;
        end
    end
    
    idx2(i,1) = index1;
    idx2(i,2) = index2;
    dist2(i,1) = minD1;
    dist2(i,2) = minD2;
end

matches = zeros(n,4);
for i = 1:n
    if (dist1(i,1) <= 64 && dist1(i,1)/dist1(i,2) <=0.98 && i == idx2(idx1(i,1),1))
        % hamming distance < 0.25 + ratio between smallest and second
        % smallest < 0.98  and cross minimum value check 
        matches(i,:) = [corner1(i,:),corner2(idx1(i,1),:)];
    end
end

% 删除未匹配到的元素
filter = find(matches(:,1));
matchedPoints1 = matches(filter,1:2); %the coordinate of feature corrner in img1
matchedPoints2 = matches(filter,3:4); %the coordinate of feature corrner in img2

end