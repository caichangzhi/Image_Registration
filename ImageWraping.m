% function: ImageWraping
% Input: Two input images img1, img2 and adjColor
% Output: The wrapped image

function [outImg] = ImageWraping(img1, img2, adjColor)
% Find the corresponding points
[corPoints1, corPoints2] = CorrespondingPoints(img1, img2);
% Estimate the homography
[H, corPtsIdx] = EstimateHomography(corPoints2', corPoints1');

% Show the H matrix after DLT transformation
H1 = solveHomo(corPoints2', corPoints1');
fprintf('%s\n','After DLT');
H1  %#ok
% Show the H matrix after DLT normalization
H2 = H1/H1(end);
fprintf('%s\n','After DLT normalize');
H2  %#ok
% Show the H matrix after DLT normalization and RANSAC
fprintf('%s\n','After RANSAC');
H3 = H/H(end);  
H3  %#ok

tform = projective2d(H');      % Create a projective transformation
img21 = imwarp(img2,tform);    % Reproject img2
figure,imshow(img1)
figure,imshow(img21)

% Adjust color or grayscale linearly, using corresponding infomation
[M1, N1, dim] = size(img1);
[M2, N2, ~] = size(img2);
if exist('adjColor','var') && adjColor == 1
	radius = 2;
	x1ctrl = corPoints1(corPtsIdx,1);
	y1ctrl = corPoints1(corPtsIdx,2);
	x2ctrl = corPoints2(corPtsIdx,1);
	y2ctrl = corPoints2(corPtsIdx,2);
	ctrlLen = length(corPtsIdx);
	s1 = zeros(1,ctrlLen);
	s2 = zeros(1,ctrlLen);
	for color = 1:dim
		for p = 1:ctrlLen
			left = round(max(1,x1ctrl(p)-radius));
			right = round(min(N1,left+radius+1));
			up = round(max(1,y1ctrl(p)-radius));
			down = round(min(M1,up+radius+1));
			s1(p) = sum(sum(img1(up:down,left:right,color))); % Take the brightness of the four points
		end
		for p = 1:ctrlLen
			left = round(max(1,x2ctrl(p)-radius));
			right = round(min(N2,left+radius+1));
			up = round(max(1,y2ctrl(p)-radius));
			down = round(min(M2,up+radius+1));
			s2(p) = sum(sum(img2(up:down,left:right,color)));
		end
		sc = (radius*2+1)^2*ctrlLen;
		adjcoef = polyfit(s1/sc,s2/sc,1);
		img1(:,:,color) = img1(:,:,color)*adjcoef(1)+adjcoef(2);
	end
end

% Do the warping
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

[M3, N3, ~] = size(img21);
outImg(up:up+M3-1,left:left+N3-1,:) = img21;
% Show img1 is above img21
outImg(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;
end
