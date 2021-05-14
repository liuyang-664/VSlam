clear;
close all;
clc;
addpath(genpath('.'));
strong_num = 50;


I1=rgb2gray(imread('test4_1.jpg'));
I2=rgb2gray(imread('test4_2.jpg'));
% I1=imread('test1_1.jpg');
% I2=imread('test1_2.jpg');
temp = detectFASTFeatures(I1);
corners1 = temp.selectStrongest(strong_num);
[Descriptor1] = Brief_Descriptor(I1,flipud(corners1.Location'));

temp = detectFASTFeatures(I2);
corners2 = temp.selectStrongest(strong_num);
[Descriptor2] = Brief_Descriptor(I2,flipud(corners2.Location'));

% matches = findmatches(Descriptor1', Descriptor2',flipud(corners1.Location),flipud(corners2.Location));
matches = findmatches(Descriptor1', Descriptor2',corners1.Location,corners2.Location);

[m1,n1] = size(I1);
[m2,n2] = size(I2);
combine_img = zeros(max(m1,m2),n1+n2,'uint8');
combine_img(1:m1,1:n1) = I1;
combine_img(1:m2,n1+1:end) = I2;

figure(1)
imshow(combine_img); hold on;
scatter(corners1.Location(:,1),corners1.Location(:,2),'gx');
scatter(corners2.Location(:,1)+n1,corners2.Location(:,2),'gx');

for i =1:size(matches,1)
    plot([matches(i,1),matches(i,3)+n1],[matches(i,2),matches(i,4)],...
        'linewidth',1.5);
end

% figure(2)
% imshow(I2); hold on;
% scatter(corners2.Location(:,1),corners2.Location(:,2),'gx');


%match check
position = 30;
x1 = matches(i,1);
y1 = matches(i,2);
x2 = matches(i,3);
y2 = matches(i,4);

num1 = find(corners1.Location(:,1)==x1 & corners1.Location(:,2)==y1);
num2 = find(corners2.Location(:,1)==x2 & corners2.Location(:,2)==y2);

test_dis = sum(abs(Descriptor1(:,num1)-Descriptor2(:,num2)));
min_dis = min(sum(abs(Descriptor1(:,num1)-Descriptor2)));


rmpath(genpath('.'));
