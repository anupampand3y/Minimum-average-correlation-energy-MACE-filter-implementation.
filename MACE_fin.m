clc;

dd=100;

path1='findataset\imgcatg\ClassA';
path2='findataset\imgcatg\ClassB';
path3='findataset\imgcatg\ClassC';
path4='findataset\imgcatg\ClassD';
path5='findataset\imgcatg\ClassE';

test=imread('p1.tif');
J = imresize(test, [dd dd]);
J1 = abs(fftshift(fft2(J)));

H1=filt(path1);
R=J1.*H1;
[xxx yyy]=find(max(max(R))==R);
Region=R(xxx-10:xxx+9,yyy-10:yyy+9);
Region(8:12,8:12)=zeros(5);
R1=Region;
peak_value=max(max(abs(R1)));  %For computing PEAK from all elements
mean_value=mean(R1,'all');  %For mean of all elements
std_dev=std2(R1);
PSR(1)=(peak_value-mean_value)/std_dev;

H2=filt(path2);
S=J1.*H2;
[xxx yyy]=find(max(max(S))==S);
Region=S(xxx-10:xxx+9,yyy-10:yyy+9);
Region(8:12,8:12)=zeros(5);
S1=Region;
peak_value=max(max(abs(S1)));  %For computing PEAK from all elements
mean_value=mean(S1,'all');  %For mean of all elements
std_dev=std2(S1);
PSR(2)=(peak_value-mean_value)/std_dev;

H3=filt(path3);
T=J1.*H3;
[xxx yyy]=find(max(max(T))==T);
Region=T(xxx-10:xxx+9,yyy-10:yyy+9);
Region(8:12,8:12)=zeros(5);
T1=Region;
peak_value=max(max(abs(T1)));  %For computing PEAK from all elements
mean_value=mean(T1,'all');  %For mean of all elements
std_dev=std2(T1);
PSR(3)=(peak_value-mean_value)/std_dev;

H4=filt(path4);
U=J1.*H4;
[xxx yyy]=find(max(max(U))==U);
Region=U(xxx-10:yyy+9,xxx-10:yyy+9);
Region(8:12,8:12)=zeros(5);
U1=Region;
peak_value=max(max(abs(U1)));  %For computing PEAK from all elements
mean_value=mean(U1,'all');  %For mean of all elements
std_dev=std2(U1);
PSR(4)=(peak_value-mean_value)/std_dev;

H5=filt(path5);
V=J1.*H5;
[xxx yyy]=find(max(max(V))==V);
Region=V(xxx-10:yyy+9,xxx-10:yyy+9);
Region(8:12,8:12)=zeros(5);
V1=Region;
peak_value=max(max(abs(V1)));  %For computing PEAK from all elements
mean_value=mean(V1,'all');  %For mean of all elements
std_dev=std2(V1);
PSR(5)=(peak_value-mean_value)/std_dev;

maximum = max(PSR);
class=find(PSR==maximum);
figure(1);
surf(abs(ifftshift(ifft2(R))));
figure(2);
surf(abs(ifftshift(ifft2(S))));
figure(3);
surf(abs(ifftshift(ifft2(T))));
figure(4);
surf(abs(ifftshift(ifft2(U))));
figure(5);
surf(abs(ifftshift(ifft2(V))));
str1 = "Pic belongs to class-> ";
str2 = int2str(class);
str=append(str1,str2)
msgbox(str,'Success')



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
    ZZZ=fftshift(fft(double(K)));
    X(:,nn)=fftshift(ZZZ); 
end

tbl=size(X);
d=tbl(1,1);
%For diag mat Di of dxd, whose diagonal elements are "mag of squared 
%associated element Xi" i.e. power spectrum of input images.
D = diag(mean(abs(X).^2,2));
u=ones(N,1);
h = inv(D)*X*(inv((ctranspose(X))*inv(D)*X))*u;   
H = abs(reshape(h, size(J)));
end