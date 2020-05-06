function [IDX,D]=spectral_SM(X,k)
% first calculate affinity matrix
% set the parameters
n=length(X);
sigma = 5;
Aff=zeros(n,n);
D=zeros(n,n);

for i=1:n   
    for j=i+1:n
        Aff(i,j) = exp(-norm(X(i,:)-X(j,:))^2/(2*sigma^2));
        Aff(j,i) = Aff(i,j);
    end
end


for i=1:n
    D(i,i) = sum(Aff(i,:));
end
L=D-Aff;
% di=diag(D);
% di=1./di;
% DD=diag(di);
% L=DD*L;


% perform the eigen value decomposition
% [evecs,evals]=eig(L);
% [D,ind]=sort(diag(evals),'descend');
% Vs=evecs(:,ind);
% U=Vs(:,1:k);
[U,~] = eigs(L,D,k,'SA');% k smallest eigenvalues/vectors

% perform kmeans clustering on the matrix U
[IDX,C] = kmeans(U,k); 
end