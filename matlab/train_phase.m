% dataset = dir([mergedDatasetUrl, '/*.jpg']);
% names = {dataset.name};
% numImgs = length(names);
% vars = struct;
% vars.numImgs = numImgs;
% vars.imgNames = names;
% peakThresh = 28 / 256^2;
% frames = {};
% descs = {};
% imdb = {};
% orientations = true;
% 
% 
% 
% 
% for i = 1 : vars.numImgs
%     fprintf('Extracting feature of image %s \n', names{i});
%     im = imread([mergedDatasetUrl, '/', names{i}]);
%     im = resizeImg(im);
%     if size(im, 3) == 3
%         im = rgb2gray(im);
%     end
%     im = single(im);
% 
%     [frame, desc] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
%     frames{i} = frame;
%     descs{i} = desc;
%     imdb{i} = im;
% end;
% 
% 
% save([outputDir, '/', 'vars.m'], 'vars', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_frames.m'], 'frames', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_descs.m'], 'descs', '-mat', '-v7.3');
% save([outputDir, '/', 'imdb.m'], 'imdb', '-mat', '-v7.3');
load([outputDir, '/', 'vars.m'], '-mat');
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
subDescs = single(vl_colsubset(cat(2, descs{:}), 10e5));

% descs = single(descs);
% numWord = 500;
% fprintf('KNN with %d points \n', numWord);
% vocab4 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
vars.numWords = 10e2;
fprintf('KNN with %d points \n', vars.numWords);
vocab5 = vl_kmeans(subDescs, vars.numWords, 'verbose', 'algorithm', 'ANN') ;
% numWord = 5*10e2;
% fprintf('KNN with %d points \n', numWord);
% vocab6 = vl_kmeans(descs, numWord, 'verbose', 'algorithm', 'ANN') ;
% save([outputDir, '/', 'vocab5_500.m'], 'vocab4', '-mat', '-v7.3');
save([outputDir, '/', 'vocab5_1000.m'], 'vocab5', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab5_5000.m'], 'vocab6', '-mat', '-v7.3');

load([outputDir, '/', 'vocab5_1000.m'], '-mat');

vocab = vocab5;

kdtree = vl_kdtreebuild(vocab);

% save([outputDir, '/', 'kdtree5_1000.m'], 'kdtree', '-mat', '-v7.3');
load([outputDir, '/', 'kdtree5_1000.m'], '-mat');

% Get visual word of each image


imgInvidualVisualWords = {1, vars.numImgs};
for i = 1 : vars.numImgs
  fprintf('Getting Visual Words of image %s \n', vars.imgNames{i});
  imgInvidualVisualWords{i} = vl_kdtreequery(kdtree, vocab, single(descs{i}));
end;
save([outputDir, '/', 'imgInvidualVisualWords5_1000.m'], 'imgInvidualVisualWords', '-mat', '-v7.3');
load([outputDir, '/', 'imgInvidualVisualWords5_1000.m'], '-mat');

% Creating Inverted Index
idx = cell(1, vars.numImgs);
for i = 1 : vars.numImgs
    idx{i} = i * ones(1, length(imgInvidualVisualWords{i}));
end;

invertedIdx = sparse(double([imgInvidualVisualWords{:}]), [idx{:}], 1, vars.numWords, vars.numImgs);
save([outputDir, '/', 'invertedIdx.m'], 'invertedIdx', '-mat', '-v7.3');
load([outputDir, '/', 'invertedIdx.m'], '-mat');

%IDF weighting
idf = log(vars.numImgs) - log(max(sum(invertedIdx, 2) ,1));
invertedIdx_idf = spdiags(idf, 0, vars.numWords, vars.numWords) * invertedIdx;
l2 = 1./sqrt(sum(invertedIdx_idf.*invertedIdx_idf, 1))';
invertedIdx_idf_l2 = invertedIdx_idf * spdiags(l2, 0, vars.numImgs, vars.numImgs);
save([outputDir, '/', 'idf.m'], 'idf', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf.m'], 'invertedIdx_idf', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_l2.m'], 'invertedIdx_idf_l2', '-mat', '-v7.3');
load([outputDir, '/', 'invertedIdx_idf.m'], '-mat');
load([outputDir, '/', 'idf.m'], '-mat');
load([outputDir, '/', 'invertedIdx_idf_l2.m'], '-mat');
