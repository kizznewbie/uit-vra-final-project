function [] = queryImg(imgUrl, startX, startY, w, h)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    run('./setup.m');
    % % run('./train_phase.m');
    fprintf('Loading variables...\n');
    load([outputDir, '/', 'vars.m'], '-mat');
    fprintf('Loading frames...\n');
    load([outputDir, '/', 'raw_frames.m'], '-mat');
    fprintf('Loading descriptors...\n');
    load([outputDir, '/', 'raw_descs.m'], '-mat');
    % fprintf('Loading image dataset...\n');
    % load([outputDir, '/', 'imdb.m'], '-mat');
    fprintf('Loading vocabulary...\n');
    load([outputDir, '/', 'vocab4_500.m'], '-mat');
    vocab = vocab4;
    fprintf('Loading kdtree 10e5 - 1000 words...\n');
    load([outputDir, '/', 'kdtree5_1000.m'], '-mat');
    fprintf('Loading visual words of each image in dataset...\n');
    load([outputDir, '/', 'imgInvidualVisualWords5_1000.m'], '-mat');
    fprintf('Loading idf weighting...\n');
    load([outputDir, '/', 'idf.m'], '-mat');
    fprintf('Loading inverted index...\n');
    load([outputDir, '/', 'invertedIdx_idf_l2.m'], '-mat');
    invertedIdx = invertedIdx_idf_l2;
    vars.outputDir = outputDir;
    vars.datasetUrl = datasetUrl;
    vars.mergedDatasetUrl = mergedDatasetUrl;
    vars.testDatasetUrl = testDatasetUrl;
    peakThresh = 28 / 256^2;
    im = imread(imgUrl);
    im = resizeImg(im);
    if size(im, 3) == 3
        im = rgb2gray(im);
    end
      imgSize = size(im);
      im = imcrop(im, [startX*imgSize(2), startY*imgSize(1), w*imgSize(2), h*imgSize(1)]);
    im = single(im);

%     [frame, desc] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
    [frame, desc] = vl_covdet(im, 'Method', 'DoG', 'descriptor', 'SIFT', 'DoubleImage', false, 'PeakThreshold', peakThresh,'EstimateAffineShape', false,'EstimateOrientation', true, 'Verbose');
    imgVisualWords = vl_kdtreequery(kdtree, vocab, single(desc));
    imgBagVisualWords = sparse(double(imgVisualWords), 1, 1, vars.numWords, 1);
    imgBagVisualWords_idf = imgBagVisualWords.*idf;
    imgBagVisualWords_idf_l2 = imgBagVisualWords_idf./sqrt(sum(imgBagVisualWords_idf.*imgBagVisualWords_idf));
    score = imgBagVisualWords_idf_l2'*invertedIdx;
    [sortedScore, idx] = sort(score, 'descend');
    for i = 1 : 10
      id = idx(i);
      [matched] = matchWords(imgVisualWords, imgInvidualVisualWords{id});
      inliers = geometricVerification(frame, frames{id}, matched);
%           [matches, scores] = vl_ubcmatch(desc, descs{id});
%           fprintf('cap %d: %d%s%d\n', id,length(inliers), ' ', length(matches));
%           score(id) = max(score(id), size(matches, 2));
      score(id) = max(score(id), size(inliers, 2));
    end;
    [sortedScore, idx] = sort(score, 'descend');
    fprintf('---Result from here---\n');
    for j = 1 : 10
        fprintf('%s\n', ['/upload/' ,vars.imgNames{idx(j)}]);
    end;
    fprintf('---end result here---\n');
end

