close all
clear all
clc

N=65;
w1=window(@rectwin,N);
w2=window(@hann,N);
w3=window(@hamming,N);
w4=window(@blackman,N);
w5 = kaiser(N+1,3.4033);
wvtool(w1,w2,w3,w4,w5)