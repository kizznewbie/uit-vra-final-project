dataset = dir(mergedDatasetUrl);
names = {dataset.name};

peakThresh = 28 / 256^2;
frames = {};
descs = {};
imdb = {};
orientations = true;




for i = 1 : 3%length(names)
    if strfind(names{i}, '.jpg')
        im = imread([mergedDatasetUrl, '/', names{i}]);
        im = single(rgb2gray(im));
        im = resizeImg(im);
        [frame, desc] = vl_sift(im, 'peakThresh', peakThresh,'Orientations', 'Verbose');
        frames{i} = frame;
        descs{i} = desc;
        imdb{i} = im;
    end
end;



save([outputDir, '/', 'raw_frames.m'], 'frames', '-mat', '-v7.3');
save([outputDir, '/', 'raw_descs.m'], 'descs', '-mat', '-v7.3');
save([outputDir, '/', 'imdb.m'], 'imdb', '-mat', '-v7.3');

