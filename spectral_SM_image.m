function [IDX,C]=spectral_SM_image(im,k,r,s1,s2)



% resizing to avoid out of memory error
% im_gray=rgb2gray(im);
im_hsv=rgb2hsv(im);
[m,n,~]=size(im_hsv);
ab = reshape(im_hsv,m*n,3);
ind=1:m*n;
nn=m*n;
[I,J]=ind2sub([m,n],ind);
% linear indexing to speed up the partitioning
% vectoring the pixel nodes

for i=1:nn
%     F(i)=double(im_gray(ind(i)))/255;
      hsv=ab(i,:);
      h=hsv(1);s=hsv(2);v=hsv(3);
      F{i}=[v,v*s*sin(h),v*s*cos(h)];
end
Aff=zeros(nn,nn);
D=zeros(nn,nn);


% computing the weight matrix
for i=1:nn
    x1=I(i);
    y1=J(i);
    Aff(i,i)=0;
    for j=i+1:nn
        
        
            x2=I(j);
            y2=J(j);
            dist=((x1-x2)^2 + (y1-y2)^2);
            if sqrt(dist)>=r
                dx=0;
            else
                dx=exp(-((dist)/(s1^2)));
            end
            
            pdiff=norm(F{i}-F{j})^2;
            di=exp(-((pdiff)/(s2^2)));
            Aff(i,j)=di*dx;
            Aff(j,i)=Aff(i,j);
        
    end
end

for i=1:nn
    D(i,i) = sum(Aff(i,:));
end
L=D-Aff;
[U,~] = eigs(L,D,k,'SA');% k smallest eigenvalues/vectors

% perform kmeans clustering on the matrix U
[IDX,C] = kmeans(U,k);
end

