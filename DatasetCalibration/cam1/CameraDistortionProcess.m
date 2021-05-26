function [cameraParams]=CameraDistortionProcess(imgDir1,imgDir2,imgDir3)
% imgDir1='.\Figure_Test_BeforeCalibration\';
% imgDir2='.\\Figure_Test_BeforeCalibration\\%s';
% imgDir3='.\\Figure_Test_AfterCalibration\\%s';
% The format of the input should be like these three path shown above.
% imgDir1 stands for the path where images need to be processed.
% imgDir2 means the same as imgDir1, but it is used for image-reading.
% imgDir3 stands for which Folder the user wants the processed image to be
% stored.
% Define images to process

imageFileNames = {'.\Figure_Test_BeforeCalibration\1403709007337837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709010887836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709013987836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709019887836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709028337837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709033337837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709041337837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709046887836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709068237837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709068887836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709072887836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709074387836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709078837837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709083387836928.png',...
    '.\Figure_Test_BeforeCalibration\1403709086037837056.png',...
    '.\Figure_Test_BeforeCalibration\1403709087387836928.png',...
    };
% Detect checkerboards in images
[imagePoints,boardSize,imagesUsed]=detectCheckerboardPoints(imageFileNames);
imageFileNames=imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage=imread(imageFileNames{1});
[mrows, ncols, ~]=size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize=60;  % in units of 'millimeters'
worldPoints=generateCheckerboardPoints(boardSize,squareSize);

% Calibrate the camera
[cameraParams,imagesUsed,estimationErrors]=estimateCameraParameters(imagePoints,worldPoints, ...
    'EstimateSkew',false,'EstimateTangentialDistortion',true, ...
    'NumRadialDistortionCoefficients',2,'WorldUnits','millimeters', ...
    'InitialIntrinsicMatrix',[],'InitialRadialDistortion',[], ...
    'ImageSize',[mrows,ncols]);

% h1=figure;showReprojectionErrors(cameraParams);
% h2=figure;showExtrinsics(cameraParams,'CameraCentric');
% h3=figure;showExtrinsics(cameraParams,'PatternCentric');
% cameraParams.IntrinsicMatrix;
% cameraParams.RadialDistortion;
% cameraParams.TangentialDistortion;
% undistortedImage = undistortImage(originalImage, cameraParams);

oldPwd=pwd;
cd(imgDir1);
x=dir;
listOfImages=[];
for i=1:length(x)
    if x(i).isdir==0
          listOfImages=[listOfImages;x(i)];
    end
end
cd(oldPwd);
fid=imgDir2;
for j=1:length(listOfImages)
    fileName=listOfImages(j).name;
    rfid=sprintf(fid,fileName);
    Irgb=imread(rfid);
    Iset{j}=Irgb;
    Iset{j}=undistortImage(Iset{j},cameraParams);
end
fid=imgDir3;
for i=1:length(listOfImages)
    fileName=listOfImages(i).name;
    rfid=sprintf(fid,fileName);
    imwrite(Iset{i},rfid);
end
end