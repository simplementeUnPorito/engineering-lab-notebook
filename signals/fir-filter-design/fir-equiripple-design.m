close all
clear all
clc
L = 25;
h = fir1(L-1,0.15,'low',window(@hamming,L));
freqz(h,1)