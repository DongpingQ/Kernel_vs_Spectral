clear
close all
clc

he = imread('peppers.png');
dwsamp = 8;
he = he(1:dwsamp:end,1:dwsamp:end,:);

figure(1)
subplot(2,3,1)
imshow(he), title('H&E image');
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,1:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,3);


% [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
% 	'Replicates',5);

nColors = 5;
n = size(ab,1);

init = ceil(nColors*rand(1,n));

label = knKmeans(ab,init);
pixel_labels = reshape(label,nrows,ncols);


% subplot(2,3,2)
% imshow(pixel_labels,[]), title('image labeled by cluster index');
segmented_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
	color = he;
	color(rgb_label ~= k) = 0;
	segmented_images{k} = color;
end

for i = 2:2+nColors-1
    subplot(2,3,i)
    imshow(segmented_images{i-1}), title(['objects in cluster ' num2str(i-1)]);
end