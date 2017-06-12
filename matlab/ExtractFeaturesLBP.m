function [featuresDataTrain] = ExtractFeaturesLBP( imgDataTrain, numNeighbors, radius, cellSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    img1 = imgDataTrain(:, 1);
    img2D = reshape(img1, 28, 28);
    featureVector = extractLBPFeatures(img2D, 'NumNeighbors', numNeighbors, 'Radius', radius, 'CellSize', cellSize);
    
    featureSize = length(featureVector);
    numberOfTrainImages = size(imgDataTrain, 2);
    
    featuresDataTrain = zeros(featureSize, numberOfTrainImages);
    
    for i = 1:numberOfTrainImages
        img = imgDataTrain(:, i);
        img2D = reshape(img, 28, 28);
        featuresDataTrain(:, i) = extractLBPFeatures(img2D, 'NumNeighbors', numNeighbors, 'Radius', radius, 'CellSize', cellSize);
    end;

end

