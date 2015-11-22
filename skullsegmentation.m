function [x,y,z] = skullsegmentation(vol, noiseThresh, draw)

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

X = size(vol, 1);
Y = size(vol, 2);
nslices = size(vol, 3);
sliceMin = 1;
x = []; y = []; z = [];
figure; hold on
xlim([1,size(vol,1)])
ylim([1,size(vol,2)])
while sliceMin < nslices
	sliceMax = min(sliceMin + 200, nslices);
	res = canny(vol, [1 1 1], 'TMethod', 'relMax', 'TValue', [0.6, 0.9], 'SubPixel', false, 'Region', [1, X, 1, Y, sliceMin, sliceMax]);
	[res_x,res_y,res_z] = ind2sub(size(res), find(res));
	res_z = res_z + sliceMin;
	% res_z = [sliceMin:sliceMax]';
	% res_x = sliceMin.*ones(numel(res_z),1);
	% res_y = sliceMin.*ones(numel(res_z),1);
	%trim
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

	x = [x;res_x];
	y = [y;res_y];
	z = [z;res_z];

	if draw
		plot3(res_x,res_y,res_z,'.')
	end

	if sliceMax >= nslices
		break
	end

	sliceMin = sliceMin + 150;
end
% e.im = double(e.edge);
if draw
	% [x,y,z] = ind2sub(size(edges), find(edges));
	figure
	plot3(x,y,z,'.')
	xlim([1,size(vol,1)])
	ylim([1,size(vol,2)])
end

end

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