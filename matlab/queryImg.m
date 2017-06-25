function [] = queryImg(imgUrl, startX, startY, w, h, kdtree, vocab, idf, invertedIdx, vars, frames, descs, imgInvidualVisualWords)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
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
    disp(idx(1:10));
    for i = 1 : round(length(idx)/2)
          id = idx(i);
          if i <= 10
            figure(i);
            title(vars.imgNames{id});
            imshow([vars.mergedDatasetUrl, vars.imgNames{id}]);
          end
          
          [matched] = matchWords(imgVisualWords, imgInvidualVisualWords{id});
          inliers = geometricVerification(frame, frames{id}, matched);
%           [matches, scores] = vl_ubcmatch(desc, descs{id});
%           fprintf('cap %d: %d%s%d\n', id,length(inliers), ' ', length(matches));
%           score(id) = max(score(id), size(matches, 2));
          score(id) = max(score(id), size(inliers, 2));
    end;
    [sortedScore, idx] = sort(score, 'descend');
    disp(idx(1:10));
    for j = 11 : 20
        figure(j);
        title(vars.imgNames{idx(j-10)});
        imshow([vars.mergedDatasetUrl, vars.imgNames{idx(j-10)}]);

    end;
end

