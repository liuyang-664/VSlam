function [Descriptor] = Brief_Descriptor(img,FP)
%Descriptor:1*size(FP,2)
size_x = size(img,1);
size_y = size(img,2);
img2 = GaussianFilter(img);
center = floor(size(img2)./2);%图片中心
numFP = size(FP,2);
run('sampling_param.m') %包含采样点信�?

Descriptor = zeros(256,numFP);
angle = zeros(1,numFP);

for i = 1:numFP
    %对于任意�?个特征点
    img_range = img2(max(FP(1,i)-15,1):min(FP(1,i)+15,size_x),...
        max(FP(2,i)-15,1):min(FP(2,i)+15,size_y));
    [x,y] = getcenter(img_range);
    img_range_center = [FP(1,i)-15+x,FP(2,i)-15+y];
    angle(i) = atan2((center(2)-img_range_center(2)),(center(1)-img_range_center(1)));
    pattern1 = round([cos(angle(i)),-sin(angle(i));sin(angle(i)),cos(angle(i))]*sample(:,1:2)'); 
    pattern2 = round([cos(angle(i)),-sin(angle(i));sin(angle(i)),cos(angle(i))]*sample(:,3:4)');
    for j = 1:256
        p1 = img2(min(max(FP(1,i) + pattern1(1,j),1),size_x),...
            min(max(FP(2,i) + pattern1(2,j),1),size_y));
        p2 = img2(min(max(FP(1,i) + pattern2(1,j),1),size_x),...
            min(max(FP(2,i) + pattern2(2,j),1),size_y));
%         temple = temple+(p1<p2)*2^(j-1);
        Descriptor(j,i) = p1<p2;
    end
%     Descriptor = temple;
end
end
