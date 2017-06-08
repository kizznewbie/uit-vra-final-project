function [featuresDataTrain] = ExtractFeaturesHog( imgDataTrain, cellSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    img1 = imgDataTrain(:, 1);
    img2D = reshape(img1, 28, 28);
    [featureVector, hogVisualization] = extractHOGFeatures(img2D, 'CellSize',cellSize);
    
    featureSize = length(featureVector);
    fprintf('featureSize: %d \n', featureSize);
    numberOfTrainImages = size(imgDataTrain, 2);
    
    featuresDataTrain = zeros(featureSize, numberOfTrainImages);
    
    for i = 1:numberOfTrainImages
        img = imgDataTrain(:, i);
        img2D = reshape(img, 28, 28);
        featuresDataTrain(:, i) = extractHOGFeatures(img2D, 'CellSize',cellSize);
    end;

end

