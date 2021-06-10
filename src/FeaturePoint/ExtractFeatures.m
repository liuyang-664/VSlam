%extract FAST features and calculate BRIEF descriptor
function [validPoints, features] = ExtractFeatures(image)

global Params
global Debug

tempPoints = detectFASTFeatures(image);
validPoints = tempPoints.selectStrongest(Params.strongNum);
validPoints = validPoints.Location;
features = Brief_Descriptor(image,flipud(validPoints'));

if Debug.displayFeaturesOnImages
	figure; imshow(img); hold on; plot(validPoints); hold off;
end

end