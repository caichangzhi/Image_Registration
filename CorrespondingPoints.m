% function CorrespondingPoints
% Input: Two input images img1 and img2
% Output: The result of corresponding points' location in both two images

function [corPoints1, corPoints2] = CorrespondingPoints(img1, img2)

% Using SIFT to find descriptors and locations of keypoints for both images
[descriptors1, locs1] = sift(img1);
[descriptors2, locs2] = sift(img2);

% distRatio: Only keep corresponding where the ratio of vector angles from the
% nearest to second nearest neighbor is less than distRatio, we set it 0.6.
distRatio = 0.6;   

% For each descriptor in the first image, search its corresponding to second image.
descriptors2t = descriptors2';                     % Compute matrix transpose
corTable = zeros(1,size(descriptors1,1));
for i = 1 : size(descriptors1,1)
   dotprods = descriptors1(i,:) * descriptors2t;   % Computes vector of dot products
   [vals,index] = sort(acos(dotprods));            % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times second nearest neighbor.
   if (vals(1) < distRatio * vals(2))
      corTable(i) = index(1);
   else
      corTable(i) = 0;
   end
end

% Create a new image showing the two images side by side and its corresponding points. 
% Select the image with the fewer rows and fill in enough empty rows
% to make it the same height as the other one.
rows1 = size(img1,1);
rows2 = size(img2,1);
if (rows1 < rows2)
     img1(rows2,1) = 0;
else
     img2(rows1,1) = 0;
end
img3 = [img1 img2]; % Append both images side-by-side.   

% Show a figure with lines joining the accepted correspondings.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);        % Display image3 with scaled colors
hold on;
cols1 = size(img1,2); % Size of image1 in 2 dimensions 
for i = 1: size(descriptors1,1)
  if (corTable(i) > 0)
    line([locs1(i,2) locs2(corTable(i),2)+cols1], ...
         [locs1(i,1) locs2(corTable(i),1)], 'Color', 'c');
  end                % Link the corresponding points with lines
end
hold off;
num = sum(corTable > 0);
fprintf('Found %d matches.\n', num);

% Find the locations of corresponding points and store them.
index1 = find(corTable);
index2 = corTable(index1);
x1 = locs1(index1,2);
x2 = locs2(index2,2);
y1 = locs1(index1,1);
y2 = locs2(index2,1);
corPoints1 = [x1,y1];
corPoints2 = [x2,y2];
end