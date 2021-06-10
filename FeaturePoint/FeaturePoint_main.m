clear;
close all;
clc;
addpath(genpath('.'));
strong_num = 50;

I01=imread('../dataset/test/00/image_0/000000.png');
I02=imread('../dataset/test/00/image_0/000002.png');
I11=imread('../dataset/test/00/image_1/000000.png');
I12=imread('../dataset/test/00/image_1/000002.png');
% I1=rgb2gray(imread('test1_1.jpg'));
% I2=rgb2gray(imread('test1_2.jpg'));

[Points01, Descriptor01] = ExtractFeatures(I01);
[Points02, Descriptor02] = ExtractFeatures(I02);
[Points11, Descriptor11] = ExtractFeatures(I11);
[Points12, Descriptor12] = ExtractFeatures(I12);

%寻找特征点匹配对
matchedIdx1 = findmatches(Descriptor01', Descriptor02');
matchedPoints1 = Points01(matchedIdx1(:,1), :);
matchedDescriptor1 = Descriptor01(:, matchedIdx1(:,1));
matchedPoints2 = Points02(matchedIdx1(:,2), :);
matchedDescriptor2 = Descriptor02(:, matchedIdx1(:,2));

matchedIdx2 = findmatches(matchedDescriptor1', Descriptor11');
matchedIdx3 = findmatches(matchedDescriptor2', Descriptor12');
filter = intersect(matchedIdx2(:,1), matchedIdx3(:,1));

matchedPoints1 = matchedPoints1(filter,:);
matchedPoints2 = matchedPoints2(filter,:);

[m1,n1] = size(I01);
[m2,n2] = size(I02);
combine_img = zeros(max(m1,m2),n1+n2,'uint8');
combine_img(1:m1,1:n1) = I01;
combine_img(1:m2,n1+1:end) = I02;

figure(1)
imshow(combine_img); hold on;
scatter(matchedPoints1(:,1),matchedPoints1(:,2),'gx');
scatter(matchedPoints2(:,1)+n1,matchedPoints2(:,2),'gx');
% scatter(0,0,'rx');
% plot([0 0], [0, 100], 'b','linewidth',1.5 ); %test Image coordinate
% system
for i =1:size(filter,1)
    plot([matchedPoints1(i,1),matchedPoints2(i,1)+n1],[matchedPoints1(i,2),matchedPoints2(i,2)],...
        'linewidth',1.5);
end

% figure(2)
% imshow(I2); hold on;
% scatter(corners2.Location(:,1),corners2.Location(:,2),'gx');


%match check
% position = 30;
% x1 = matchedPoints1(i,1);
% y1 = matchedPoints1(i,2);
% x2 = matchedPoints2(i,1);
% y2 = matchedPoints2(i,2);
% 
% num1 = find(Points01(:,1)==x1 & Points01(:,2)==y1);
% num2 = find(Points02(:,1)==x2 & Points02(:,2)==y2);
% 
% test_dis = sum(abs(Descriptor1(:,num1)-Descriptor2(:,num2)));
% min_dis = min(sum(abs(Descriptor1(:,num1)-Descriptor2)));


rmpath(genpath('.'));
