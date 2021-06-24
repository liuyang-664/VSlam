clear all;
close all;
clc;
addpath(genpath('.'));
%% User setup

isPlot = true;
sequence = 0;
image = 0; %0代表用image_0的数据来计算视觉里程计，1代表用image_1的数据计算视觉里程计

imageDir1 = 'E:\dataset\dataset\sequences\00\image_0';
imageDir2 = 'E:\dataset\dataset\sequences\00\image_1';
imageExt = '.png';

calibFile = 'E:\dataset\dataset\sequences\00\calib.txt';
cameraID1 = 0;
cameraID2 = 1;

% codewords = load(['..\dataset' filesep 'codewords.mat']);
% codewords = codewords.codewords;


%% Get feature vocabulary

% if no vocabulary exists
	% Load set of images
	% Create vocabulary
	% Save vocabulary
% else
	% Load vocabulary
% end


%% Setup Global variables

global Map;
Map.covisibilityGraph = myViewSet();

% global State;
% State.mu = [0;0;0];
% State.Sigma = zeros(length(State.mu));

global Params;
Params.cameraParams1 = load_cameraParams(calibFile, cameraID1);
Params.cameraParams2 = load_cameraParams(calibFile, cameraID2);
Params.numSkip = 2;
% Params.kdtree = KDTreeSearcher(codewords);
% Params.numCodewords = size(codewords, 1);
Params.strongNum = 500;
Params.numViewsToLookBack = 5;
Params.maxZ = 50;


global Debug;
Debug.displayFeaturesOnImages = false;


%% Run ORB-SLAM

images_Left = dir([imageDir1, filesep, '*', imageExt]);
images_Right = dir([imageDir2, filesep, '*', imageExt]);

framesToConsider = 1:Params.numSkip:50;  %Length(images_Left)

frames_Left = cell([1 length(framesToConsider)]);
frames_Right = frames_Left;
for i = 1:length(framesToConsider)
	frameIdx = framesToConsider(i);
	frames_Left{i} = imread([images_Left(frameIdx).folder, filesep, images_Left(frameIdx).name]);
    frames_Right{i} = imread([images_Right(frameIdx).folder, filesep, images_Right(frameIdx).name]);
end

for i = 1:length(framesToConsider)

	if iscell(frames_Left)
		frame_Left = frames_Left{i};
        frame_Right = frames_Right{i};
	else
		frame_Left = frames_Left(i);
        frame_Right = frames_Right(i);
    end
    
    %image == 0 means use the data in image_0 to calculate visual odometery
    if image == 0
        frontend(frame_Left,frame_Right,i);
    else
        frontend(frame_Right,frame_Left,i);
    end	

    fprintf('Sequence %02d [%4d/%4d]\n', ...
        sequence, i, length(framesToConsider))
end

save([num2str('../data/seq%02d'), ...
    num2str(Params.numSkip, '_skip%d.mat')], 'Map')

%% Display

if isPlot
    camPoses = poses(Map.covisibilityGraph);
	traj = cell2mat(camPoses.Location);
    x = traj(:, 1);
    z = traj(:, 3);
    la = 1;
    triangle = [-la/2, 1, -sqrt(3)/6 * la;
        la/2, 1, -sqrt(3)/6 * la;
        0, 1, sqrt(3)/3 * la];
    for i = 1:1:length(framesToConsider)
        plot(x, z, 'b', 'LineWidth',1.5);
        hold on;
        pose = camPoses.Orientation{i};
        trianglek = triangle * pose + traj(i, :);
        plot([trianglek(:,1); trianglek(1,1)], [trianglek(:,3); trianglek(1,3)], 'r', 'LineWidth',1);
        xlabel('x/m');
        ylabel('z/m');
        title('The track of camera');
        axis equal
        grid on
    end
    hold off;
    
    
end

% optimize_graph;

%rmpath(genpath('.'));