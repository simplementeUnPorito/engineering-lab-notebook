close all
clear all
clc
%Frecuencias Hz
fm = 100e3;
fp = [7.5e3, 17.5e3];
fs = [10e3, 15e3];
Rp = 1;
Rs = 80;

%Frecuencias en rad/s discretos
fn = fm/2;
wp = fp/fn*pi;
ws = fs/fn*pi;

%frecuencias en rad/s continuos
Op = tan(wp./2);
Os = tan(ws./2);

%Calculos
[N,Oc] = ellipord(Op,Os,Rp,Rs,'s');
[B,A]  = ellip(N,Rp,Rs,Oc,'stop','s');
[Bd,Ad] = bilinear(B,A,0.5);
figure;
freqz(Bd,Ad)
[Bdir,Adir] = ellip(N,Rp,Rs,2*atan(Oc)/pi,'stop');
figure;
freqz(Bdir,Adir)