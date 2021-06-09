clear;clc;
%R:rot matrix from camera to ground
%t:trans matrix from camera to ground
%FP_cam_pos:feature point postion in camera coordinate system
n = 100;
FP_pos = zeros(3,n);
for i = 1:n
    R = eye(3);
    t = [1;1;1];
    FP_cam_pos = [1;2;3];
    FP_pos(:,i) = R*FP_cam_pos+t;
end



% function FP_pos = get_FP_pos(R,t,FP_cam_pos)
% %R:rot matrix from camera to ground
% %t:trans matrix from camera to ground
% %FP_cam_pos:feature point postion in camera coordinate system
% 
% % t = reshape(t,[3,1]);
% % FP_cam_pos = reshape(FP_cam_pos,[3,1]);
% % T = [R t;0 0 01];
% % pos_cam = [FP_cam_pos;1];
% % pos_ground = T*pos_cam;
% % FP_pos = pos_ground(1:3);
% FP_pos = R*FP_cam_pos+t;
% end
