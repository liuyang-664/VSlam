clear;clc;
% load Map03_2271images_kitti.mat
load Map01_850images_ethdataSet.mat
Map03_2271images = Map01_850images_ethdataset;
%%
%R:rot matrix from camera to ground
%t:trans matrix from camera to ground
%FP_cam_pos:feature point postion in camera coordinate system

% n = 2270;
n = 850
FP_pos = [];
for i = 1:n
    FP_cam_pos =  Map03_2271images.PointsCamera{1,i};
    m = size(FP_cam_pos,1);
    temp = zeros(m,3);%当前特征点位置
    
    for j = 1:m
        R = Map03_2271images.Views.Orientation{j};
        t = Map03_2271images.Views.Location{j};
        temp(j,:) = (R*FP_cam_pos(j,:)' + t')';
    end
    FP_pos = [FP_pos;temp];
end
%%
ptCloud = pointCloud(FP_pos);
% cmatrix = ones(size(ptCloud.Location)).*[1 0.5 0]; %颜色矩阵
% ptCloud = pointCloud(FP_pos,'Color',cmatrix);
pcshow(ptCloud)
hold on
temp = cell2mat(Map03_2271images.Views.Location);
temp(:,3) = 60;
ptCloud2 = pointCloud(temp);
cmatrix = ones(size(ptCloud2.Location)).*[1 0.5 0]; %颜色矩阵
ptCloud2 = pointCloud(temp,'Color',cmatrix);
pcshow(ptCloud2)
