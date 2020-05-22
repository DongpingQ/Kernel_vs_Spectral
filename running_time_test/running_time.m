function time = running_time(downsample, type, nColors)
    he = imread('peppers.png');
    dwsamp = downsample;
    he = he(1:dwsamp:end,1:dwsamp:end,:);


    cform = makecform('srgb2lab');
    lab_he = applycform(he,cform);
    ab = double(lab_he(:,:,1:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,3);


%     nColors = 5;
    n = size(ab,1);

    init = ceil(nColors*rand(1,n));

    tic
    if type == 1
        label = knKmeans(ab,init);
    elseif type == 2
        label = spectral_clustering_NJW(ab,nColors);
    else
        label = kmeans(ab,nColors);
    end
    time = toc;
end

