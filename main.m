clear;close all; clc;
addpath(genpath(pwd));

I = imread('case1.jpg');
I = imresize(I,0.5);
YUV = rgb2ycbcr(I);
Y = YUV(:,:,1);

%% train GMM
Y = im2double(Y);

NEW_RAIN_GMM = true;
if (NEW_RAIN_GMM)
    rainModel = onlineGMM(Y,20);
else
    rainModel = load('rain_offline.mat');
end
load ('GSModel_8x8_200_2M_noDC_zeromean.mat'); %pre trained model
bcgdModel = GS;
clear GS;

tic,
[B_out R_out] = GMM_Decomp(Y, bcgdModel, rainModel);
toc,

YUV(:,:,1) = im2uint8((B_out));
figure,imshow(ycbcr2rgb(YUV));
figure,imshow(R_out+0.5);

