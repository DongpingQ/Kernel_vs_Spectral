function label = spectral_clustering_NJW(X, k)
% first calculate affinity matrix
% set the parameters
    n = length(X);
    
    sigma = 20;
    A = bsxfun(@plus, dot(X,X,2), dot(X,X,2)') - 2*(X*X');
    K = exp(A/(-2*sigma^2));
    Kd = diag(K);
    Aff = - diag(Kd) + K;
    
    D = diag(sum(Aff,1));
    DD = diag(diag(D).^(-1/2));
    L = DD * Aff * DD;

    % perform the eigen value decomposition
    [U,~] = eigs(L,k);% k largest eigenvalues/vectors

    % construct the normalized matrix U from the obtained eigenvectors
     U = bsxfun(@rdivide, U, sqrt(sum(U.^2, 2)));

    % perform kmeans clustering on the matrix U
    [label,~] = kmeans(U,k); 
end