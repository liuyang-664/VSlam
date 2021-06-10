function matchedIdx = findmatches(des1, des2)
%des是img的描述子，大小为n*256，采用二进制描述子

[idx1,dist1]= knnsearch(des2,des1,'K',2,'Distance','hamming'); %采用最近邻算法匹配特征点，K表示在des2中寻找des1每一行向量的K个匹配点
[idx2,~]= knnsearch(des1,des2,'K',2,'Distance','hamming'); %在des1中寻找des2的K个匹配点,~ expresses doesn't return the second value

matches = zeros(size(des1,1),2);
for i = 1:size(des1,1)
    if (dist1(i,1) <= 64/256 && dist1(i,1)/dist1(i,2) <=0.98 && i == idx2(idx1(i,1),1))
        % hamming distance < 0.25 + ratio between smallest and second
        % smallest < 0.98  and cross minimum value check 
        matches(i,:) = [i, idx1(i,1)];
    end
end

% 删除未匹配到的元素
matchedIdx = matches(find(matches(:,1) > 0), :);
end