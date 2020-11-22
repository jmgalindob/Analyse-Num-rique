% RNNoise vs RNNoise_mod para canciones
% Lectura de los audios
[y,F] = audioread('Giant.wav');
w = audioread('White.wav');
p = audioread('Pink.wav');
b = audioread('Brownian.wav');

% Adición de ruido
clean = y; % Original "Limpio"
white = y + 0.3*w; % Original + volumen*ruido blanco
pink = y + 0.3*p; % Original + volumen*ruido rosa
brown = y + 0.3*b; % Original + volumen*ruido café

% Creación de audios
% audiowrite('GW0,3.wav',white,F);
% audiowrite('GP0,3.wav',pink,F);
% audiowrite('GB0,3.wav',brown,F);

% Reproductor de audio
% player = audioplayer(y, F);
% play(player); % Reproducir
% pause(player); % Pausar
% resume(player); % Resumir después de pausa
% stop(player); % Parar reproductor

% Lectura de los audios obtenidos de los métodos
% Audios de entrada de RNNoise
Win = audioread('GW0,3.wav');
Pin = audioread('GP0,3.wav');
Bin = audioread('GB0,3.wav');
Yin = y;

% Audios de salida de RNNoise
yw1 = audioread('GW0,3_RNNoise.wav');
yp1 = audioread('GP0,3_RNNoise.wav');
yb1 = audioread('GB0,3_RNNoise.wav');
yy1 = audioread('Giant_RNNoise.wav');

% Método RNNoise modificado

% Entradas
% Redimensión de las matrices de audios de entrada
Y = Yin(1:length(yy1),:);
B = Bin(1:length(yb1),:);
P = Pin(1:length(yp1),:);
W = Win(1:length(yw1),:);

% Matrices del método modificado
% Giant
ymod(:,1) = (Y(:,1)+yy1(:,1))/2; % Canal 1
ymod(:,2) = (Y(:,2)+yy1(:,2))/2; % Canal 2
% Giant + White
wmod(:,1) = (W(:,1)+yw1(:,1))/2; % Canal 1
wmod(:,2) = (W(:,2)+yw1(:,2))/2; % Canal 2
% Giant + Pink
pmod(:,1) = (P(:,1)+yp1(:,1))/2; % Canal 1
pmod(:,2) = (P(:,2)+yp1(:,2))/2; % Canal 2
% Giant + Brown
bmod(:,1) = (B(:,1)+yb1(:,1))/2; % Canal 1
bmod(:,2) = (B(:,2)+yb1(:,2))/2; % Canal 2

% Reescalamiento al intervalo [-1, 1]
ymod(:,1) = (ymod(:,1)-min(ymod(:,1)))*(1-(-1))/(max(ymod(:,1))-min(ymod(:,1)))+(-1);
ymod(:,2) = (ymod(:,2)-min(ymod(:,2)))*(1-(-1))/(max(ymod(:,2))-min(ymod(:,2)))+(-1);

wmod(:,1) = (wmod(:,1)-min(wmod(:,1)))*(1-(-1))/(max(wmod(:,1))-min(wmod(:,1)))+(-1);
wmod(:,2) = (wmod(:,2)-min(wmod(:,2)))*(1-(-1))/(max(wmod(:,2))-min(wmod(:,2)))+(-1);

pmod(:,1) = (pmod(:,1)-min(pmod(:,1)))*(1-(-1))/(max(pmod(:,1))-min(pmod(:,1)))+(-1);
pmod(:,2) = (pmod(:,2)-min(pmod(:,2)))*(1-(-1))/(max(pmod(:,2))-min(pmod(:,2)))+(-1);

bmod(:,1) = (bmod(:,1)-min(bmod(:,1)))*(1-(-1))/(max(bmod(:,1))-min(bmod(:,1)))+(-1);
bmod(:,2) = (bmod(:,2)-min(bmod(:,2)))*(1-(-1))/(max(bmod(:,2))-min(bmod(:,2)))+(-1);

% Filtro pasa bajas 
% Salidas
ymod = lowpass(ymod, 10000, F);
wmod = lowpass(wmod, 10000, F);
pmod = lowpass(pmod, 10000, F);
bmod = lowpass(bmod, 10000, F);

% Creación de audios
% audiowrite('GW0,3_mod.wav',wmod,F);
% audiowrite('GP0,3_mod.wav',pmod,F);
% audiowrite('GB0,3_mod.wav',bmod,F);
% audiowrite('Giant_mod.wav',ymod,F);

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
    qY(i) = abs(1 - abs(snr(X(:,1),X(:,1))));
    qW(i) = abs(1 - abs(snr(X(:,1),X(:,2))));
    qP(i) = abs(1 - abs(snr(X(:,1),X(:,3))));
    qB(i) = abs(1 - abs(snr(X(:,1),X(:,4))));
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


