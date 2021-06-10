%extract FAST features and calculate BRIEF descriptor
function [validPoints, features] = ExtractFeatures(image)

strongNum = 50;
tempPoints = detectFASTFeatures(image);
validPoints = tempPoints.selectStrongest(strongNum);
validPoints = validPoints.Location;
features = Brief_Descriptor(image,flipud(validPoints'));

end