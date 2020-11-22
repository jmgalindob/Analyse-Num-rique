% Comparación entre RNNoise y RNNoise_mod para voz
F = 48000; % Frecuencia de muestreo (Hz)
L = 18*F; % Duración del audio (s)

% Lectura de los audios .wav
y = audioread('clean_original.wav',[1, L]);
w = audioread('White.wav');
p = audioread('Pink.wav');
b = audioread('Brownian.wav');

% Adición de ruido
clean = y; % Original "Limpio"
white = y + 0.3*w; % Original + volumen*ruido blanco
pink = y + 0.3*p; % Original + volumen*ruido rosa
brown = y + 0.3*b; % Original + volumen*ruido café

% Lectura de los audios obtenidos de los métodos
% Audios de entrada de RNNoise
Win = audioread('AW0,3.wav');
Pin = audioread('AP0,3.wav');
Bin = audioread('AB0,3.wav');
Yin = audioread('Original.wav');

% Audios de salida de RNNoise
yw1 = audioread('AW0,3_RNNoise.wav');
yp1 = audioread('AP0,3_RNNoise.wav');
yb1 = audioread('AB0,3_RNNoise.wav');
yy1 = audioread('Original_RNNoise.wav');

% Método RNNoise modificado

% Entradas
% Redimensión de las matrices de audios de entrada
Y = Yin(1:length(yy1));
B = Bin(1:length(yb1));
P = Pin(1:length(yp1));
W = Win(1:length(yw1));

% Matrices del método modificado
% Original
ymod = (Y+yy1)/2; % Canal 1
% Original + White
wmod = (W+yw1)/2; % Canal 1
% Original + Pink
pmod = (P+yp1)/2; % Canal 1
% Original + Brown
bmod = (B+yb1)/2; % Canal 1

% Reescalamiento al intervalo [-1, 1]
ymod = (ymod-min(ymod))*(1-(-1))/(max(ymod)-min(ymod))+(-1);

wmod = (wmod-min(wmod))*(1-(-1))/(max(wmod)-min(wmod))+(-1);

pmod = (pmod-min(pmod))*(1-(-1))/(max(pmod)-min(pmod))+(-1);

bmod = (bmod-min(bmod))*(1-(-1))/(max(bmod)-min(bmod))+(-1);


% Filtro pasa bajas 
% Salidas
ymod = lowpass(ymod, 10000, F);
wmod = lowpass(wmod, 10000, F);
pmod = lowpass(pmod, 10000, F);
bmod = lowpass(bmod, 10000, F);

% Creación de audios
% audiowrite('AW0,3_mod.wav',wmod,F);
% audiowrite('AP0,3_mod.wav',pmod,F);
% audiowrite('AB0,3_mod.wav',bmod,F);
% audiowrite('Original_mod.wav',ymod,F);

% Medición de ruido resultante
Methods = {'Sans méthode', 'RNNbruit', 'RNNbruit mod'}; % Vector nombres métodos
O = [clean white pink brown]; % Array audios sin métodos
M1 = [yy1 yw1 yp1 yb1]; % Array audios con método RNNoise
M2 = [ymod wmod pmod bmod]; % Array audios con método RNNoise mod

% Inicialización y tamaño de los vectores a usar
[qY, qW, qP, qB] = deal(zeros(1,2), zeros(1,2), zeros(1,2), zeros(1,2));
for i = 1:3
    if i == 1
        X = O;
    elseif i == 2
        X = M1;
    elseif i == 3
        X = M2;
    end
    % Medición de NSR = 1 - SNR
    qY(i) = abs(1 - var(X(:,1))/var(X(:,1)));
    qW(i) = abs(1 - var(X(:,1))/var(X(:,2)));
    qP(i) = abs(1 - var(X(:,1))/var(X(:,3)));
    qB(i) = abs(1 - var(X(:,1))/var(X(:,4)));
end

% Gerenación de las tablas de resultados y Display
% Tabla ruido blanco
T1 = table(qW'*100, 'VariableNames',{'Blanc (30%)'},'RowNames', Methods);
display(T1)

% Tabla ruido rosa
T2 = table(qP'*100, 'VariableNames',{'Rose (30%)'},'RowNames', Methods);
display(T2)

% Tabla ruido café
T3 = table(qB'*100, 'VariableNames',{'Marron (30%)'},'RowNames', Methods);
display(T3)
