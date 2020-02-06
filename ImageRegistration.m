% ECE 278 Project #1 Image Registration
% Name: Changzhi Cai
% Perm Number: 9911579
% Date: 10/31/2019
% Discription: In this project you will implement an end-to-end image registration system. Your system
%              must be capable of aligning image pairs to a common coordinate system. The project is
%              divided into different steps (roughly one for each module of the system)
% sift.m: http://pages.cs.wisc.edu/~vmathew/cs766-proj2/sift.html
% ransac1.m: http://read.pudn.com/downloads630/sourcecode/math/2557125/ransac1.m__.htm
% solveHomo.m: https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/51125/versions/1/previews/solveHomo.m/index.html

%%
clear
close all

% img1 = imread('phys_sci_n_1.png');
% img2 = imread('phys_sci_n_2.png');
% img1 = imread('auhll_center_1.png');
% % img1 = imresize(img1, [655 1008]);
% img2 = imread('auhll_center_2.png');
% img2 = imresize(img2, [377 873]);
img1 = imread('graffiti_2.png');
img2 = imread('graffiti_1.png');

outImg = ImageWraping(img1, img2, 1);
figure,imshow(outImg)