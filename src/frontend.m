function frontend(frame_curr,k)

global Map
global State
global Params
global Debug

persistent frame_prev
if ~isempty(frame_prev)

    odometer(frame_prev, frame_curr,k);

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
    tempPoints = detectFASTFeatures(frame_curr);
    points = tempPoints.selectStrongest(Params.strongNum);
    points = points.Location;
    descriptors = Brief_Descriptor(frame_curr,flipud(points'));
% 	[descriptors, points] = extract_features(frame_curr);

    bow = calc_bow_repr(descriptors, Params.kdtree, Params.numCodewords);

% 	Map.covisibilityGraph = addView(Map.covisibilityGraph, 1, 'Points', points, ...
% 		'Orientation', eye(3), 'Location', zeros(1, 3));   % delete the bow
    Map.covisibilityGraph = addView(Map.covisibilityGraph, 1,...
    descriptors, points, bow, 'Points', points, ...
    'Orientation', eye(3), 'Location', zeros(1, 3));  %the original code of Michigan 

end

	frame_prev = frame_curr;
end
