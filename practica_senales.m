%% Vamos a cargar el audio:
[x,fs] = audioread('audio.wav');
%% Tamaño de la señal:
N = length(x);
%% Estamos construyendo un vector de tiempo:
n = 0:N-1;
%% convierte el numero de muestra en segundo real:
t = n/fs;
%% Graficar
figure;
plot(t,x);
xlabel('Segundos');
ylabel('Amplitud Señal');
title('Señal original');
%% con esto reproduzco el audio
sound(x,fs);

%% pausa
pause(N/fs);

%% desplazamiento señal    
n_formula = input ('Ingrese el valor de desplazamiento');
N= length(x);
y = zeros(N,1);
for k = 1: N
    desplazamiento = k+n_formula;
    if desplazamiento >= 1 && desplazamiento <= N
        y(k) = x(desplazamiento);
    else 
        y(k) = 0;
    end
end
%% Graficar
figure;
plot(t,y);
xlabel('Segundos');
ylabel('Amplitud Señal');
title('Señal desplazada');
%% graficar y en todo los instantes de k ya calculados en
%% en el for
sound(y,fs);

%% pausa
pause(N/fs);

%% inversion
N= length(x);
y_invertida = zeros(N,1);
for k = 1: N
    inversion = N - k + 1;
        y_invertida(k) = x(inversion);
end
%% Graficar
figure;
plot(t,y_invertida);
xlabel('Segundos');
ylabel('Amplitud Señal');
title('Señal invertida');

sound(y_invertida,fs);

%% pausa
pause(N/fs);

%% escalonamiento
alpha = input('Ingrese el valor de alpha para el escalamiento: ');
N= length(x);
%% numero de muestras:
posiciondelasenal= floor(N/alpha);
y_escalonada= zeros(posiciondelasenal,1);
for k = 1: posiciondelasenal
escalonamiento = alpha *(k-1) +1 ;
y_escalonada(k) = x(escalonamiento);
end
%% Graficar
muestras_escalonadas= 0:posiciondelasenal-1;
t_escalonado = muestras_escalonadas/fs;
figure;
plot(t_escalonado,y_escalonada);
xlabel('Segundos');
ylabel('Amplitud Señal');
title('Señal escalonada');

sound(y_escalonada,fs);
