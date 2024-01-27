%Systemanalyse:
clear all
close all

Kmf= 10;
Tmf= 1e-4;
Ke=0.5;
Kl=1000;
Kle1=0.2;
Kle2=1;
Tl=0.01;
Tel=1e-6;
F1=tf ([Kle1] , [Tel 1]);
F2=tf ([Kle2] , [Tel 1]);
F3=tf ([Kl] , [Tl 1]);
F4=tf ([Ke] , [0 1]);
F5=tf ([Kmf] , [Tmf 1]);
F6= F1*F3*F4*F5;
F7= F2*F3*F4*F5;

pzmap(F7)
grid on

% Reglerparameterberechung:
% Festlegung der minimalen Dämpfung und der maximalen Zeitkonstante 
% eines beispielhaften PT2-Verhaltens

% Minimale Dämpfung und maximale Zeitkonstante für einen
% beispielhaftes PT2-Verhalten

% Dateneingabe

Apo = 1100
Apu = 1000
tol=10
Kp = (Apo+Apu)/2

%Kp ist die Führungsgröße, Daher wurde es als sinnvoll erachtet, 
% ihn als Mittelpunkt des oberen und unteren Arbeitspunktes zu nehmen.

xuemax=10
Tan = 0.0004
Taus = 0.0019
T_stop=0.002
T_max=0.00005

%FPT2=tf(Kp,[T_max^2 2*D_min*T_max 1])

figure(1)
hold on
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 2) %oberes Toleranzband, rot
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 2) %unteres Toleranzband,rot
plot([0 T_stop],[Kp Kp],'g', 'LineWidth', 2) %Kp (Führungsgröße), grün
plot([0 T_stop],[Kp+xuemax Kp+xuemax],'k', 'LineWidth', 2) %maximale überschwingung, schwarz
plot([Tan Tan],[0 2000],'b', 'LineWidth', 2) %Linie: Tan, blau
plot([Taus Taus],[0 2000],'b', 'LineWidth', 2) %Linie: Taus, blau
axis([0 T_stop 950 1150])
grid

% Wie man von figure(1) sehen kann, schränkt der xuemax-Wert das obere Toleranzband stark ein. 
% Die xuemax-Linie bestimmt derzeit, wie niedrig der Dämpfungswert werden kann. 
% Um den Dämpfungswert zu minimieren und die maximale Zeitkonstante zu maximieren,
% muss man daher den Kp-Wert so weit erhöhen, dass sich die Xuemax-Linie und die 
% obere Toleranzlinie überschneiden. Neuer Wert:

Kp2=Apo+tol-xuemax

%Jetzt kann man mit der aktualisierter Werte weiter analysieren:

figure(2)
hold on
D_min=[0.7:0.05:1];
for n=1:length(D_min)
step(tf(Kp2,[T_max^2 2*D_min(n)*T_max 1]))
end
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Kp2+xuemax Kp2+xuemax],'k', 'LineWidth', 2)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 2)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 2)
axis([0 0.0006 900 1200])
grid

% Wie aus dem Diagramm von figure(2) ersichtlich ist, ist der optimale 
% Mindestdämpfungswert größer als 0,8 und kleiner als 0,85, wobei er 
% drastisch näher an der 0,85-Marke liegt. Daher wurde eine weitere, 
% genauere Simulation (Abbildung 3) durchgeführt, um den bestmöglichen 
% Wert für D_min zu finden.

figure(3)
hold on
D_min=[0.82:0.005:0.85];
for n=1:length(D_min)
step(tf(Kp2,[T_max^2 2*D_min(n)*T_max 1]))
end
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Kp2+xuemax Kp2+xuemax],'k', 'LineWidth', 2)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 2)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 2)
axis([0.0002 0.0006 1100 1115])
grid

%D_min ist 0.832.Nun soll derselbe Vorgang wiederholt werden, 
% aber diesmal zur Bestimmung der maximalen Zeitkonstante.

D_min=0.832

figure(4)
hold on
T_max2=[0.00005:0.00001:0.00015];
for n=1:length(T_max2)
step(tf(Kp2,[T_max2(n)^2 2*D_min*T_max2(n) 1]))
end
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Kp2+xuemax Kp2+xuemax],'k', 'LineWidth', 2)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 2)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 2)
axis([0 0.0006 950 1150])
grid

%Wie aus Abbildung (4) ersichtlich ist, liegt der maximale Wert der 
% Zeitkonstante zwischen 0,00012 und 0,00013 Sekunden, wobei er drastisch 
% näher bei 0,00013 liegt. Eine weitere und genauere Simulation 
%(Abbildung 5) wurde durchgeführt, um den Wert genauer zu bestimmen.

figure(5)
hold on
T_max2=[0.00012:0.000001:0.00013];
for n=1:length(T_max2)
step(tf(Kp2,[T_max2(n)^2 2*D_min*T_max2(n) 1]))
end
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 2)
plot([0 T_stop],[Kp2+xuemax Kp2+xuemax],'k', 'LineWidth', 2)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 2)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 2)
axis([0.00035 0.00043 985 995])
grid

%Von figure(5), man kann sehen, dass T_max 0.000128 ist. Mit den 
% Endergebnissen wurde eine abschließende Simulation durchgeführt, 
% um zu zeigen, wie die Grafik mit den ermittelten Werten aussieht:

D_min=0.832
T_max2=0.000128

Kp2=Apo+tol-xuemax
FPT2=tf(Kp2,[T_max2^2 2*D_min*T_max2 1]);
figure(6)
hold on
step(FPT2)
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 1)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 1)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 1)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 1)
axis([0 T_stop 900 1200])
grid

%Das einzige Problem dabei ist, dass der y-Wert niemals Kp2 erreicht, 
% wenn die Zeit ins Unendliche geht. Dies ist auf die numerischen Grenzen 
% der Simulation zurückzuführen. Da die Simulation über ein endliches 
% Zeitintervall durchgeführt wird, ist es nicht möglich, Kp2 im 
% Unendlichen genau zu erreichen. Was man tun kann, ist, die 
% Simulationsdauer auf einen sehr großen Wert einzustellen, 
% wodurch sich die Systemreaktion dem gewünschten Wert stärker annähert:
% Increase the simulation duration

t = 0:0.000001:T_stop*10;

figure(7)
hold on
step(FPT2, t)
plot([0 T_stop],[Apo+tol Apo+tol],'r', 'LineWidth', 1)
plot([0 T_stop],[Apu-tol Apu-tol],'r', 'LineWidth', 1)
plot([Tan Tan],[0 2000],'b', 'LineWidth', 1)
plot([Taus Taus],[0 2000],'b', 'LineWidth', 1)
axis([0 T_stop 900 1200])
grid

% Untersuchung, ob eine Modellreduktion notwendig oder möglich ist

%Information zu K - Werte:

K_MF=10
K_E=0.0005
K_L=1000
K_LE1=0.2

%Information zu T - Werte:

T_LE=0.000001
T_MF=0.0001
T_L=0.01

%***%

F1=tf(K_E,[0 1]);
F2=tf(K_L,[T_L 1]);
F3=tf(K_MF,[T_MF 1]);
F4=tf(K_LE1,[T_LE 1]);
F2red=tf(K_L,[0 1]);
F3red=tf(K_MF,[0 1]);
F4red=tf(K_LE1,[0 1]);

%PT3, PT2, PT1 und P0 Modelle zusammen dargestellt:

figure(8)
hold on
step(F1*F2*F3*F4)%PT3
step(F1*F2*F3*F4red)%PT2 - kleinste Zeitkonstante T_LE ist vernachlässigt
step(F1*F2*F3red*F4red)%PT1 - T_LE und T_MF sind vernachlässigt
step(F1*F2red*F3red*F4red)%P0 - alle Zeitkonstante sind vernachlässigt
legend('PT3', 'PT2', 'PT1', 'P0')
axis([0 0.08 0 1.2])
grid

% Wenn man heranzoomt, kann man sehen, dass die Linien PT3 und PT2 extrem 
% nahe beieinander liegen, was bedeutet, dass die Zeitkonstante T_LE einen 
% extrem geringen Einfluss auf die Sprungantwort hat. Daher kann man mit 
% Sicherheit sagen, dass die Anwendung einer Modellreduktion durchaus 
% möglich ist.
