rng('default') % For reproducibility

% Parameters for data generation
N = 300;  % Size of each cluster
r1 = 2;   % Radius of first circle
r2 = 4;   % Radius of second circle
theta = linspace(0,2*pi,N)';

X1 = r1*[cos(theta),sin(theta)]+ rand(N,1);
X2 = r2*[cos(theta),sin(theta)]+ rand(N,1);
X = [X1;X2]; % Noisy 2-D circular data set

%% Kernel K-means
k = 2;
n = length(X);
sigma=0.36;
nbh=7;
init = ceil(k*rand(1,n));

%label = spectral_SM(X,k,sigma);
% label = spectral_NJW(X,k,sigma);
%  label = spectral_NJW_self_tuning(X,k,ngh);
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