% Limpieza de variables usadas y memoria del Matlab
clear all;
clc ;
close all;

% Ingreso de los valores
x1=[1 2 3 4 5];
x2=[10 2 3 2 1];
data = enviarSerial(x1,x2,'COM10');

l = length(data);
n =[0:1: l-1];
figure;
subplot(211);         
stem (n,data,'r');
% para la comprobación verificamos con la funcion de convolucion ya
% implementada en el matlab
data2 = conv(x1,x2);
subplot(212);
stem(n, data2, 'b');

% fclose ( s ) ; %desconecta o cierra el puerto
% delete ( s ) ; %borra de la memoria los datos del puerto
% clear s ; %borra los datos del puerto