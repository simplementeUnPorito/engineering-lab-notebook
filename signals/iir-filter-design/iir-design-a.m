close all
clear all
clc

fm = 100e3;
fn = fm/2;
fp = 15e3;
Rp = 1;
fs = 30e3;
Rs = 30;
Op = tan(pi*fp/fn/2);
Os = tan(pi*fs/fn/2);

[N,Oc] = buttord(Op,Os,Rp,Rs,'s');
[B,A]  = butter(N,Oc,'high','s');
[Bd, Ad] = bilinear(B,A,1/2);
filtro = tf(Bd,Ad,1);
figure;
bode(filtro);
[H,w] = freqz(Bd,Ad,1024);
figure;
yyaxis right
plot(w/pi,abs(H));
ylabel('Magnitud');
yyaxis left
plot(w/pi,180/pi*angle(H));
ylabel('Fase');

xlabel('\omega/pi');

[Bdir Adir] = butter(N,2*atan(Oc)/pi,'high');
filtro = tf(Bdir,Adir,1);
figure;
bode(filtro);
[H,w] = freqz(Bd,Ad,1024);
figure;
yyaxis left
plot(w/pi,abs(H));
ylabel('Magnitud');
yyaxis right
plot(w/pi,180/pi*angle(H));
ylabel('Fase');
legend('|H(\omega)|','\angle|H(\omega)|');
grid on;
grid minor;
