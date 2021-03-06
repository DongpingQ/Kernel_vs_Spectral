clear
close all
clc

%% downsampling
he = imread('peppers.png');
% dwsamp = 4;
% he = he(1:dwsamp:end,1:dwsamp:end,:);

%% orignal figure
figure(1)
subplot(2,3,1)
imshow(he), title('H&E image');
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,1:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,3);

%% clustering in 5 classes
nColors = 5;
n = size(ab,1);

init = ceil(nColors*rand(1,n));

% label = knKmeans(ab,init);
% label = kmeans(ab,nColors);
label = spectral_clustering_NJW(ab,nColors);
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

%% running time
num = 5;
nlist = zeros(num,1);
time_kmeans = zeros(num,1);
time_spectr = zeros(num,1);
for i = 1:num
    nlist(i) = 16-2*i;
    type = 1;
    time_kmeans(i) = running_time(16-2*i,type,nColors);
    type = 2;
    time_spectr(i) = running_time(16-2*i,type,nColors);
end

%% plotting
plot(uint16(nrows*ncols./nlist), time_kmeans,'-ob','LineWidth',3)
hold on
plot(uint16(nrows*ncols./nlist), time_spectr,'-or','LineWidth',3)
hold off
xlabel('image size')
ylabel('time/sec')
title('running time: kmeans v.s. spectral')
legend('k-means','spectral','Location','northwest')

%% number of clusters
num = 5;
nlist = zeros(num,1);
time_kmeans = zeros(num,1);
time_spectr = zeros(num,1);
for i = 1:num
    nlist(i) = 2^i;
    type = 1;
    time_kmeans(i) = running_time(4,type,2^i);
    type = 2;
    time_spectr(i) = running_time(4,type,2^i);
end

%% plotting
plot(nlist, time_kmeans,'-ob','LineWidth',3)
hold on
plot(nlist, time_spectr,'-or','LineWidth',3)
hold off
xlabel('number of clusters')
ylabel('time/sec')
title('running time: kmeans v.s. spectral')
legend('k-means','spectral','Location','northwest')