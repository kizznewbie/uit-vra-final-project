function [] = queryImg(imgUrl, startX, startY, w, h)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    run('./setup.m');
    % % run('./train_phase.m');
    fprintf('Loading variables...\n');
    load([outputDir, '/', 'vars.m'], '-mat');
    fprintf('Loading frames...\n');
%     load([outputDir, '/', 'raw_frames_sift.m'], '-mat');
    load([outputDir, '/', 'raw_frames_covdet.m'], '-mat');
%     fprintf('Loading descriptors...\n');
%     load([outputDir, '/', 'raw_descs.m'], '-mat');
    % fprintf('Loading image dataset...\n');
    % load([outputDir, '/', 'imdb.m'], '-mat');
    fprintf('Loading vocabulary...\n');
%     load([outputDir, '/', 'vocab5_sift.m'], '-mat');
%     load([outputDir, '/', 'vocab10_sift.m'], '-mat');
    load([outputDir, '/', 'vocab5_covdet.m'], '-mat');
    load([outputDir, '/', 'vocab10_covdet.m'], '-mat');
    
    fprintf('Loading kdtree...\n');
%     load([outputDir, '/', 'kdtree5_sift.m'], '-mat');
%     load([outputDir, '/', 'kdtree10_sift.m'], '-mat');
    load([outputDir, '/', 'kdtree5_covdet.m'], '-mat');
    load([outputDir, '/', 'kdtree10_covdet.m'], '-mat');
    fprintf('Loading visual words of each image in dataset...\n');
%     load([outputDir, '/', 'imgInvidualVisualWords_sift_5.m'], '-mat');
%     load([outputDir, '/', 'imgInvidualVisualWords_sift_10.m'], '-mat');
    load([outputDir, '/', 'imgInvidualVisualWords_covdet_5.m'], '-mat');
    load([outputDir, '/', 'imgInvidualVisualWords_covdet_10.m'], '-mat');
    fprintf('Loading idf weighting...\n');
%     load([outputDir, '/', 'idf_sift_5.m'], '-mat');
%     load([outputDir, '/', 'idf_sift_10.m'], '-mat');
    load([outputDir, '/', 'idf_covdet_5.m'], '-mat');
    load([outputDir, '/', 'idf_covdet_10.m'], '-mat');
    fprintf('Loading inverted index...\n');
%     load([outputDir, '/', 'invertedIdx_idf_l2_sift_5.m'], '-mat');
%     load([outputDir, '/', 'invertedIdx_idf_l2_sift_10.m'], '-mat');
    load([outputDir, '/', 'invertedIdx_idf_l2_covdet_5.m'], '-mat');
    load([outputDir, '/', 'invertedIdx_idf_l2_covdet_10.m'], '-mat');
    
    peakThresh = 28 / 256^2;
    im = imread(imgUrl);
    im = resizeImg(im);
    if size(im, 3) == 3
        im = rgb2gray(im);
    end
      imgSize = size(im);
      im = imcrop(im, [startX*imgSize(2), startY*imgSize(1), w*imgSize(2), h*imgSize(1)]);
    im = single(im);

%     [frame_sift, desc_sift] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
    [frame_covdet, desc_covdet] = vl_covdet(im, 'Method', 'DoG', 'descriptor', 'SIFT', 'DoubleImage', false, 'PeakThreshold', peakThresh,'EstimateAffineShape', false,'EstimateOrientation', true, 'Verbose');
    
%     imgVisualWords5_sift = vl_kdtreequery(kdtree5_sift, vocab5_sift, single(desc_sift));
%     imgVisualWords10_sift = vl_kdtreequery(kdtree10_sift, vocab10_sift, single(desc_sift));
    imgVisualWords5_covdet = vl_kdtreequery(kdtree5_covdet, vocab5_covdet, single(desc_covdet));
    imgVisualWords10_covdet = vl_kdtreequery(kdtree10_covdet, vocab10_covdet, single(desc_covdet));
    
%     imgBagVisualWords_sift_5 = sparse(double(imgVisualWords5_sift), 1, 1, vars.numWords1, 1);
%     imgBagVisualWords_sift_10 = sparse(double(imgVisualWords10_sift), 1, 1, vars.numWords2, 1);
    imgBagVisualWords_covdet_5 = sparse(double(imgVisualWords5_covdet), 1, 1, vars.numWords1, 1);
    imgBagVisualWords_covdet_10 = sparse(double(imgVisualWords10_covdet), 1, 1, vars.numWords2, 1);
    
    
%     imgBagVisualWords_idf_sift_5 = imgBagVisualWords_sift_5.*idf_sift_5;
%     imgBagVisualWords_idf_sift_10 = imgBagVisualWords_sift_10.*idf_sift_10;
    imgBagVisualWords_idf_covdet_5  = imgBagVisualWords_covdet_5.*idf_covdet_5;
    imgBagVisualWords_idf_covdet_10  = imgBagVisualWords_covdet_10.*idf_covdet_10;
    
    
%     imgBagVisualWords_idf_l2_sift_5 = imgBagVisualWords_idf_sift_5./sqrt(sum(imgBagVisualWords_idf_sift_5.*imgBagVisualWords_idf_sift_5));
%     imgBagVisualWords_idf_l2_sift_10 = imgBagVisualWords_idf_sift_10./sqrt(sum(imgBagVisualWords_idf_sift_10.*imgBagVisualWords_idf_sift_10));
    imgBagVisualWords_idf_l2_covdet_5 = imgBagVisualWords_idf_covdet_5./sqrt(sum(imgBagVisualWords_idf_covdet_5.*imgBagVisualWords_idf_covdet_5));
    imgBagVisualWords_idf_l2_covdet_10 = imgBagVisualWords_idf_covdet_10./sqrt(sum(imgBagVisualWords_idf_covdet_10.*imgBagVisualWords_idf_covdet_10));
    
    
    
%     score_sift_5 = imgBagVisualWords_idf_l2_sift_5'*invertedIdx_idf_l2_sift_5;
%     score_sift_10 = imgBagVisualWords_idf_l2_sift_10'*invertedIdx_idf_l2_sift_10;
    score_covdet_5 = imgBagVisualWords_idf_l2_covdet_5'*invertedIdx_idf_l2_covdet_5;
    score_covdet_10 = imgBagVisualWords_idf_l2_covdet_10'*invertedIdx_idf_l2_covdet_10;
    
%     [sortedScore_sift_5, idx_sift_5] = sort(score_sift_5, 'descend');
%     [sortedScore_sift_10, idx_sift_10] = sort(score_sift_10, 'descend');
    [sortedScore_covdet_5, idx_covdet_5] = sort(score_covdet_5, 'descend');
    [sortedScore_covdet_10, idx_covdet_10] = sort(score_covdet_10, 'descend');
    for i = 1 : 10
%       id_sift_5 = idx_sift_5(i);
%       id_sift_10 = idx_sift_10(i);
      id_covdet_5 = idx_covdet_5(i);
      id_covdet_10 = idx_covdet_10(i);
      
%       [matched_sift_5] = matchWords(imgVisualWords5_sift, imgInvidualVisualWords_sift_5{id_sift_5});
%       [matched_sift_10] = matchWords(imgVisualWords10_sift, imgInvidualVisualWords_sift_10{id_sift_10});
      [matched_covdet_5] = matchWords(imgVisualWords5_covdet, imgInvidualVisualWords_covdet_5{id_covdet_5});
      [matched_covdet_10] = matchWords(imgVisualWords10_covdet, imgInvidualVisualWords_covdet_10{id_covdet_10});
      
%       inliers_sift_5 = geometricVerification(frame_sift, frames_sift{id_sift_5}, matched_sift_5);
%       inliers_sift_10 = geometricVerification(frame_sift, frames_sift{id_sift_10}, matched_sift_10);
      inliers_covdet_5 = geometricVerification(frame_covdet, frames_covdet{id_covdet_5}, matched_covdet_5);
      inliers_covdet_10 = geometricVerification(frame_covdet, frames_covdet{id_covdet_10}, matched_covdet_10);
%           [matches, scores] = vl_ubcmatch(desc, descs{id});
%           fprintf('cap %d: %d%s%d\n', id,length(inliers), ' ', length(matches));
%           score(id) = max(score(id), size(matches, 2));
%       score_sift_5(id_sift_5) = max(score_sift_5(id_sift_5), size(inliers_sift_5, 2));
%       score_sift_10(id_sift_10) = max(score_sift_10(id_sift_10), size(inliers_sift_10, 2));
      score_covdet_5(id_covdet_5) = max(score_covdet_5(id_covdet_5), size(inliers_covdet_5, 2));
      score_covdet_10(id_covdet_10) = max(score_covdet_10(id_covdet_10), size(inliers_covdet_10, 2));
      
    end;
%     [sortedScore_sift_5, idx_sift_5] = sort(score_sift_5, 'descend');
%     [sortedScore_sift_10, idx_sift_10] = sort(score_sift_10, 'descend');
    [sortedScore_covdet_5, idx_covdet_5] = sort(score_covdet_5, 'descend');
    [sortedScore_covdet_10, idx_covdet_10] = sort(score_covdet_10, 'descend');
    fprintf('---Result from here---\n');
    for j = 1 : 10
%         fprintf('%s;%s;%s;%s\n', [mergedDatasetUrl, '/' ,vars.imgNames{idx_sift_5(j)}],...
%             [mergedDatasetUrl, '/' ,vars.imgNames{idx_sift_10(j)}],...
%             [mergedDatasetUrl, '/' ,vars.imgNames{idx_covdet_5(j)}],...
%             [mergedDatasetUrl, '/' ,vars.imgNames{idx_covdet_10(j)}]);
        fprintf('%s;%s\n',...
            [mergedDatasetUrl, '/' ,vars.imgNames{idx_covdet_5(j)}],...
            [mergedDatasetUrl, '/' ,vars.imgNames{idx_covdet_10(j)}]);
    end;
    fprintf('---end result here---\n');
end

