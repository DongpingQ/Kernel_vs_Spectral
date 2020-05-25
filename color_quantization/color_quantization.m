clear
close all
clc
%
he = imread('peppers.png');
% he = imread('bird.jpg');

% dwsamp = 8;
% he = he(1:dwsamp:end,1:dwsamp:end,:);
he=imresize(he,[60,80]);
figure(1)
imshow(he,'InitialMagnification',300)
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,1:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,3);



%% parameters
nColors = 5;
n = size(ab,1);
sigma=15;
nbh=1000;
%% imsegkemans
[L,C] = imsegkmeans(he,nColors);
J = label2rgb(L,im2double(C));
figure(2)
imshow(J,'InitialMagnification',300)
%% kernel kmeans
init = ceil(nColors*rand(1,n));
label2 = knKmeans(ab,init);
%% spectral

% [label,~] = spectral_NJW_self_tuning(ab,nColors,nbh);
%  label = spectral_SM(ab,nColors,sigma);
label = spectral_NJW(ab,nColors,sigma);

%% computing centroid on R,G,B given labels from either method
pixel_labels = reshape(label,nrows,ncols);
x=nrows;y=ncols;
C2=zeros(nColors,3);
R=he(:,:,1);
G=he(:,:,2);
B=he(:,:,3);
for k=1:nColors
    
    LLr=zeros(x,y);
    LLg=zeros(x,y);
    LLb=zeros(x,y);
    
    for i=1:x
        for j=1:y
            if pixel_labels(i,j)==k
                
                LLr(i,j)=R(i,j);
                LLg(i,j)=G(i,j);
                LLb(i,j)=B(i,j);
            end
        end
    end
    count=0;
    total=0;
    for i=1:x
        for j=1:y
            if LLr(i,j)~=0
                total=total+LLr(i,j);
                count=count+1;
            end
        end
    end
    C2(k,1)=floor(total/count);
    count=0;
    total=0;
    for i=1:x
        for j=1:y
            if LLg(i,j)~=0
                total=total+LLg(i,j);
                count=count+1;
            end
        end
    end
    C2(k,2)=floor(total/count);
    count=0;
    total=0;
    for i=1:x
        for j=1:y
            if LLb(i,j)~=0
                total=total+LLb(i,j);
                count=count+1;
            end
        end
    end
    C2(k,3)=floor(total/count);
    
end
J2=label2rgb(uint8(pixel_labels),im2double(uint8(C2)));
figure(3)
imshow(J2,'InitialMagnification',300)
