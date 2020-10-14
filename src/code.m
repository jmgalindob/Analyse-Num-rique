F = 48000; % Frecuencia de muestreo (Hz)
L = 18*F; % Duración del audio (s)

% Lectura de los audios .wav
[y,Fy] = audioread('clean_original.wav',[1, L]);
[w,Fw] = audioread('White.wav');
[p,Fp] = audioread('Pink.wav');
[b,Fb] = audioread('Brownian.wav');


% Adición de ruido
clean = y; % Original "Limpio"
white = y + 0.3*w; % Original + volumen*ruido blanco
pink = y + 0.3*p; % Original + volumen*ruido rosa
brown = y + 0.3*b; % Original + volumen*ruido café

% Creación de audios
% audiowrite('AW0,3.wav',white,F);
% audiowrite('AP0,3.wav',pink,F);
% audiowrite('AB0,3.wav',brown,F);
% audiowrite('Original.wav',y,F);

% Lectura de los audios obtenidos de los métodos
% Método RNNoise
[yw1,Fyw1] = audioread('AW0,3_RNNoise.wav');
[yp1,Fyp1] = audioread('AP0,3_RNNoise.wav');
[yb1,Fyb1] = audioread('AB0,3_RNNoise.wav');
[yy1,Fyy1] = audioread('Original_RNNoise.wav');
% Método Wienner
[yw2,Fyw2] = audioread('AW0,3_Wienner.wav');
[yp2,Fyp2] = audioread('AP0,3_Wienner.wav');
[yb2,Fyb2] = audioread('AB0,3_Wienner.wav');
[yy2,Fyy2] = audioread('Original_Wienner.wav');

% Medición de ruido resultante
Methods = {'Sans méthode', 'RNNbruit', 'Wienner', 'Butter T'}; % Vector nombres métodos
O = [clean white pink brown]; % Array audios sin métodos
M1 = [yy1 yw1 yp1 yb1]; % Array audios con método RNNoise
M2 = [yy2 yw2 yp2 yb2]; % Array audios con método Wienner

% Inicialización y tamaño de los vectores a usar
[qY, qW, qP, qB] = deal(zeros(1,3), zeros(1,3), zeros(1,3), zeros(1,3));
for i = 1:3
    if i == 1
        X = O;
    elseif i == 2
        X = M1;
    else
        X = M2;
    end
    % Medición de NSR = 1 - SNR
    qY(i) = abs(1 - var(X(:,1))/var(X(:,1)));
    qW(i) = abs(1 - var(X(:,1))/var(X(:,2)));
    qP(i) = abs(1 - var(X(:,1))/var(X(:,3)));
    qB(i) = abs(1 - var(X(:,1))/var(X(:,4)));
end

% Valores del método Butter Teórico
qY(4) = 0;
qW(4) = 0.1;
qP(4) = 0.35;
qB(4) = 0.35;

% Gerenación de la tabla de resultados y Display
T = table(qY'*100, qW'*100, qP'*100, qB'*100, 'VariableNames',...
    {'Original', 'Blanc (30%)', 'Rose (30%)', 'Marron (30%)'}, ...
    'RowNames', Methods);
display(T)