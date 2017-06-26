% dataset = dir([mergedDatasetUrl, '/*.jpg']);
% names = {dataset.name};
% numImgs = length(names);
% vars = struct;
% vars.numImgs = numImgs;
% vars.imgNames = names;
% vars.numWords1 = 500;
% vars.numWords2 = 1000;
% vars.outputDir = outputDir;
% vars.datasetUrl = datasetUrl;
% vars.mergedDatasetUrl = mergedDatasetUrl;
% vars.testDatasetUrl = testDatasetUrl;
% peakThresh = 28 / 256^2;
% frames_sift = {};
% descs_sift = {};
% frames_covdet = {};
% descs_covdet = {};
% imdb = {};
% 
% % 
% % 
% % % 
% for i = 1 : vars.numImgs
%     
%     im = imread([mergedDatasetUrl, '/', names{i}]);
%     im = resizeImg(im);
%     if size(im, 3) == 3
%         im = rgb2gray(im);
%     end
%     im = single(im);
%     fprintf('Extracting VL_SIFT feature of image %s \n', names{i});
%     [frame_sift, desc_sift] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
%     frames_sift{i} = frame_sift;
%     descs_sift{i} = desc_sift;
%     fprintf('Extracting VL_COVDET feature of image %s \n', names{i});
%     [frame_covdet, desc_covdet] = vl_covdet(im, 'Method', 'DoG', 'descriptor', 'SIFT', 'DoubleImage', false, 'PeakThreshold', peakThresh,'EstimateAffineShape', false,'EstimateOrientation', true, 'Verbose');
%     frames_covdet{i} = frame_covdet;
%     descs_covdet{i} = desc_covdet;
%     imdb{i} = im;
% end;
% % % % 
% % % % 
% save([outputDir, '/', 'vars.m'], 'vars', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_frames_covdet.m'], 'frames_covdet', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_descs_covdet.m'], 'descs_covdet', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_frames_sift.m'], 'frames_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'raw_descs_sift.m'], 'descs_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'imdb.m'], 'imdb', '-mat', '-v7.3');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % CLUSTERING 500 VISUAL WORDS %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% descs_raw_sift = descs_sift;
% descs_raw_covdet = descs_covdet;
% % 
% fprintf('Getting sample to clustering... %d samples \n', 10e4);
% % 
% descs_sift_10e4 = vl_colsubset(cat(2, descs_sift{:}), 10e4);
% descs_covdet_10e4 = vl_colsubset(cat(2, descs_covdet{:}), 10e4);
% % % 
% descs_sift = single(descs_sift_10e4);
% descs_covdet = single(descs_covdet_10e4);
% 
% fprintf('KNN SIFT with %d points \n', vars.numWords1);
% 
% vocab5_sift = vl_kmeans(descs_sift, vars.numWords1, 'verbose', 'algorithm', 'ANN') ;
% 
% fprintf('KNN COVDET with %d points \n', vars.numWords1);
% vocab5_covdet = vl_kmeans(descs_covdet, vars.numWords1, 'verbose', 'algorithm', 'ANN') ;
% 
% save([outputDir, '/', 'vocab5_sift.m'], 'vocab5_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab5_covdet.m'], 'vocab5_covdet', '-mat', '-v7.3');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % CLUSTERING 1000 VISUAL WORDS %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf('KNN SIFT with %d points \n', vars.numWords2);
% 
% vocab10_sift = vl_kmeans(descs_sift, vars.numWords2, 'verbose', 'algorithm', 'ANN') ;
% 
% fprintf('KNN COVDET with %d points \n', vars.numWords2);
% vocab10_covdet = vl_kmeans(descs_covdet, vars.numWords2, 'verbose', 'algorithm', 'ANN') ;
% 
% save([outputDir, '/', 'vocab10_sift.m'], 'vocab10_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'vocab10_covdet.m'], 'vocab10_covdet', '-mat', '-v7.3');

% 
% fprintf('Building kdtree\n');
% kdtree5_sift = vl_kdtreebuild(vocab5_sift);
% kdtree10_sift = vl_kdtreebuild(vocab10_sift);
% kdtree5_covdet = vl_kdtreebuild(vocab5_covdet);
% kdtree10_covdet = vl_kdtreebuild(vocab10_covdet);
% % % 
% save([outputDir, '/', 'kdtree5_sift.m'], 'kdtree5_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'kdtree10_sift.m'], 'kdtree10_sift', '-mat', '-v7.3');
% save([outputDir, '/', 'kdtree5_covdet.m'], 'kdtree5_covdet', '-mat', '-v7.3');
% save([outputDir, '/', 'kdtree10_covdet.m'], 'kdtree10_covdet', '-mat', '-v7.3');
% % load([outputDir, '/', 'kdtree5_1000.m'], '-mat');
% 
descs_sift = descs_raw_sift;
descs_covdet = descs_raw_covdet;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % Get visual word of each image %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

% fprintf('Query visual words for each image\n');
% imgInvidualVisualWords_sift_5 = cell(1, vars.numImgs);
% imgInvidualVisualWords_sift_10 = cell(1, vars.numImgs);
% imgInvidualVisualWords_covdet_5 = cell(1, vars.numImgs);
% imgInvidualVisualWords_covdet_10 = cell(1, vars.numImgs);
% for i = 1 : vars.numImgs
%   fprintf('Getting Visual Words of image %s \n', vars.imgNames{i});
%   imgInvidualVisualWords_sift_5{i} = vl_kdtreequery(kdtree5_sift, vocab5_sift, single(descs_sift{i}));
%   imgInvidualVisualWords_sift_10{i} = vl_kdtreequery(kdtree10_sift, vocab10_sift, single(descs_sift{i}));
%   imgInvidualVisualWords_covdet_5{i} = vl_kdtreequery(kdtree5_covdet, vocab5_covdet, single(descs_covdet{i}));
%   imgInvidualVisualWords_covdet_10{i} = vl_kdtreequery(kdtree10_covdet, vocab10_covdet, single(descs_covdet{i}));
% end;
% save([outputDir, '/', 'imgInvidualVisualWords_sift_5.m'], 'imgInvidualVisualWords_sift_5', '-mat', '-v7.3');
% save([outputDir, '/', 'imgInvidualVisualWords_sift_10.m'], 'imgInvidualVisualWords_sift_10', '-mat', '-v7.3');
% save([outputDir, '/', 'imgInvidualVisualWords_covdet_5.m'], 'imgInvidualVisualWords_covdet_5', '-mat', '-v7.3');
% save([outputDir, '/', 'imgInvidualVisualWords_covdet_10.m'], 'imgInvidualVisualWords_covdet_10', '-mat', '-v7.3');
% % load([outputDir, '/', 'imgInvidualVisualWords5_1000.m'], '-mat');
% 
fprintf('Creating inverted index\n');
% Creating Inverted Index
idx_sift_5 = cell(1, vars.numImgs);
idx_sift_10 = cell(1, vars.numImgs);
idx_covdet_5 = cell(1, vars.numImgs);
idx_covdet_10 = cell(1, vars.numImgs);
for i = 1 : vars.numImgs
    idx_sift_5{i} = i * ones(1, length(imgInvidualVisualWords_sift_5{i}));
    idx_sift_10{i} = i * ones(1, length(imgInvidualVisualWords_sift_10{i}));
    idx_covdet_5{i} = i * ones(1, length(imgInvidualVisualWords_covdet_5{i}));
    idx_covdet_10{i} = i * ones(1, length(imgInvidualVisualWords_covdet_10{i}));
end;

invertedIdx_sift_5 = sparse(double([imgInvidualVisualWords_sift_5{:}]), [idx_sift_5{:}], 1, vars.numWords1, vars.numImgs);
invertedIdx_sift_10 = sparse(double([imgInvidualVisualWords_sift_10{:}]), [idx_sift_10{:}], 1, vars.numWords2, vars.numImgs);
invertedIdx_covdet_5 = sparse(double([imgInvidualVisualWords_covdet_5{:}]), [idx_covdet_5{:}], 1, vars.numWords1, vars.numImgs);
invertedIdx_covdet_10 = sparse(double([imgInvidualVisualWords_covdet_10{:}]), [idx_covdet_10{:}], 1, vars.numWords2, vars.numImgs);
save([outputDir, '/', 'invertedIdx_sift_5.m'], 'invertedIdx_sift_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_sift_10.m'], 'invertedIdx_sift_10', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_covdet_5.m'], 'invertedIdx_covdet_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_covdet_10.m'], 'invertedIdx_covdet_10', '-mat', '-v7.3');
% % load([outputDir, '/', 'invertedIdx.m'], '-mat');
% 
fprintf('Calculating IDF Weighting\n');
%IDF weighting
idf_sift_5 = log(vars.numImgs) - log(max(sum(invertedIdx_sift_5, 2) ,1));
idf_sift_10 = log(vars.numImgs) - log(max(sum(invertedIdx_sift_10, 2) ,1));
idf_covdet_5 = log(vars.numImgs) - log(max(sum(invertedIdx_covdet_5, 2) ,1));
idf_covdet_10 = log(vars.numImgs) - log(max(sum(invertedIdx_covdet_10, 2) ,1));
invertedIdx_idf_sift_5 = spdiags(idf_sift_5, 0, vars.numWords1, vars.numWords1) * invertedIdx_sift_5;
invertedIdx_idf_sift_10 = spdiags(idf_sift_10, 0, vars.numWords2, vars.numWords2) * invertedIdx_sift_10;
invertedIdx_idf_covdet_5 = spdiags(idf_covdet_5, 0, vars.numWords1, vars.numWords1) * invertedIdx_covdet_5;
invertedIdx_idf_covdet_10 = spdiags(idf_covdet_10, 0, vars.numWords2, vars.numWords2) * invertedIdx_covdet_10;
l2_sift_5 = 1./sqrt(sum(invertedIdx_idf_sift_5.*invertedIdx_idf_sift_5, 1))';
l2_sift_10 = 1./sqrt(sum(invertedIdx_idf_sift_10.*invertedIdx_idf_sift_10, 1))';
l2_covdet_5 = 1./sqrt(sum(invertedIdx_idf_covdet_5.*invertedIdx_idf_covdet_5, 1))';
l2_covdet_10 = 1./sqrt(sum(invertedIdx_idf_covdet_10.*invertedIdx_idf_covdet_10, 1))';
invertedIdx_idf_l2_sift_5 = invertedIdx_idf_sift_5 * spdiags(l2_sift_5, 0, vars.numImgs, vars.numImgs);
invertedIdx_idf_l2_sift_10 = invertedIdx_idf_sift_10 * spdiags(l2_sift_10, 0, vars.numImgs, vars.numImgs);
invertedIdx_idf_l2_covdet_5 = invertedIdx_idf_covdet_5 * spdiags(l2_covdet_5, 0, vars.numImgs, vars.numImgs);
invertedIdx_idf_l2_covdet_10 = invertedIdx_idf_covdet_10 * spdiags(l2_covdet_10, 0, vars.numImgs, vars.numImgs);
save([outputDir, '/', 'idf_sift_5.m'], 'idf_sift_5', '-mat', '-v7.3');
save([outputDir, '/', 'idf_sift_10.m'], 'idf_sift_10', '-mat', '-v7.3');
save([outputDir, '/', 'idf_covdet_5.m'], 'idf_covdet_5', '-mat', '-v7.3');
save([outputDir, '/', 'idf_covdet_10.m'], 'idf_covdet_10', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_sift_5.m'], 'invertedIdx_idf_sift_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_sift_10.m'], 'invertedIdx_idf_sift_10', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_covdet_5.m'], 'invertedIdx_idf_covdet_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_covdet_10.m'], 'invertedIdx_idf_covdet_10', '-mat', '-v7.3');
save([outputDir, '/', 'idf_sift_5.m'], 'idf_sift_5', '-mat', '-v7.3');
save([outputDir, '/', 'idf_sift_10.m'], 'idf_sift_10', '-mat', '-v7.3');
save([outputDir, '/', 'idf_covdet_5.m'], 'idf_covdet_5', '-mat', '-v7.3');
save([outputDir, '/', 'idf_covdet_10.m'], 'idf_covdet_10', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_l2_sift_5.m'], 'invertedIdx_idf_l2_sift_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_l2_sift_10.m'], 'invertedIdx_idf_l2_sift_10', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_l2_covdet_5.m'], 'invertedIdx_idf_l2_covdet_5', '-mat', '-v7.3');
save([outputDir, '/', 'invertedIdx_idf_l2_covdet_10.m'], 'invertedIdx_idf_l2_covdet_10', '-mat', '-v7.3');

% % load([outputDir, '/', 'invertedIdx_idf.m'], '-mat');
% % load([outputDir, '/', 'idf.m'], '-mat');
% % load([outputDir, '/', 'invertedIdx_idf_l2.m'], '-mat');