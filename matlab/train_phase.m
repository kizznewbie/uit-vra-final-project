dataset = dir(mergedDatasetUrl);
names = {dataset.name};
frames = {};
descs = {};
orientations = true;
for i = 1 : 3%length(names)
    if strfind(names{i}, '.jpg')
        im = imread([mergedDatasetUrl, '/', names{i}]);
        im = single(rgb2gray(im));
        [frame, desc] = vl_sift(im);
    end
end