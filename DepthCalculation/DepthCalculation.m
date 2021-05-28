function z=DepthCalculation(a0,a1)
% a0 stands for the pixel coordinate within cam0 (size:n*2)
% a1 stands for the pixel coordinate within cam1 (size:n*2)
clear;
clc;
% Cam0toIMU=[0.0148655429818, -0.999880929698, 0.00414029679422, -0.0216401454975
%          0.999557249008, 0.0149672133247, 0.025715529948, -0.064676986768
%         -0.0257744366974, 0.00375618835797, 0.999660727178, 0.00981073058949
%          0.0, 0.0, 0.0, 1.0];
% Cam1toIMU=[0.0125552670891, -0.999755099723, 0.0182237714554, -0.0198435579556
%          0.999598781151, 0.0130119051815, 0.0251588363115, 0.0453689425024
%         -0.0253898008918, 0.0179005838253, 0.999517347078, 0.00786212447038
%          0.0, 0.0, 0.0, 1.0];
% % Cam0toIMU stands for the coordinate transformation matrix from Cam0 to IMU
% B=sqrt((Cam0toIMU(1,4)-Cam1toIMU(1,4))^2+(Cam0toIMU(2,4)-Cam1toIMU(2,4))^2+(Cam0toIMU(3,4)-Cam1toIMU(3,4))^2);
B = 0.11007784;
Cam0Intr=[461.2051,459.6422,365.0267,250.3201];
Cam1Intr=[460.9561,460.3954,376.2752,256.5650];
% To array above stands for [fx,fy,cx,cy]
z=B*(Cam0Intr(1)+Cam1Intr(1))/2 ./ (a0(:,2)-a1(:,2));
end


