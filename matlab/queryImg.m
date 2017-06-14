function [] = queryImg(imgUrl, kdtree, vocab, idf, invertedIdx)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    peakThresh = 28 / 256^2;
    im = imread(imgUrl);
    im = resizeImg(im);
    if size(im, 3) == 3
        im = rgb2gray(im);
    end
    im = single(im);

    [frame, desc] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
    imgVisualWords = vl_kdtreequery(kdtree, vocab, single(desc));
    imgBagVisualWords = sparse(double(imgVisualWords), 1, 1, vars.numWord, 1);
    imgBagVisualWords_idf = imgBagVisualWords.*idf;
    imgBagVisualWords_idf_l2 = imgBagVisualWords_idf./sqrt(sum(imgBagVisualWords_idf.*imgBagVisualWords_idf));
    score = imgBagVisualWords_idf_l2'*invertedIdx;
    [sortedScore, idx] = sort(score, 'descend');
    for i = 1 : 10
        fprintf('%s\n', vars.imgNames{idx(i)});
    end;
end

