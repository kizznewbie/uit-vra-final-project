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

fprintf('Getting sample to clustering... %d samples \n', 10e4);

descs = vl_colsubset(cat(2, descs{:}), 10e4);

descs = single(descs);
fprintf('KNN with %d points \n', 10e4);
vocab4 = vl_kmeans(descrs, 10e4, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e5);
vocab5 = vl_kmeans(descrs, 10e5, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e6);
vocab6 = vl_kmeans(descrs, 10e6, 'verbose', 'algorithm', 'ANN') ;
save([outputDir, '/', 'vocab44.m'], 'vocab4', '-mat', '-v7.3');
save([outputDir, '/', 'vocab45.m'], 'vocab5', '-mat', '-v7.3');
save([outputDir, '/', 'vocab46.m'], 'vocab6', '-mat', '-v7.3');

descs= descs_raw;
fprintf('Getting sample to clustering... %d samples \n', 10e5);
descs = vl_colsubset(cat(2, descs{:}), 10e5);

descs = single(descs);
fprintf('KNN with %d points \n', 10e4);
vocab4 = vl_kmeans(descrs, 10e4, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e5);
vocab5 = vl_kmeans(descrs, 10e5, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e6);
vocab6 = vl_kmeans(descrs, 10e6, 'verbose', 'algorithm', 'ANN') ;
save([outputDir, '/', 'vocab54.m'], 'vocab4', '-mat', '-v7.3');
save([outputDir, '/', 'vocab55.m'], 'vocab5', '-mat', '-v7.3');
save([outputDir, '/', 'vocab56.m'], 'vocab6', '-mat', '-v7.3');

descs= descs_raw;
fprintf('Getting sample to clustering... %d samples \n', 10e6);
descs = vl_colsubset(cat(2, descs{:}), 10e6);


descs = single(descs);
fprintf('KNN with %d points \n', 10e4);
vocab4 = vl_kmeans(descrs, 10e4, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e5);
vocab5 = vl_kmeans(descrs, 10e5, 'verbose', 'algorithm', 'ANN') ;
fprintf('KNN with %d points \n', 10e6);
vocab6 = vl_kmeans(descrs, 10e6, 'verbose', 'algorithm', 'ANN') ;
save([outputDir, '/', 'vocab64.m'], 'vocab4', '-mat', '-v7.3');
save([outputDir, '/', 'vocab65.m'], 'vocab5', '-mat', '-v7.3');
save([outputDir, '/', 'vocab66.m'], 'vocab6', '-mat', '-v7.3');
