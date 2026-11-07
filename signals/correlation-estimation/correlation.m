clear
close all;

x = [1 2 3 4 5];
h = [1 -1];

y = conv(x,h);
g = xcorr(x,h);
gs = xcorr(h,x);

N = 512;
x2 = randn(1,N);
figure(1)
stem(x2)

y2 = xcorr(x2);
figure(2)
stem(y2)

