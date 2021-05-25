clear all;
clc;
K=[365.7892         0         379.2910
    0  322.5410      240.8674
    0  0    1.0000];
D=[   -0.3462    0.1356];
% rootFolder = fullfile('C:\Users\MAC\Desktop\matlabhw\SLAM\test');
% imgSets = imageSet(rootFolder);
% count=imgSets.Count(1,1);
img=imread('C:\Users\MAC\Desktop\matlabhw\SLAM\Figure_BeforeCalibration\test2_1.jpg');
img_gray = rgb2gray(img);
% for i=1:count
undistorted_img=myundistortImage(img_gray,K,D);
imwrite(undistorted_img,'.\Figure_AfterCalibration\test2_1.jpg');
% end