function featuresF_curr = odometer(frameF_prev, frameF_curr, frameS_prev, frameS_curr, k)

global Map
global State
global Params
global Debug

[PointsF_prev ,featuresF_prev] = ExtractFeatures(frameF_prev);
[PointsF_curr, featuresF_curr] = ExtractFeatures(frameF_curr);

matchedIdx1 = findmatches(featuresF_prev', featuresF_curr');

matchedPoints1 = PointsF_prev(matchedIdx1(:, 1), :);
matchedPoints2 = PointsF_curr(matchedIdx1(:, 2), :);

%for the depth calculation, match the left and right image
[PointsS_prev, featuresS_prev] = ExtractFeatures(frameS_prev);
[PointsS_curr, featuresS_curr] = ExtractFeatures(frameS_curr);
matchedIdx2 = findmatches(featuresF_prev', featuresS_prev');
matchedIdx3 = findmatches(featuresF_curr', featuresS_curr');

matchedPointsFS1 = PointsF_prev(matchedIdx2(:, 1), :);
matchedPointsFS2 = PointsS_prev(matchedIdx2(:, 2), :);
matchedPointsFS3 = PointsF_curr(matchedIdx3(:, 1), :);
matchedPointsFS4 = PointsF_prev(matchedIdx3(:, 2), :);

Points1_camera = pixel2Camera(matchedPointsFS1, matchedPointsFS2);
Points2_camera = pixel2Camera(matchedPointsFS3, matchedPointsFS4);

matchedPoints1_camera = [];
matchedPoints2_camera = [];
for i = 1:size(matchedIdx1,1)
    a = matchedIdx1(i, 1);
    b = matchedIdx1(i, 2);
    find_a = find(matchedIdx2(:,1) == a, 1);
    find_b = find(matchedIdx3(:,1) == b, 1);
    if isempty(find_a) || isempty(find_b)
        continue;
    else
        matchedPoints1_camera = [matchedPoints1_camera; Points1_camera(find_a, :)];
        matchedPoints2_camera = [matchedPoints2_camera; Points2_camera(find_b, :)];
    end
end

[relativeOrient, relativeLoc] = ICP_SVDMethod(matchedPoints1_camera, matchedPoints2_camera);

% bow = calc_bow_repr(features_curr, Params.kdtree, Params.numCodewords);

Map.covisibilityGraph = addView(Map.covisibilityGraph, k, ...
    'Points', PointsF_prev);

pose_km1 = poses(Map.covisibilityGraph, k - 1);
orient_km1 = pose_km1.Orientation{1};
loc_km1 = pose_km1.Location{1};

Map.covisibilityGraph = addConnection(Map.covisibilityGraph, k - 1, k, ...
    'Orientation', relativeOrient, ...
    'Location', relativeLoc);

orientation = relativeOrient * orient_km1;
location = loc_km1 + relativeLoc * orient_km1;

[U, ~, V] = svd(orientation);
orientation = U * V';

Map.covisibilityGraph = updateView(Map.covisibilityGraph, k, ...
    'Orientation', orientation, 'Location', location);

% Connect every past view to the current view
for i = max(k - Params.numViewsToLookBack, 1):k-2
    try
        connect_views(i, k, Params.minMatchesForConnection)
    catch
        % warning('Could not find enough inliers between view %d and %d.', i, k)
    end
end

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
