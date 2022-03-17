clc;
close all;
clear all;
warning off;
path='try2';
filenames=dir(fullfile(path,'*.tif'));
noi=numel(filenames);   %number of images
dd=100;         %required diamention of pics

%For matrix X  "X is FFT of training input images in column vectors"
N=noi-4;     %No. of training images
D=zeros(10000);
for nn = 1:N
    f=fullfile(path, filenames(nn).name);
    our_images=imread(f);
    
    [m n] = size(our_images) ;
    J = imresize(our_images, [dd dd]); 
    
    K=reshape(J,[],1);
    ZZZ=fftshift(fft(double(K)));
    D=D+diag((abs(fft(K)).^2));
    X(:,nn)=ZZZ; 
end
D=D./N;
tbl=size(X);
d=tbl(1,1);
%For diag mat Di of dxd, whose diagonal elements are "mag of squared 
%associated element Xi" i.e. power spectrum of input images.
D = diag(mean(abs(X).^2,2));
u=ones(N,1);
h = inv(D)*X*inv(ctranspose(X)*inv(D)*X)*u;   
H = reshape(h, size(J));


test1=imread('p1.tif');
test2=imread('p2.tif');
K1=imresize(test1, [dd dd]);
K2=imresize(test2, [dd dd]);
J1=fftshift(fft2(abs(K1)));
J2=fftshift(fft2(abs(K2)));

% J1 = imresize(test1, [dd dd]); 
% J2 = imresize(test2, [dd dd]); 

result1=abs(J1).*abs(H);
%result2=J2.*H;

result11=ifft2(result1);
%result12=ifft2(result2);

figure(1);
surf(abs(ifftshift(result11)));
% subplot(212);
% surf(abs(ifftshift(result12)));