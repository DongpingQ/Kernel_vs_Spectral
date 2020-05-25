function [IDX,C]=spectral_NJW_self_tuning(X,k,nbh)
% first calculate affinity matrix
% set the parameters
n=length(X);
Aff=zeros(n,n);
D=zeros(n,n);
sigma=zeros(n,1);
for i=1:n
    [idx,D]=knnsearch(X,X(i,:),'K',nbh);
    sigma(i)=D(nbh);
end
for i=1:n
    for j=i+1:n
        Aff(i,j) = exp(-norm(X(i,:)-X(j,:))^2/(sigma(i)*sigma(j)));
        Aff(j,i) = Aff(i,j);
    end
    
end


for i=1:n
    D(i,i) = sum(Aff(i,:));
end

di=diag(D);
di=di.^(-1/2);
DD=diag(di);
L=DD*Aff*DD;


% perform the eigen value decomposition
[U,~] = eigs(L,k,'LA');% k largest eigenvalues/vectors

% construct the normalized matrix U from the obtained eigenvectors
U = bsxfun(@rdivide, U, sqrt(sum(U.^2, 2)));

% perform kmeans clustering on the matrix U
[IDX,C] = kmeans(U,k);
end