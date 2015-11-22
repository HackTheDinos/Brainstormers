function [x,y,z] = skullsegmentation(vol, noiseThresh, draw)
%SKULLSEGMENTATION finds all edges in a 3D volume of a skull
%
%[x, y, z] = SKULLSEGMENTATION(vol, noiseThresh, draw)
%	x,y,z are column vectors of the same size which together form
%	a sparse matrix of all edge points in the volume
%
%inputs:
%	vol := a 3D matrix
%	[noiseThresh] := (optional) all elements of vol < noiseThresh are set to 0
%	[draw] := flag for whether or not to plot results


if nargin < 2
	noiseThresh = 75;
end

if nargin < 3
	draw = true;
end

%gaussian noise should be removed, if possible
if noiseThresh > 0
	vol(vol < noiseThresh) = 0;
end

%on our machine, we couldn't run the edge detection on the entire volume at once
%the edge matrix returned is too large to fit in memory, but on a stronger machine, this loop
%would probably be unnecessary
%basically, it is taking ~200 slices at a time, finding edges in all of them,
%then keeping the middle 150 (more for the first/last iteration) and stacking them up
%we overlap between iterations so that the edges that we keep are generally connected
X = size(vol, 1);
Y = size(vol, 2);
nslices = size(vol, 3);
sliceMin = 1;
x = []; y = []; z = [];
figure; hold on
xlim([1,size(vol,1)])
ylim([1,size(vol,2)])
while sliceMin < nslices
	%[sliceMin, sliceMax] are the slices we run for this iteration
	sliceMax = min(sliceMin + 200, nslices);
	%the parameters used in cannybelow are the result of extensive, computationally expensive hand tuning
	%on the Gavia data. The most important parameter to tweak is the 0.6 used in TValue
	res = canny(vol, [1 1 1], 'TMethod', 'relMax', 'TValue', [0.6, 0.9], 'SubPixel', false, 'Region', [1, X, 1, Y, sliceMin, sliceMax]);

	%convert to x,y,z
	[res_x,res_y,res_z] = ind2sub(size(res), find(res));
	res_z = res_z + sliceMin;
	
	%trim to center ~150
	if sliceMin == 1
		slices = res_z < sliceMax - 25;
		res_x = res_x(slices);
		res_y = res_y(slices);
		res_z = res_z(slices);
	elseif sliceMax == nslices
		slices = res_z > sliceMin + 25;
		res_x = res_x(slices);
		res_y = res_y(slices);
		res_z = res_z(slices);
	else
		slices = and(res_z > sliceMin + 25, res_z < sliceMax - 25);
		res_x = res_x(slices);
		res_y = res_y(slices);
		res_z = res_z(slices);
	end

	%append
	x = [x;res_x];
	y = [y;res_y];
	z = [z;res_z];

	if draw
		plot3(res_x,res_y,res_z,'.')
	end

	if sliceMax >= nslices
		break
	end

	%increment so that overlapping regions are computed correctly
	sliceMin = sliceMin + 150;
end

%draw the final plot
if draw
	figure
	plot3(x,y,z,'.')
	xlim([1,size(vol,1)])
	ylim([1,size(vol,2)])
end

end

%OLD DRAW/PLOT METHODS
% figure
% imagesc(e.im(:,:,50))

% kernel = struct('type','rbf','para',3);
% K = INys(kernel,[x y z], 1000, 'r');

% return

% edgeindices = find(e.edge);
% K = rbf([x y z], 3);
% K = double(rbf([x y z im3(sub2ind(size(im3),x,y,z))], 20));
% labels = knkmeans(K, 3);

% newim = zeros(size(e.edge));
% newim(edgeindices) = labels;

% figure
% colormap('prism')
% h = vol3d('cdata', newim);