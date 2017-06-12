datasetUrl = './../dataset/101_ObjectCategories';
mergedDatasetUrl = './../datasets/';
testDatasetUrl = './../datasets_test/';
categories = dir(datasetUrl);
idx = 1;
name = {};
categoriesName = {categories.name};

imgCount = 0;
for i = 1 : length(categoriesName)
    url = [datasetUrl, '/', categoriesName{i}];
    if isdir(url)
        imgs = dir(url);
        name = {imgs.name};
        for j = 1: length(name)
            if strfind(name{j}, '.jpg')
                copyfile([url, '/', name{j}], [mergedDatasetUrl, num2str(idx), '.jpg']);
                idx = idx + 1 ;
            end;
        end;
    end;
end
imgCount = idx;
% imgCount = 9145
testIdx = randi(imgCount, 20);
for i = 1 : length(testIdx)
    movefile([mergedDatasetUrl, num2str(testIdx(i)), '.jpg'], [testDatasetUrl, num2str(testIdx(i)), '.jpg']);
end;