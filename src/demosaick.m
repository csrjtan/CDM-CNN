clc;
run(fullfile(fileparts(mfilename('fullpath')),...
  '..','lib', 'matconvnet-1.0-beta22', 'matlab', 'vl_setupnn.m')) ;
addpath(genpath('./.'));

% =========================================================================
% Default parameter 
% =========================================================================
datasetList    = {'Set24','TEST','POLYU_SET'};  
numDataset     = length(datasetList);       
border         = 10;
runtime = zeros(1);  % calc the 42 images demosaicking time
resPsnr = zeros(3,4); % calc the PSNR/CPSNR on three datasets


% =========================================================================
% Loading CNN model
% =========================================================================
gpu = 1; % 0:use cpu, 1:use gpu
load('model_10.mat');
net = dagnn.DagNN.loadobj(net) ;

% Get the params of output
outRGB = net.getVarIndex('s2RGB'); % output_layer number

net.mode = 'test';
if gpu
    net.move('gpu');
end

% =========================================================================
% Evaluate on three Testing Sets 
% =========================================================================
for iDataset = 1 : numDataset
    
    datasetCur = datasetList{iDataset};
    folderCur = fullfile('..', 'data',datasetCur);
    ext        =  {'*.jpg','*.png','*.bmp','*.tif'};
    imgPaths  =  [];
    for i = 1 : length(ext)
        imgPaths = cat(1,imgPaths,dir(fullfile(folderCur, ext{i})));
    end
    numImgDataset = numel(imgPaths);
       
    %%% Process images in each testing set
    for imgID = 1:numImgDataset
        % read image
        [~, nameCur, extCur] = fileparts(imgPaths(imgID).name);
        label  = imread(fullfile(folderCur,imgPaths(imgID).name)); % uint8
       
        % bayer image
        pattern = 'grbg';
        [mosaic, mask] = mosaic_bayer(double(label), pattern);
           
        % initial image
        tic; % time begin 
        input = im2single(bilinear(mosaic)); % single
        if gpu
            input = gpuArray(input);
        end
        % demosaick
        inputG = input(:,:,2);
        inputRB = cat(3,input(:,:,1),input(:,:,3));
        net.eval({'inputG',inputG,'inputRB',inputRB});
        
        outputRBG = gather(squeeze(gather(net.vars(outRGB).value)));
        output = cat(3, outputRBG(:,:,1),outputRBG(:,:,3),outputRBG(:,:,2));
        % time statistic
        demosaic_time = toc; 
        % only count Kodak and McMaster
        if strcmp(datasetCur,'POLYU_SET') ~= 1   
            runtime = runtime + demosaic_time;
        end
        
        % post processing
        output = output * 255;
        output = remosaic_bayer(output,mosaic,pattern);
        output = clip(output,0,255);
       
        
        % imshow(output);

        % evaluation
        label = double(label);
        output = double(output);
        psnr =  impsnr(output, label, 255, 10);
        cpsnr = imcpsnr(output, label, 255, 10);
        resPsnr(iDataset, 1:3) = resPsnr(iDataset, 1:3) + psnr;
        resPsnr(iDataset, 4) = resPsnr(iDataset, 4) + cpsnr;
        
    end
    resPsnr(iDataset, :)./ numImgDataset
end
runtime