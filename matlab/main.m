run('./setup.m');
% run('./train_phase.m');
fprintf('Loading variables...\n');
load([outputDir, '/', 'vars.m'], '-mat');
fprintf('Loading frames...\n');
load([outputDir, '/', 'raw_frames.m'], '-mat');
fprintf('Loading descriptors...\n');
load([outputDir, '/', 'raw_descs.m'], '-mat');
fprintf('Loading image dataset...\n');
load([outputDir, '/', 'imdb.m'], '-mat');
fprintf('Loading vocabulary...\n');
load([outputDir, '/', 'vocab5_1000.m'], '-mat');
vocab = vocab5;
fprintf('Loading kdtree 10e5 - 1000 words...\n');
load([outputDir, '/', 'kdtree5_1000.m'], '-mat');
fprintf('Loading visual words of each image in dataset...\n');
load([outputDir, '/', 'imgInvidualVisualWords5_1000.m'], '-mat');
fprintf('Loading idf weighting...\n');
load([outputDir, '/', 'idf.m'], '-mat');
fprintf('Loading inverted index...\n');
load([outputDir, '/', 'invertedIdx_idf_l2.m'], '-mat');

queryImg([testDatasetUrl, '.jpg'], vocab, kdtree, idf,invertedIdx_idf_l2);