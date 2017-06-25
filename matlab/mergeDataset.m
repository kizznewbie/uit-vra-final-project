imgs = dir([datasetUrl, '/*.jpg']);
idx = 1;
names = {imgs.name};
imgCount = length([names]);

fprintf('Copying file to datasets folder...\n');
for i = 1 : length([names])
        copyfile([datasetUrl, '/', names{i}], [mergedDatasetUrl, num2str(idx), '.jpg']);
        idx = idx + 1 ;
end

fprintf('Creating test data');
testIdx = randi(imgCount, 20);
for i = 1 : length(testIdx)
    movefile([mergedDatasetUrl, num2str(testIdx(i)), '.jpg'], [testDatasetUrl, num2str(testIdx(i)), '.jpg']);
end;