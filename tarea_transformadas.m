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
%% menu principal
opcion = -1;
while opcion ~= 0
    fprintf('\n================= MENÚ DE TRANSFORMACIONES =================\n');
    fprintf(' 1. Desplazamiento temporal     y[n] = x[n - n0]\n');
    fprintf(' 2. Inversión temporal          y[n] = x[-n]\n');
    fprintf(' 3. Escalamiento temporal       y[n] = x[alpha n] / x[n/alpha]\n');
    fprintf(' 4. Combinación de transformaciones (y análisis del orden)\n');
    fprintf(' 5. Reproducir la señal original de nuevo\n');
    fprintf(' 0. Salir\n');
    fprintf('==============================================================\n');
    opcion = input('Seleccione una opción: ');
    if isempty(opcion), opcion = -1; end

switch opcion

    case 1

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

    case 2
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

    case 3
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
    case 0
        fprintf('\nPrograma finalizado.\n');

    case 4
       
        %% COMBINACIÓN DE TRANSFORMACIONES (desplazamiento + escalamiento)
        %% ============================================================
        n0_comb = input('Ingrese el valor de n0 para la combinación: ');
        alpha_comb = input('Ingrese el valor de alpha (entero >=2) para la combinación: ');
        N = length(x);

        %% primero ESCALAMIENTO, luego DESPLAZAMIENTO
         escalamiento  z[n] = x[alpha*n]
        posiciones1 = floor(N/alpha_comb);
        z1 = zeros(posiciones1,1);
        for k = 1:posiciones1
            idx = alpha_comb*(k-1) + 1;
            z1(k) = x(idx);
        end

        %% desplazamiento SOBRE z1 (ya escalada)  y[n] = z1[n+n0]
        N1 = length(z1);
        y_orden1 = zeros(N1,1);
        for k = 1:N1
            idx = k + n0_comb;
            if idx >= 1 && idx <= N1
                y_orden1(k) = z1(idx);
            else
                y_orden1(k) = 0;
            end
            Nc = length(y_orden1);
            y_orden1_invertida = zeros(Nc,1);
            for k = 1:Nc
                y_orden1_invertida(k) = y_orden1(Nc - k + 1);
            end
        end

        %% primero DESPLAZAMIENTO, luego ESCALAMIENTO 
        %% desplazamiento  z2[n] = x[n+n0]
        z2 = zeros(N,1);
        for k = 1:N
            idx = k + n0_comb;
            if idx >= 1 && idx <= N
                z2(k) = x(idx);
            else
                z2(k) = 0;
            end
        end

        %% escalamiento SOBRE z2 (ya desplazada)  y[n] = z2[alpha*n]
        posiciones2 = floor(N/alpha_comb);
        y_orden2 = zeros(posiciones2,1);
        for k = 1:posiciones2
            idx = alpha_comb*(k-1) + 1;
            y_orden2(k) = z2(idx);
            Nc = length(y_orden1);
            y_orden1_invertida = zeros(Nc,1);
            for k = 1:Nc
                y_orden1_invertida(k) = y_orden1(Nc - k + 1);
            end
        end

        %% Graficar ambos órdenes 
        t_orden1 = (0:length(y_orden1)-1)/fs;
        t_orden2 = (0:length(y_orden2)-1)/fs;

        figure;
        subplot(2,1,1);
        plot(t_orden1, y_orden1);
        xlabel('Segundos'); ylabel('Amplitud');
        title('Orden 1: escalamiento -> desplazamiento');

        subplot(2,1,2);
        plot(t_orden2, y_orden2);
        xlabel('Segundos'); ylabel('Amplitud');
        title('Orden 2: desplazamiento -> escalamiento');

        %% Comparar si el orden importa
        if isequal(size(y_orden1), size(y_orden2)) && max(abs(y_orden1 - y_orden2)) < 1e-9
            disp('Los dos órdenes dieron el MISMO resultado.');
        else
            disp('Los dos órdenes dieron resultados DIFERENTES: el orden sí importa.');
        end

        %% Reproducir ambos resultados
        sound(y_orden1, fs);
        pause(length(y_orden1)/fs);

        sound(y_orden2, fs);
        pause(length(y_orden2)/fs);

    case 5
        figure;
        plot(t,x);
        xlabel('Segundos');
        ylabel('Amplitud Señal');
        title('Señal original');
        sound(x,fs);
return;
    otherwise
        fprintf('Opción no válida. Intente de nuevo.\n');
end

end

