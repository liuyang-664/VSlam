function frontend(frameF_curr,frameS_curr,k)
%use frameF_curr to calculate odometry
%frameS_curr helps calculate depth
global Map
global State
global Params
global Debug

persistent frameF_prev
persistent frameS_prev
if ~isempty(frameF_prev)
    odometer(frameF_prev, frameF_curr, frameS_prev, frameS_curr,k);

    % disp('Before keyframe culling')
    % disp(Map.covisibilityGraph.NumViews);
% 	if mod(k, Params.cullingSkip) == 0
%         local_mapping();
%     end
    % disp('After keyframe culling')
    % disp(Map.covisibilityGraph.NumViews);
% 	loop_closing();
else
	% Initialize
    [pointsF, featuresF] = ExtractFeatures(frameF_curr);
    [pointsS, featuresS] = ExtractFeatures(frameS_curr);
    matchedIdx = findmatches(featuresF', featuresS');
    
    matchedPointsF = pointsF(matchedIdx(:,1), :);
    matchedPointsS = pointsS(matchedIdx(:,2), :);
    pointsF_Camera = pixel2Camera(matchedPointsF, matchedPointsS);

%     bow = calc_bow_repr(descriptors, Params.kdtree, Params.numCodewords);

	Map.covisibilityGraph = addView(Map.covisibilityGraph, 1, pointsF_Camera, 'Points', pointsF, ...
		'Orientation', eye(3), 'Location', single(zeros(1, 3)));   % delete the bow
%     Map.covisibilityGraph = addView(Map.covisibilityGraph, 1,...
%     descriptors, points, bow, 'Points', points, ...
%     'Orientation', eye(3), 'Location', zeros(1, 3));  %the original code of Michigan 

end

	frameF_prev = frameF_curr;
    frameS_prev = frameS_curr;
end
