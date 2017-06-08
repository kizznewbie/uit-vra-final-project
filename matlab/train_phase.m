setup();
% createCategoryFolder()



for i = 1 : length(hogCellSize)
    featureVector = ExtractFeaturesHog(imgData ,hogCellSize{i});
    save(['HOGFeatureVector', num2str(i)], featureVector, '-mat');
end;