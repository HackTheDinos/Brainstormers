%read in the stl file
polygons = stlread('Brainstormers/data/zanabazar.stl');

%convert to voxels
%  size is currently hardcoded, should be detected automatically from polygons.vertices
%  'auto' refers to conversion of face/vertex coordinates to voxel coordinates, particularly when they are outside the range of our voxels
vol = polygon2voxel(polygons, [160 160 160], 'auto');

%draw the 'on' voxels simply (sanity check)
[x,y,z] = ind2sub([160 160 160], find(vol));
figure
scatter3(x,y,z)
figure
scatter3(x(y == 40), y(y == 40), z(y == 40))