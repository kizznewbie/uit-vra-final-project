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
hogCellSize = {
    [4, 4],
    [8, 8],
    [16, 16],
    [32, 32],
    [64, 64],
    [128, 128],
    [256, 256],
    [512, 512]
};