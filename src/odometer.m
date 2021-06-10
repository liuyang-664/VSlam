function features_curr = odometer(frameF_prev, frameF_curr, frameS_prev, frameS_curr, k)

global Map
global State
global Params
global Debug

tempPoints = detectFASTFeatures(frameF_prev);
validPoints_prev = tempPoints.selectStrongest(Params.strongNum);
validPoints_prev = validPoints_prev.Location;
features_prev = Brief_Descriptor(frameF_prev,flipud(validPoints_prev'));

tempPoints = detectFASTFeatures(frameF_curr);
validPoints_curr = tempPoints.selectStrongest(Params.strongNum);
validPoints_curr = validPoints_curr.Location;
features_curr = Brief_Descriptor(frameF_prev,flipud(validPoints_curr'));

[matchedPoints1 matchedPoints2] = findmatches(features_prev', features_curr',validPoints_prev, validPoints_curr);

% matchedPoints1_camera =  Pixel_to_Camera(matchedPoints1, Points_pix2);
% matchedPoints2_camera1 =  Pixel_to_Camera(matchedPoints2, Points_pix2);


% Map.covisibilityGraph = addConnection(Map.covisibilityGraph, k - 1, k, ...
%     'Matches', matchedIdx(inlierIdx,:), ...
%     'Orientation', relativeOrient, ...
%     'Location', relativeLoc);
% 
% orientation = relativeOrient * orient_km1;
% location = loc_km1 + relativeLoc * orient_km1;
% 
% [U, ~, V] = svd(orientation);
% orientation = U * V';
% 
% Map.covisibilityGraph = updateView(Map.covisibilityGraph, k, ...
%     'Orientation', orientation, 'Location', location);
% 
% % Connect every past view to the current view
% for i = max(k - Params.numViewsToLookBack, 1):k-2
%     try
%         connect_views(i, k, Params.minMatchesForConnection)
%     catch
%         % warning('Could not find enough inliers between view %d and %d.', i, k)
%     end
% end

% local BA
%{
viewIds = max(k - 10, 1):k;
tracks = findTracks(Map.covisibilityGraph, viewIds);

camPoses = poses(Map.covisibilityGraph, viewIds);

xyzPoints = triangulateMultiview(tracks, camPoses, Params.cameraParams);

[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
	tracks, camPoses, Params.cameraParams, 'FixedViewId', 1, ...
	'PointsUndistorted', true);

Map.covisibilityGraph = updateView(Map.covisibilityGraph, camPoses);
%}
end

function connect_views(viewIdx1, viewIdx2, minNumMatches)

global Map
global State
global Params
global Debug

if nargin < 3
    minNumMatches = 0;
end

features1 = Map.covisibilityGraph.Descriptors{viewIdx1};
points1 = Map.covisibilityGraph.Points{viewIdx1};
features2 = Map.covisibilityGraph.Descriptors{viewIdx2};
points2 = Map.covisibilityGraph.Points{viewIdx2};

matchedIdx = matchFeatures(features1, features2, 'Unique', true, ...
    'Method', 'Approximate', 'MatchThreshold', .8);

matchedPoints1 = points1(matchedIdx(:, 1));
matchedPoints2 = points2(matchedIdx(:, 2));


[relativeOrient, relativeLoc, inlierIdx, status] = estimate_relative_motion(...
    matchedPoints1, matchedPoints2, Params.cameraParams);


if size(matchedIdx,1) >= minNumMatches && status == 0
    Map.covisibilityGraph = addConnection(Map.covisibilityGraph, ...
        viewIdx1, viewIdx2, ...
        'Matches', matchedIdx(inlierIdx,:), ...
        'Orientation', relativeOrient, ...
        'Location', relativeLoc);
    
end
end
