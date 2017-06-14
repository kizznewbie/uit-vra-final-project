% dataset = dir(mergedDatasetUrl);
% names = {dataset.name};
%
% peakThresh = 28 / 256^2;
% frames = {};
% descs = {};
% imdb = {};
% orientations = true;
%
%
%
%
% for i = 1 : length(names)
%     if strfind(names{i}, '.jpg')
%         fprintf('Extracting feature of image %s \n', names{i});
%         im = imread([mergedDatasetUrl, '/', names{i}]);
%         im = resizeImg(im);
%         if size(im, 3) == 3
%             im = rgb2gray(im);
%         end
%         im = single(im);
%
%         [frame, desc] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
%         frames{i} = frame;
%         descs{i} = desc;
%         imdb{i} = im;
%     end
% end;
%
%
%
% save([outputDir, '/', 'raw_frames.m'], 'frames', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_descs.m'], 'descs', '-mat', '-v7.3');
% save([outputDir, '/', 'imdb.m'], 'imdb', '-mat', '-v7.3');

load([outputDir, '/', 'raw_frames.m'], '-mat');
load([outputDir, '/', 'raw_descs.m'], '-mat');
load([outputDir, '/', 'imdb.m'], '-mat');

descs_raw = descs;

% fprintf('Getting sample to clustering... %d samples \n', 10e4);
% 
% descs = vl_colsubset(cat(2, descs{:}), 10e4);
% 
% descs = single(descs);
% numWord = 500;
% fprintf('KNN with %d points \n', numWord);
% vocab4 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% numWord = 10e2;
% fprintf('KNN with %d points \n', numWord);
% vocab5 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% numWord = 2*10e2;
% fprintf('KNN with %d points \n', numWord);
% vocab6 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% save([outputDir, '/', 'vocab4_500.m'], 'vocab4', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab4_1000.m'], 'vocab5', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab4_2000.m'], 'vocab6', '-mat', '-v7.3');

descs= descs_raw;
fprintf('Getting sample to clustering... %d samples \n', 10e5);
descs = vl_colsubset(cat(2, descs{:}), 10e5);

% descs = single(descs);
% numWord = 500;
% fprintf('KNN with %d points \n', numWord);
% vocab4 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
numWord = 10e2;
fprintf('KNN with %d points \n', numWord);
vocab5 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% numWord = 5*10e2;
% fprintf('KNN with %d points \n', numWord);
% vocab6 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% save([outputDir, '/', 'vocab5_500.m'], 'vocab4', '-mat', '-v7.3');
save([outputDir, '/', 'vocab5_1000.m'], 'vocab5', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab5_5000.m'], 'vocab6', '-mat', '-v7.3');

load([outputDir, '/', 'vocab5_1000.m'], '-mat');

vocab = vocab5;

kdtree = vl_kdtreebuild(vocab);

save([outputDir, '/', 'kdtree5_1000.m'], 'kdtree', '-mat', '-v7.3');