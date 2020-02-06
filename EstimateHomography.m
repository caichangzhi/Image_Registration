% function: Estimate Homography
% Input: Two matrixs including n points
% Output: H matrix and indice of registration margin points

function [H, corPtsIdx] = EstimateHomography(points1, points2)
% Set related RANSAC coefficients
coef.minPtNum = 4;
coef.iterNum = 30;
coef.thDist = 4;
coef.thInlrRatio = .1;
% Using RANSAC function to get H matrix and indice of registration margin points 
[H, corPtsIdx] = ransac1(points1, points2, coef, @solveHomo, @calcDist);
end

% Using H to project points1 to points3, 
% Calcultating the distances between points2 and points3
function distance = calcDist(H,points1,points2)
% Get the size of matrix of points1
n = size(points1,2);
points3 = H / H(end) * [points1;ones(1,n)];
points3 = points3(1:2,:)./repmat(points3(3,:),2,1);
distance = sum((points2-points3).^2,1);
end