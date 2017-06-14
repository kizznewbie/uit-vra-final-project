categories = dir(datasetUrl);
idx = 1;
name = {};
categoriesName = {categories.name};

for i = 1 : length(categoriesName)
    url = [datasetUrl, '/', categoriesName{i}];
    fprintf('Go to folder %s \n', categoriesName{i});
    if isdir(url)
        imgs = dir([url, '/*.jpg']);
        names = {imgs.name};
        fprintf('there are %d images founds\n', length(names));
        for j = 1: length(names)
            copyfile([url, '/', names{j}], [mergedDatasetUrl, num2str(idx), '.jpg']);
            idx = idx + 1 ;
        end;
    end;
end

fprintf('Creating test data');
testIdx = randi(imgCount, 20);
for i = 1 : length(testIdx)
    movefile([mergedDatasetUrl, num2str(testIdx(i)), '.jpg'], [testDatasetUrl, num2str(testIdx(i)), '.jpg']);
end;