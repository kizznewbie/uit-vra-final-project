addpath('./lib');

% Load data

imgData = loadMNISTImages('./../dataset/train-images.idx3-ubyte');
lblData = loadMNISTLabels('./../dataset/train-labels.idx1-ubyte');

imgTestData = loadMNISTImages('./../dataset/t10k-images.idx3-ubyte');
lblTestData = loadMNISTLabels('./../dataset/t10k-labels.idx1-ubyte');

% Caculated Varialbles
numTrainImgs = size(imgData, 2);
numTestImgs = size(imgTestData, 2);


% Begin define variables
hogOpts = struct;
hogOpts.cellSize = {
    [2, 2],
    [3, 3],
    [4, 4],
    [5, 5],
    [6, 6],
    [8, 8],

};
hogOpts.blockSize = {
    [2, 2],
    [3, 3],
    [4, 4]
};

hogOpts.numBin = [4, 9, 12, 16];
