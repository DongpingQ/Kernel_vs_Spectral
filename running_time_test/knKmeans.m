function label = knKmeans(X, init)
% kernel kmeans clustering.
% Input:
%   X:      data points:   n x d    
%   init:   initial label: 1 x n
% Output:
%   label: 1 x n clustering result
    n = size(X,1);

%     sigma = 50;
%     A = bsxfun(@plus, dot(X,X,2), dot(X,X,2)') - 2*(X*X');
%     K = exp(A/(-2*sigma^2));
%     Kd = diag(K);
%     K = - diag(Kd) + K;
%     K = (1 + X*X').^2;
%     K = X*X';

%     D = sum(Adj,1);
%     DD = diag(D.^(-1/2));
%     DI = diag(D.^(-1));
%     delta = 0.5;
%     K = DD * Adj * DD + delta * DI;
    
    label = init;        % output label
    w = ones(1,n);       % weights
%     w = D;       % weights
    last = zeros(1,n);   % for checking convergence
    count = 0;
    while any(label ~= last) && count < 1000
        [~,~,last(:)] = unique(label);   % remove empty clusters
        E = sparse(last,1:n,w);          % k x n assignment matrix
        E = E./sum(E,2);
        R = E*X;
        T = R*(X');
%         T = E*K;
        [~,label] = max(T-dot(T,E,2)/2,[],1);
        count = count + 1;
    end
    count
end
