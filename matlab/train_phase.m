setup();
% createCategoryFolder()


for i = 1 : length(hogOpts.cellSize)
    for j = 1 : length(hogOpts.blockSize)
        for k = 1 : length(hogOpts.numBin)
            featureVector = ExtractFeaturesHog(imgData ,hogOpts.cellSize{i}, hogOpts.blockSize{j}, hogOpts.numBin(k));
            save(['./result/HOGFeatureVector', num2str(i), num2str(j), num2str(k), '.mat'], 'featureVector', '-mat', '-v7.3');
    
        end;
    end;
end;