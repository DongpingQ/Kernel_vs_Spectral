function label = knKmeans(X, init)
% kernel kmeans clustering.
% Input:
%   ktype:  kernel type:
%   X:
%   init:   initial label: 1 x n
% Output:
%   label: 1 x n clustering result
n = size(X,1);
% sigma=45;
%     D = bsxfun(@plus, dot(X,X,2), dot(X,X,2)') - 2*(X*X');
%     K = exp(D/(-2*sigma^2));

% Aff=zeros(n,n);
% D=zeros(n,n);
% 
% for i=1:n   
%     for j=i+1:n
%         Aff(i,j) = exp(-norm(X(i,:)-X(j,:))^2/(2*sigma^2));
%         Aff(j,i) = Aff(i,j);
%     end
%     Aff(i,i)=1;
% end
% K=Aff;
% for i=1:n
%     D(i,i) = sum(Aff(i,:));
% end
% di=diag(D);
% di_old=di';
% di=di.^(-1);
% DD=diag(di);
% K=DD*Aff*DD + (0.2)*DD;
%  chol(K);
% K = (1 + X*X').^2;
 K = X*X';
label = init;        % output label
w = ones(1,n);       % weights
%  w=di_old;
last = zeros(1,n);   % for checking convergence
count = 0;
while any(label ~= last) && count < 10000
    [~,~,last(:)] = unique(label);   % remove empty clusters
    E = sparse(last,1:n,w);          % k x n assignment matrix
    E = E./sum(E,2);
    T = E*K;
    [~,label] = max(T-dot(T,E,2)/2,[],1);
    count = count + 1;
end
count
end
