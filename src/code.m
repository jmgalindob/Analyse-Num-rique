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
[yw,Fyw] = audioread('AW0,3_RNNoise.wav');
[yp,Fyp] = audioread('AP0,3_RNNoise.wav');
[yb,Fyb] = audioread('AB0,3_RNNoise.wav');
[yy,Fyy] = audioread('Original_RNNoise.wav');

% Medición de ruido resultante
Methods = {'Sans méthode', 'RNNbruit', 'Butter T'}; % Vector nombres métodos
O = [clean white pink brown]; % Array audios sin métodos
M1 = [yy yw yp yb]; % Array audios con método RNNoise

% Inicialización y tamaño de los vectores a usar
[qY, qW, qP, qB] = deal(zeros(1,3), zeros(1,3), zeros(1,3), zeros(1,3));
for i = 1:2
    if i == 1
        X = O;
    else
        X = M1;
    end
    qY(i) = abs(1 - var(X(:,1))/var(X(:,1)));
    qW(i) = abs(1 - var(X(:,1))/var(X(:,2)));
    qP(i) = abs(1 - var(X(:,1))/var(X(:,3)));
    qB(i) = abs(1 - var(X(:,1))/var(X(:,4)));
end

% Valores del método Butter Teórico
qY(3) = 0;
qW(3) = 0.1;
qP(3) = 0.35;
qB(3) = 0.35;

% Gerenación de la tabla de resultados y Display
T = table(qY'*100, qW'*100, qP'*100, qB'*100, 'VariableNames',...
    {'Original', 'Blanc (30%)', 'Rose (30%)', 'Marron (30%)'}, ...
    'RowNames', Methods);
display(T)