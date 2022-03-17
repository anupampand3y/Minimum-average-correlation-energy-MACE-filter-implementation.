function H = filt(path)
filenames=dir(fullfile(path,'*.tif'));
noi=numel(filenames);   %number of images
dd=100;       %required diamention of pics

%For matrix X  "X is FFT of training input images in column vectors"
N=noi-4;     %No. of training images
for nn = 1:N
    f=fullfile(path, filenames(nn).name);
    our_images=imread(f);
    
    [m n] = size(our_images) ;
    J = imresize(our_images, [dd dd]); 
    K=reshape(J,[],1);
    X(:,nn)=fft2(double(K)); 
end

tbl=size(X);
d=tbl(1,1);
%For diag mat Di of dxd, whose diagonal elements are "mag of squared 
%associated element Xi" i.e. power spectrum of input images.
D = diag(mean(abs(X).^2,2));
u=ones(N,1);
h = inv(D)*X*(inv((ctranspose(X))*inv(D)*X))*u;   
H = reshape(h, size(J));
