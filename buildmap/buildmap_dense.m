
width = 640;
height = 480;
num_point = 307200;

dir = 'E:\dataset\test_data';
img_name = 'scene_000';
img1 = imread([dir,'\images\',img_name,'.png']);
img1_depth = load([dir,'\depthmaps\',img_name,'.depth']);
img1_depth = reshape(img1_depth,[height,width]);

% [x,y] = meshgrid(1:height,1:width);
% scatter3(reshape(x,[num_point,1]),reshape(y,[num_point,1]),...
%     reshape(img1_depth',[num_point,1]),'filled')