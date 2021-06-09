clear all;
close all;
clc;
addpath(genpath('.'));
%% User setup

isPlot = true;

sequence = 0;

imageDir = ['..\dataset' filesep 'test' filesep num2str(sequence,'%02d') filesep 'image_0'];
imageExt = '.png';

calibFile = ['..\dataset' filesep 'test' filesep num2str(sequence,'%02d') filesep 'calib.txt'];
cameraID = 0;

codewords = load(['..\dataset' filesep 'codewords.mat']);
codewords = codewords.codewords;


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
Map.covisibilityGraph = viewSet();

global State;
State.mu = [0;0;0];
State.Sigma = zeros(length(State.mu));

global Params;
Params.cameraParams = load_cameraParams(calibFile, cameraID);
Params.numSkip = 2;
Params.kdtree = KDTreeSearcher(codewords);
Params.numCodewords = size(codewords, 1);
Params.strongNum = 50;


global Debug;
Debug.displayFeaturesOnImages = false;


%% Run ORB-SLAM

imagesFiles = dir([imageDir, filesep, '*', imageExt]);
framesToConsider = 1:Params.numSkip:length(imagesFiles);
frames = cell([1 length(framesToConsider)]);
for i = 1:length(framesToConsider)
	frameIdx = framesToConsider(i);
	frames{i} = imread([imagesFiles(frameIdx).folder, filesep, imagesFiles(frameIdx).name]);
end

for i = 1:length(framesToConsider)

	if iscell(frames)
		frame = frames{i};
	else
		frame = frames(i);
	end

	frontend(frame,i);

    fprintf('Sequence %02d [%4d/%4d]\n', ...
        sequence, i, length(framesToConsider))
end

save([num2str(sequence, 'data/seq%02d'), ...
    num2str(Params.numSkip, '_skip%d.mat')], 'Map')

%% Display

if isPlot
    camPoses = poses(Map.covisibilityGraph);
	figure
	hold on
	traj = cell2mat(camPoses.Location);
    x = traj(:, 1);
    z = traj(:, 3);
    plot(x, z, 'x-')
    axis equal
	grid on

    %{
	validIdx = sqrt(xyzPoints(:, 1).^2 + xyzPoints(:, 2).^2 + xyzPoints(:, 3).^2) < 100;
	validIdx = validIdx & (xyzPoints(:, 3) > 0);

	pcshow(xyzPoints(validIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
		'MarkerSize', 45);
    %}

    %validIdx = sqrt(xyzPoints(:, 1).^2 + xyzPoints(:, 2).^2 + xyzPoints(:, 3).^2) < 500;
    %scatter(xyzPoints(validIdx, 1), xyzPoints(validIdx, 3), '.')
	hold off;
end

% optimize_graph;

rmpath(genpath('.'));