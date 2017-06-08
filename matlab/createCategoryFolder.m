function [] = createCategoryFolder()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    imgData = loadMNISTImages('./../dataset/train-images.idx3-ubyte');
    lblDataLabel = loadMNISTLabels('./../dataset/train-labels.idx1-ubyte');
    mkdir './../dataset/processed_image/trains';
    for i = 0 : 9
        mkdir(['./../dataset/processed_image/trains/', num2str(i)]);
    end;
    numImgs = size(imgData, 2);
    for i = 1 : numImgs
        img = reshape(imgData(:, i), 28, 28);
        imwrite(img, ['./../dataset/processed_image/trains/', num2str(lblDataLabel(i)), '/' , num2str(i), '.jpg'], 'jpg');
    end;
    
    imgTestData = loadMNISTImages('./../dataset/t10k-images.idx3-ubyte');
    lblTestDataLabel = loadMNISTLabels('./../dataset/t10k-labels.idx1-ubyte');
    mkdir './../dataset/processed_image/test';
    for i = 0 : 9
        mkdir(['./../dataset/processed_image/test/', num2str(i)]);
    end;
    numImgs = size(imgTestData, 2);
    for i = 1 : numImgs
        img = reshape(imgTestData(:, i), 28, 28);
        imwrite(img, ['./../dataset/processed_image/test/', num2str(lblTestDataLabel(i)), '/' , num2str(i), '.jpg'], 'jpg');
    end;
end

