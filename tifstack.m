function vol = tifstack(tifPath)
% TIFSTACK takes a directory of tif images and combines them in an image stack
% TIFPATH is the path of the directory containing tif images

list = dir(tifPath);
list = list(3:end); %trim '.' and '..'

%get image dimensions by loading first image
slice = imread(fullfile(tifPath, list(1).name));

n = numel(list); % number of images in directory
X = size(slice, 1);
Y = size(slice, 2);
vol = zeros(X,Y,n);
for i = 1:n
	vol(:,:,i) = imread(fullfile(tifPath, list(i).name));
end

end