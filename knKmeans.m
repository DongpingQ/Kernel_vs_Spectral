function label = knKmeans(X, init)
% kernel kmeans clustering.
% Input:
%   ktype:  kernel type:
%   X:      
%   init:   initial label: 1 x n
% Output:
%   label: 1 x n clustering result
    n = size(X,1);

    sig = 1.0;
    D = bsxfun(@plus, dot(X,X,2), dot(X,X,2)') - 2*(X*X');
    K = exp(D/(-2*sig^2));

    label = init;        % output label
    w = ones(1,n);       % weights
    last = zeros(1,n);   % for checking convergence
    count = 0;
    while any(label ~= last) && count < 1000
        [~,~,last(:)] = unique(label);   % remove empty clusters
        E = sparse(last,1:n,w);          % k x n assignment matrix
        E = E./sum(E,2);
        T = E*K;
        [~,label] = max(T-dot(T,E,2)/2,[],1);
        count = count + 1;
    end
end
