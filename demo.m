clear
close all
k = 3;
n = 100;

X1 = [randn(n,1)*0.75 + ones(n,1) randn(n,1)*0.25 + ones(n,1)];
X2 = [randn(n,1)*0.50 - ones(n,1) randn(n,1)*0.50 - ones(n,1)];
X3 = [randn(n,1)*0.25 + ones(n,1) randn(n,1)*0.75 - ones(n,1)];
X = [X1;X2;X3];
%% Kernel K-means
init = ceil(k*rand(1,k*n));
label = knKmeans(X,init);



color = 'brgmcyk';
m = length(color);
c = max(label);

figure(1)
for i = 1:c
    idx = (label==i);
    scatter(X(idx,1),X(idx,2),36,color(i));
    hold on
end
axis image
%% Spectral (Ng,Jordan,Weiss)
sigma=0.36;
label2 = spectral_NJW(X,k,sigma);

figure(2)
for i = 1:c
    idx = (label2==i);
    scatter(X(idx,1),X(idx,2),36,color(i));
    hold on
end
axis image

%% Spectral (Shi and Malik)
label3=spectral_SM(X,k,sigma);
figure(3)
for i = 1:c
    idx = (label3==i);
    scatter(X(idx,1),X(idx,2),36,color(i));
    hold on
end
axis image
