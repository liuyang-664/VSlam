clear;clc;
%储存图像数据路径
video_path = 'E:\dataset\ethdataset\video';
%读取cam0图像的名称
file_id = fopen([video_path,'\mav0\cam0\data.csv']);
img_name_data = textscan(file_id, '%s%s', 'Delimiter', ',', 'HeaderLines', 1 );
fclose(file_id);
total_num_img = size(img_name_data{2},1);
%读取第i张图片

for i = 1:total_num_img
    img_name = char(img_name_data{2}(i));
    I1 = imread([video_path,'\mav0\cam0\data\',img_name]);
    imshow(I1);
end