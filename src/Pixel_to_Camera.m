function Points_camera1 = Pixel_to_Camera(Points_pix1, Points_pix2)
%conversion of cooridinates
%the size of Points_pix is n*2, Points_cameral is n*3
%Points_pix1 and Points_pix2 is the feature points in left or right image
global Params

%use parallax method based on binocular camera
K = Params.cameraParams1.IntrinsicMatrix;
fx1 = K(1,1);
fx2 =  Params.cameraParams2.IntrinsicMatrix(1,1);
b = 0.11007784;
Z = (fx1+fx2)/2 ./ abs(Points_pix1(:,2)-Points_pix2(:,2));

Points = [Points_pix1, ones(length(Points_pix1,1), 1];
Points_camera1 = Z .* (Points * inv(K));
end



