tic;
clear;
dir1 = '.\Figure_Test_BeforeCalibration\';
dir2 = '.\\Figure_Test_BeforeCalibration\\%s';
dir3  = '.\\Figure_Test_AfterCalibration\\%s';
cam1_cali_data = CameraDistortionProcess(dir1,dir2,dir3);

save('cam1_cali_data.mat','cam1_cali_data')

toc