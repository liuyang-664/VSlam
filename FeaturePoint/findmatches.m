function matches = findmatches(des1, des2,corner1,corner2)
%des是img的描述子，大小为n*256，采用二进制描述子
%corner是特征点的像素坐标，大小为n*2

[idx1,dist1]= knnsearch(des2,des1,'K',2,'Distance','hamming'); %采用最近邻算法匹配特征点，K表示在des2中寻找des1每一行向量的K个匹配点
[idx2,~]= knnsearch(des1,des2,'K',2,'Distance','hamming'); %在des1中寻找des2的K个匹配点

matches = zeros(size(des1,1),4);
for i = 1:size(des1,1)
    if (dist1(i,1) <= 64/256 && dist1(i,1)/dist1(i,2) <=0.98 && i == idx2(idx1(i,1),1))
        % hamming distance < 0.25 + ratio between smallest and second
        % smallest < 0.98  and cross minimum value check 
        matches(i,:) = [corner1(i,:),corner2(idx1(i,1),:)];
    end
end

% 删除未匹配到的元素
filter = find(matches(:,1));
matches = matches(filter,:); %match中前两列为img1的特征点坐标，后两列为匹配到的img2的特征点坐标